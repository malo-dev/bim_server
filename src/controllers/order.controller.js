import bcrypt from 'bcryptjs';
import { Op } from "sequelize";
import { Order, User, Company, Product, Currency, TransactionPaiement, Transaction, Notification, Livreur } from "../models/index.js";
import sequelize from "../config/database.js";
import { getDateRangeByPeriod } from "../utils/getDateRangeByPeriod.util.js";
import { emitOrderUpdate } from "../services/socket.service.js";

export const createOrder = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { items, companyId, shippingAddress, notes, paymentMethod, clientPhone } = req.body;

    if (!items || !Array.isArray(items) || items.length === 0)
      return res.status(400).json({ message: "Le panier est vide" });
    if (!companyId)
      return res.status(400).json({ message: "companyId requis" });

    const orderNumber = `ORD-${Date.now()}-${userId}`;

    const created = await Promise.all(
      items.map((item) =>
        Order.create({
          orderNumber,
          userId,
          companyId,
          productId:       item.productId,
          quantity:        item.qty,
          unitPrice:       item.unitPrice,
          totalAmount:     parseFloat((item.qty * item.unitPrice).toFixed(2)),
          status:          "pending",
          paymentMethod:   paymentMethod || "delivery",
          shippingAddress: shippingAddress || null,
          notes:           notes || null,
          clientPhone:     clientPhone || null,
        })
      )
    );

    // Notifier les livreurs actifs de cette entreprise
    try {
      const io = emitOrderUpdate.__io ?? null;
      const { getIO } = await import('../services/socket.service.js');
      const ioInstance = getIO();
      ioInstance.emit(`company:new_order:${companyId}`, {
        orderNumber,
        companyId,
        message: 'Nouvelle commande disponible',
      });
    } catch {}

    return res.status(201).json({ orderNumber, orders: created });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

export const getUserOrders = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { status } = req.query;

    const where = { userId };
    if (status) where.status = status;

    const { Livreur } = await import('../models/index.js');

    const include = [
      { model: Company, as: "company", attributes: ["companyId", "name", "logo"] },
      { model: Product, as: "product", attributes: ["productId", "name", "imageUrl"],
        include: [{ model: Currency, as: "currency", attributes: ["code", "symbol"] }] },
      { model: Livreur, as: "livreur", required: false,
        include: [{ model: User, as: "user", attributes: ["id", "username"] }],
        attributes: ["livreurId", "telephone", "rating", "latitude", "longitude", "isOnline"] },
    ];

    const rows = await Order.findAll({ where, include, order: [["createdAt", "DESC"]] });

    // Grouper par orderNumber
    const grouped = {};
    for (const o of rows) {
      const d = o.toJSON();
      if (!grouped[d.orderNumber]) {
        grouped[d.orderNumber] = {
          orderNumber:      d.orderNumber,
          status:           d.status,
          paymentStatus:    d.paymentStatus,
          createdAt:        d.createdAt,
          company:          d.company,
          companyId:        d.companyId,
          shippingAddress:  d.shippingAddress,
          clientPhone:      d.clientPhone,
          livreur:          d.livreur ?? null,
          estimatedMinutes: d.estimatedMinutes ?? null,
          items:            [],
          grandTotal:       0,
        };
      }
      grouped[d.orderNumber].items.push({
        orderId:    d.orderId,
        product:    d.product,
        qty:        d.quantity,
        unitPrice:  d.unitPrice,
        totalAmount: d.totalAmount,
      });
      grouped[d.orderNumber].grandTotal += parseFloat(d.totalAmount);
    }

    const orders = Object.values(grouped).map(g => ({
      ...g,
      grandTotal: parseFloat(g.grandTotal.toFixed(2)),
    }));

    return res.json({ data: orders, total: orders.length });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

export const markOrderPaidOnDelivery = async (req, res) => {
  try {
    const userId      = req.user?.id;
    const { orderNumber } = req.params;

    const [count] = await Order.update(
      { status: "delivered", paymentStatus: "paid" },
      { where: { orderNumber, userId } }
    );

    if (!count) return res.status(404).json({ message: "Commande introuvable ou déjà traitée" });

    emitOrderUpdate(orderNumber, {
      orderNumber,
      status: "delivered",
      paymentStatus: "paid",
      updatedAt: new Date().toISOString(),
    });

    return res.json({ message: "Commande marquée livrée et payée", orderNumber });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

// POST /order/pay/:orderNumber — Payer commande à la livraison (PIN + split company/livreur)
export const payOrderAtDelivery = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const userId = req.user?.id;
    const { orderNumber } = req.params;
    const { pin } = req.body;

    if (!pin) {
      await t.rollback();
      return res.status(400).json({ message: "Code PIN requis" });
    }

    // 1. Find sender and verify PIN
    const sender = await User.findByPk(userId, { transaction: t, lock: t.LOCK.UPDATE });
    if (!sender) {
      await t.rollback();
      return res.status(404).json({ message: "Utilisateur introuvable" });
    }
    const pinOk = await bcrypt.compare(String(pin), sender.randomly);
    if (!pinOk) {
      await t.rollback();
      return res.status(401).json({ message: "Code PIN incorrect" });
    }

    // 2. Find all rows for this orderNumber
    const orderRows = await Order.findAll({
      where: { orderNumber, userId },
      transaction: t,
      lock: t.LOCK.UPDATE,
    });
    if (!orderRows.length) {
      await t.rollback();
      return res.status(404).json({ message: "Commande introuvable" });
    }
    if (orderRows[0].paymentStatus === 'paid') {
      await t.rollback();
      return res.status(400).json({ message: "Cette commande a déjà été payée" });
    }

    // 3. Total
    const totalAmount = parseFloat(
      orderRows.reduce((s, o) => s + parseFloat(o.totalAmount), 0).toFixed(2)
    );
    const senderBalance = parseFloat(sender.soldNumber || 0);
    if (totalAmount > senderBalance) {
      await t.rollback();
      return res.status(400).json({ message: "Solde insuffisant" });
    }

    const companyId = orderRows[0].companyId;
    const livreurId = orderRows[0].livreurId;

    // 4. Find company + commission rate
    const company = await Company.findByPk(companyId, { transaction: t });
    const COMMISSION_RATE = company ? parseFloat(company.commissionRate || 10) / 100 : 0.10;

    // Find company user via UserRole
    const companyRole = await sequelize.models.UserRole.findOne({ where: { companyId }, transaction: t });
    let recipient = companyRole
      ? await User.findByPk(companyRole.userId, { transaction: t, lock: t.LOCK.UPDATE })
      : null;
    if (!recipient) {
      recipient = await User.findOne({ where: { email: 'bimbank@bimreseau.com' }, transaction: t, lock: t.LOCK.UPDATE });
    }

    // 5. Find livreur user
    let livreurUser = null;
    let commission = 0;
    if (livreurId) {
      const liv = await Livreur.findByPk(livreurId, { transaction: t });
      if (liv?.userId) {
        livreurUser = await User.findByPk(liv.userId, { transaction: t, lock: t.LOCK.UPDATE });
        commission = parseFloat((totalAmount * COMMISSION_RATE).toFixed(2));
      }
    }
    const companyAmount = parseFloat((totalAmount - commission).toFixed(2));

    // 6. Apply balances
    await sender.update({ soldNumber: senderBalance - totalAmount }, { transaction: t });
    if (recipient) {
      await recipient.update({ soldNumber: parseFloat(recipient.soldNumber || 0) + companyAmount }, { transaction: t });
    }
    if (livreurUser && commission > 0) {
      await livreurUser.update({ soldNumber: parseFloat(livreurUser.soldNumber || 0) + commission }, { transaction: t });
    }

    // 7. Update orders
    await Order.update(
      { status: 'delivered', paymentStatus: 'paid' },
      { where: { orderNumber, userId }, transaction: t }
    );

    // 8. Transaction records
    const txRows = [
      { amount: totalAmount,   status: "réussi", description: `Paiement commande ${orderNumber}`, transactionType: "paiement", id: sender.id },
      { amount: companyAmount, status: "réussi", description: `Réception commande ${orderNumber}`, transactionType: "paiement", id: recipient?.id ?? sender.id },
    ];
    if (livreurUser && commission > 0) {
      txRows.push({ amount: commission, status: "réussi", description: `Commission livraison ${orderNumber}`, transactionType: "paiement", id: livreurUser.id });
    }
    await Transaction.bulkCreate(txRows, { transaction: t });

    // 9. Notifications
    const notifRows = [
      { title: "Paiement réussi ", message: `Paiement de ${totalAmount} EC pour la commande ${orderNumber}.`, type: "SUCCESS", userId: sender.id },
    ];
    if (livreurUser && commission > 0) {
      notifRows.push({ title: "Commission reçue ", message: `${commission} EC de commission pour la livraison ${orderNumber}.`, type: "SUCCESS", userId: livreurUser.id });
    }
    await Notification.bulkCreate(notifRows, { transaction: t });

    await t.commit();

    emitOrderUpdate(orderNumber, {
      orderNumber, status: 'delivered', paymentStatus: 'paid', updatedAt: new Date().toISOString(),
    });

    return res.json({ message: "Paiement réussi, commande livrée", orderNumber, amount: totalAmount, commission, companyAmount });
  } catch (error) {
    await t.rollback();
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

export const getOrders = async (req, res) => {
  try {
    const {
      companyId,
      productId,
      status,
      startDate,
      endDate,
      search,
      paginate = "false",
      page = 1,
      pageSize = 20,
    } = req.query;

    const isPaginate = paginate.toLowerCase() === "true";
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

    const where = {};

    if (companyId) where.companyId = companyId;
    if (productId) where.productId = productId;
    if (status) where.status = status;

    if (startDate && endDate) {
      where.createdAt = {
        [Op.between]: [new Date(startDate), new Date(endDate)],
      };
    }

    if (search) {
      where[Op.or] = [
        { orderNumber: { [Op.like]: `%${search}%` } },
        { shippingAddress: { [Op.like]: `%${search}%` } },
        { notes: { [Op.like]: `%${search}%` } },
      ];
    }

    const include = [
      { model: User, as: "user", attributes: ["id", "username", "email"] },
      { model: Company, as: "company", attributes: ["companyId", "name"] },
      { model: Product, as: "product", attributes: ["productId", "name", "price"],
        include: [{ model: Currency, as: "currency", attributes: ["code", "symbol"] }] },
    ];

    const findOptions = { where, include, order: [["createdAt", "DESC"]] };

    if (isPaginate) {
      const { rows, count } = await Order.findAndCountAll({
        ...findOptions,
        limit,
        offset,
        distinct: true,
      });
      return res.json({ data: rows, total: count, currentPage, totalPages: Math.ceil(count / limit) });
    }

    const orders = await Order.findAll(findOptions);
    return res.json({ data: orders, total: orders.length, currentPage: 1, totalPages: 1 });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

export const getOrderById = async (req, res) => {
  try {
    const order = await Order.findByPk(req.params.id, {
      include: [
        { model: User, as: "user", attributes: ["id", "username", "email"] },
        { model: Company, as: "company", attributes: ["companyId", "name"] },
        { model: Product, as: "product", attributes: ["productId", "name", "price"],
          include: [{ model: Currency, as: "currency", attributes: ["code", "symbol"] }] },
      ],
    });
    if (!order) return res.status(404).json({ message: "Commande introuvable" });
    res.json(order);
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

export const updateOrder = async (req, res) => {
  try {
    const order = await Order.findByPk(req.params.id);
    if (!order) return res.status(404).json({ message: "Commande introuvable" });
    await order.update(req.body);

    // Notifier en temps réel tous les abonnés de cette commande
    if (req.body.status && order.orderNumber) {
      const payload = {
        orderNumber: order.orderNumber,
        status: req.body.status,
        paymentStatus: order.paymentStatus,
        updatedAt: new Date().toISOString(),
      };
      emitOrderUpdate(order.orderNumber, payload);

      // Notifier directement l'utilisateur dans sa room privée
      const { emitToUser } = await import('../services/socket.service.js');
      emitToUser(String(order.userId), 'order:status_updated', payload);
    }

    res.json({ message: "Commande mise à jour avec succès", order });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

export const deleteOrder = async (req, res) => {
  try {
    const order = await Order.findByPk(req.params.id);
    if (!order) return res.status(404).json({ message: "Commande introuvable" });
    await order.destroy();
    res.json({ message: "Commande supprimée avec succès" });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

// Commandes de l'entreprise du company admin connecté
export const getCompanyOrders = async (req, res) => {
  try {
    const userId = req.user?.id;
    const userRoleRecord = await sequelize.models.UserRole.findOne({ where: { userId } });
    const companyId = userRoleRecord?.companyId;
    if (!companyId) return res.status(403).json({ message: "Aucune entreprise associée à ce compte" });

    const { status, startDate, endDate, search, page = 1, pageSize = 20 } = req.query;
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

    const where = { companyId };
    if (status) where.status = status;
    if (startDate && endDate) where.createdAt = { [Op.between]: [new Date(startDate), new Date(endDate)] };
    if (search) where[Op.or] = [{ orderNumber: { [Op.like]: `%${search}%` } }, { shippingAddress: { [Op.like]: `%${search}%` } }];

    const include = [
      { model: User, as: "user", attributes: ["id", "username", "email"] },
      { model: Company, as: "company", attributes: ["companyId", "name"] },
      { model: Product, as: "product", attributes: ["productId", "name", "price"],
        include: [{ model: Currency, as: "currency", attributes: ["code", "symbol"] }] },
    ];

    const { rows, count } = await Order.findAndCountAll({
      where, include, order: [["createdAt", "DESC"]], limit, offset, distinct: true,
    });
    return res.json({ data: rows, total: count, currentPage, totalPages: Math.ceil(count / limit) });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

// Statistiques agrégées (commandes + paiements) pour la company admin connectée
export const getMyCompanyStats = async (req, res) => {
  try {
    const userId = req.user?.id;
    const userRoleRecord = await sequelize.models.UserRole.findOne({ where: { userId } });
    const companyId = userRoleRecord?.companyId;
    if (!companyId) return res.status(403).json({ message: "Aucune entreprise associée à ce compte" });

    const { period } = req.query;
    const createdAtFilter = {};
    if (period) {
      const from = getDateRangeByPeriod(period);
      if (from) createdAtFilter.createdAt = { [Op.gte]: from };
    }

    const [orderStats, paymentStats] = await Promise.all([
      Order.findOne({
        where: { companyId, ...createdAtFilter },
        attributes: [
          [sequelize.fn("COUNT", sequelize.col("orderId")), "count"],
          [sequelize.fn("SUM", sequelize.col("totalAmount")), "totalAmount"],
        ],
        raw: true,
      }),
      TransactionPaiement.findOne({
        where: { companyId, ...createdAtFilter },
        attributes: [
          [sequelize.fn("COUNT", sequelize.col("transactionPaiementId")), "count"],
          [sequelize.fn("SUM", sequelize.col("amount")), "totalAmount"],
        ],
        raw: true,
      }),
    ]);

    return res.json({
      orders: {
        count: parseInt(orderStats?.count ?? 0),
        totalAmount: parseFloat(orderStats?.totalAmount ?? 0) || 0,
      },
      payments: {
        count: parseInt(paymentStats?.count ?? 0),
        totalAmount: parseFloat(paymentStats?.totalAmount ?? 0) || 0,
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

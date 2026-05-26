import { Op } from "sequelize";
import { Order, User, Company, Product, Currency, TransactionPaiement } from "../models/index.js";
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

    const include = [
      { model: Company, as: "company", attributes: ["companyId", "name", "logo"] },
      { model: Product, as: "product", attributes: ["productId", "name", "imageUrl"],
        include: [{ model: Currency, as: "currency", attributes: ["code", "symbol"] }] },
    ];

    const rows = await Order.findAll({ where, include, order: [["createdAt", "DESC"]] });

    // Grouper par orderNumber
    const grouped = {};
    for (const o of rows) {
      const d = o.toJSON();
      if (!grouped[d.orderNumber]) {
        grouped[d.orderNumber] = {
          orderNumber:    d.orderNumber,
          status:         d.status,
          paymentStatus:  d.paymentStatus,
          createdAt:      d.createdAt,
          company:        d.company,
          companyId:      d.companyId,
          shippingAddress: d.shippingAddress,
          clientPhone:    d.clientPhone,
          items:          [],
          grandTotal:     0,
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
      emitOrderUpdate(order.orderNumber, {
        orderNumber: order.orderNumber,
        status: req.body.status,
        paymentStatus: order.paymentStatus,
        updatedAt: new Date().toISOString(),
      });
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

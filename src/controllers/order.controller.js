import { Op } from "sequelize";
import { Order, User, Company, Product, Currency, TransactionPaiement, Transaction, Notification, Livreur } from "../models/index.js";
import sequelize from "../config/database.js";
import { getDateRangeByPeriod } from "../utils/getDateRangeByPeriod.util.js";
import { parseLocalDayStart, parseLocalDayEnd } from "../utils/dateRange.util.js";
import { emitOrderUpdate, emitToUser, emitToAdmin } from "../services/socket.service.js";
import { recordConsumptionAndMaybeGrantBonus } from "../services/loyalty.service.js";
import { notifyBimAdmins } from "../services/bimAdminNotify.service.js";
import { pushToUser } from "../services/pushNotification.service.js";

export const createOrder = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { items, companyId, shippingAddress, notes, paymentMethod, clientPhone, destinationLat, destinationLng } = req.body;

    if (!items || !Array.isArray(items) || items.length === 0)
      return res.status(400).json({ message: "Le panier est vide" });
    if (!shippingAddress || !clientPhone) {
      return res.status(400).json({ message: "L'adresse de livraison et le numÃ©ro de tÃ©lÃ©phone sont obligatoires" });
    }
    // companyId est optionnel : une commande de "produits alÃ©atoires"
    // (non rattachÃ©s Ã  une entreprise) n'a pas de companyId.

    const orderNumber = `ORD-${Date.now()}-${userId}`;

    const created = await Promise.all(
      items.map((item) =>
        Order.create({
          orderNumber,
          userId,
          companyId: companyId || null,
          productId:       item.productId,
          quantity:        item.qty,
          unitPrice:       item.unitPrice,
          totalAmount:     parseFloat((item.qty * item.unitPrice).toFixed(2)),
          status:          "pending",
          paymentMethod:   paymentMethod || "delivery",
          shippingAddress: shippingAddress || null,
          destinationLat:  destinationLat || null,
          destinationLng:  destinationLng || null,
          notes:           notes || null,
          clientPhone:     clientPhone || null,
        })
      )
    );

    const grandTotal = items.reduce((s, i) => s + i.qty * i.unitPrice, 0).toFixed(2);

    // Fiche de consommation + fidÃ©litÃ© (10 achats d'un produit â†’ le 11Ã¨me offert).
    // On ignore les commandes "bonus" elles-mÃªmes pour ne pas les recompter.
    if (paymentMethod !== 'bonus') {
      for (const order of created) {
        try { await recordConsumptionAndMaybeGrantBonus(order); } catch {}
      }
    }

    // Notify company delivery staff of new order (only when the order is tied to a company)
    try {
      const { getIO } = await import('../services/socket.service.js');
      const ioInstance = getIO();
      if (companyId) {
        ioInstance.emit(`company:new_order:${companyId}`, {
          orderNumber,
          companyId,
          message: 'Nouvelle commande disponible',
        });
      }
      // Notify admin room as well
      ioInstance.to('admin_room').emit('order:new', { orderNumber, companyId: companyId || null, userId, grandTotal });
      ioInstance.to('admin_room').emit('admin:activity', {
        kind: 'commande',
        title: 'Nouvelle commande',
        message: `Commande ${orderNumber} â€” ${grandTotal} EC.`,
        amount: grandTotal,
        reference: orderNumber,
        createdAt: new Date().toISOString(),
      });
    } catch {}

    // Push notification to the client confirming order received
    try {
      const sender = await User.findByPk(userId, { attributes: ['id', 'username', 'expoPushToken'] });
      if (sender?.expoPushToken) {
        const { sendPushNotification } = await import('../services/pushNotification.service.js');
        await sendPushNotification(
          sender.expoPushToken,
          'âœ… Commande reÃ§ue',
          `Votre commande ${orderNumber} (${grandTotal} EC) a bien Ã©tÃ© envoyÃ©e. Suivez son avancement dans l'app.`
        );
      }
      notifyBimAdmins(
        "ðŸ›’ Nouvelle commande",
        `${sender?.username ?? "Un utilisateur"} a passÃ© une commande de ${grandTotal} EC (${orderNumber}).`
      ).catch(() => {});
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

// Le livreur confirme avoir reÃ§u l'argent en espÃ¨ces Ã  la remise de la
// commande â€” on rÃ¨gle la commande directement (livrÃ©e + payÃ©e) SANS jamais
// toucher au solde EC du client : ce paiement n'est jamais passÃ© par le
// portefeuille, c'est de l'argent physique donnÃ© en main au livreur.
export const markOrderPaidOnDelivery = async (req, res) => {
  try {
    const livreurUserId = req.user?.id;
    const { orderNumber } = req.params;

    const livreur = await Livreur.findOne({ where: { userId: livreurUserId, status: 'active' } });
    if (!livreur) {
      return res.status(403).json({ message: 'Profil livreur actif requis' });
    }

    const [count] = await Order.update(
      { status: "delivered", paymentStatus: "paid", paymentMethod: "cash" },
      { where: { orderNumber, livreurId: livreur.livreurId } }
    );

    if (!count) return res.status(404).json({ message: "Commande introuvable, dÃ©jÃ  traitÃ©e, ou qui ne vous est pas assignÃ©e" });

    const orderRows = await Order.findAll({
      where: { orderNumber },
      include: [{ model: User, as: 'user', attributes: ['id', 'username'] }],
    });
    const totalAmount = parseFloat(orderRows.reduce((s, o) => s + parseFloat(o.totalAmount), 0).toFixed(2));
    const clientName = orderRows[0]?.user?.username ?? 'Un client';

    emitOrderUpdate(orderNumber, {
      orderNumber,
      status: "delivered",
      paymentStatus: "paid",
      updatedAt: new Date().toISOString(),
    });

    notifyBimAdmins(
      "ðŸ’µ Commande payÃ©e cash",
      `Commande ${orderNumber} â€” ${totalAmount} EC payÃ©s en espÃ¨ces par ${clientName} au livreur.`
    ).catch(() => {});
    emitToAdmin('admin:activity', {
      kind: 'commande',
      title: 'Commande payÃ©e cash',
      message: `Commande ${orderNumber} â€” ${totalAmount} EC payÃ©s en espÃ¨ces par ${clientName}.`,
      amount: totalAmount,
      reference: orderNumber,
      createdAt: new Date().toISOString(),
    });

    return res.json({ message: "Commande marquÃ©e livrÃ©e et payÃ©e (espÃ¨ces)", orderNumber, amount: totalAmount });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

// POST /order/pay/:orderNumber â€” Pay order at delivery (PIN, no commission â€” all to company)
export const payOrderAtDelivery = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const userId = req.user?.id;
    const { orderNumber } = req.params;

    // 1. Verify sender (paiement confirmÃ© par simple appui, sans code PIN)
    const sender = await User.findByPk(userId, { transaction: t, lock: t.LOCK.UPDATE });
    if (!sender) {
      await t.rollback();
      return res.status(404).json({ message: "Utilisateur introuvable" });
    }

    // 2. Find order rows
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
      return res.status(400).json({ message: "Cette commande a dÃ©jÃ  Ã©tÃ© payÃ©e" });
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

    // 4. Find company recipient â€” all amount goes to company (commission = 0)
    const companyRole = await sequelize.models.UserRole.findOne({ where: { companyId }, transaction: t });
    let recipient = companyRole
      ? await User.findByPk(companyRole.userId, { transaction: t, lock: t.LOCK.UPDATE })
      : null;
    if (!recipient) {
      recipient = await User.findOne({ where: { email: 'bimbank@bimreseau.com' }, transaction: t, lock: t.LOCK.UPDATE });
    }

    // 5. Apply balances â€” no commission split, full amount to company
    const newSenderBalance = parseFloat((senderBalance - totalAmount).toFixed(2));
    await sender.update({ soldNumber: newSenderBalance }, { transaction: t });
    if (recipient) {
      await recipient.update({ soldNumber: parseFloat(recipient.soldNumber || 0) + totalAmount }, { transaction: t });
    }

    // 6. Update order status â†’ delivered + paid
    await Order.update(
      { status: 'delivered', paymentStatus: 'paid' },
      { where: { orderNumber, userId }, transaction: t }
    );

    // 7. Transaction records
    await Transaction.bulkCreate([
      { amount: totalAmount, status: "rÃ©ussi", description: `Paiement commande ${orderNumber}`, transactionType: "paiement", id: sender.id },
      { amount: totalAmount, status: "rÃ©ussi", description: `RÃ©ception commande ${orderNumber}`, transactionType: "paiement", id: recipient?.id ?? sender.id },
    ], { transaction: t });

    // 8. Notification for sender
    await Notification.create(
      { title: "Paiement rÃ©ussi âœ…", message: `Paiement de ${totalAmount} EC pour la commande ${orderNumber}.`, type: "SUCCESS", userId: sender.id },
      { transaction: t }
    );

    await t.commit();

    // 9. Emit real-time events after commit
    // Update order status for all tracking this order
    emitOrderUpdate(orderNumber, {
      orderNumber, status: 'delivered', paymentStatus: 'paid', updatedAt: new Date().toISOString(),
    });
    // Notify the mobile user directly (triggers order cache invalidation)
    emitToUser(String(userId), 'order:status_updated', { orderNumber, status: 'delivered' });
    // Send wallet balance update so the home screen refreshes instantly
    emitToUser(String(userId), 'wallet:update', { soldNumber: newSenderBalance });
    // Trigger notification badge refresh
    emitToUser(String(userId), 'notification', {});
    pushToUser(userId, 'âœ… Paiement rÃ©ussi', `Paiement de ${totalAmount} EC effectuÃ©. Votre commande ${orderNumber} est livrÃ©e. Merci !`, { orderNumber }).catch(() => {});

    return res.json({ message: "Paiement rÃ©ussi, commande livrÃ©e", orderNumber, amount: totalAmount });
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
      paymentMethod,
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
    if (paymentMethod) where.paymentMethod = paymentMethod;

    if (startDate || endDate) {
      // `new Date("YYYY-MM-DD")` parse en UTC â€” avec startDate === endDate
      // (un seul jour), `Op.between` entre deux minuits UTC ne couvrait
      // quasiment aucune donnÃ©e. On couvre toute la journÃ©e calendaire locale.
      const dateWhere = {};
      if (startDate) dateWhere[Op.gte] = parseLocalDayStart(startDate);
      if (endDate) dateWhere[Op.lte] = parseLocalDayEnd(endDate);
      where.createdAt = dateWhere;
    }

    if (search) {
      where[Op.or] = [
        { orderNumber: { [Op.like]: `%${search}%` } },
        { shippingAddress: { [Op.like]: `%${search}%` } },
        { notes: { [Op.like]: `%${search}%` } },
      ];
    }

    const include = [
      { model: User, as: "user", attributes: ["id", "username", "email", "telephone"] },
      { model: Company, as: "company", attributes: ["companyId", "name"] },
      { model: Product, as: "product", attributes: ["productId", "name", "price"],
        include: [{ model: Currency, as: "currency", attributes: ["code", "symbol"] }] },
      { model: Livreur, as: "livreur", required: false,
        attributes: ["livreurId", "telephone", "rating", "latitude", "longitude", "isOnline"],
        include: [{ model: User, as: "user", attributes: ["id", "username"] }] },
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
        { model: User, as: "user", attributes: ["id", "username", "email", "telephone"] },
        { model: Company, as: "company", attributes: ["companyId", "name"] },
        { model: Product, as: "product", attributes: ["productId", "name", "price"],
          include: [{ model: Currency, as: "currency", attributes: ["code", "symbol"] }] },
        { model: Livreur, as: "livreur", required: false,
          attributes: ["livreurId", "telephone", "rating", "ratingCount", "latitude", "longitude", "isOnline", "status"],
          include: [{ model: User, as: "user", attributes: ["id", "username", "email"] }] },
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

    // Changer le STATUT d'une commande est une action d'administration
    // (confirmer/prÃ©parer/expÃ©dier/livrer/annuler) â€” rÃ©servÃ©e au staff
    // (BIM ou entreprise, cette derniÃ¨re utilisÃ©e par le portail entreprise
    // pour ses propres commandes). Les mises Ã  jour d'adresse/tÃ©lÃ©phone
    // (ex: produit offert fidÃ©litÃ©, renseignÃ©es par le client lui-mÃªme) ne
    // sont pas concernÃ©es.
    if (req.body.status) {
      const userRoleRecord = await sequelize.models.UserRole.findOne({ where: { userId: req.user.id } });
      const roleName = userRoleRecord
        ? (await sequelize.models.Role.findByPk(userRoleRecord.roleId))?.name
        : null;
      if (roleName !== 'BIM' && roleName !== 'COMPANY_ADMIN') {
        return res.status(403).json({ message: 'AccÃ¨s rÃ©servÃ© au staff BIM ou entreprise.' });
      }
    }

    // Mise Ã  jour de la ligne ciblÃ©e
    await order.update(req.body);

    // Si le statut change â†’ propager Ã  TOUTES les lignes du mÃªme orderNumber
    // (une commande multi-articles crÃ©e N lignes avec le mÃªme orderNumber)
    if (req.body.status && order.orderNumber) {
      const updatePayload = { status: req.body.status };
      if (req.body.paymentStatus) updatePayload.paymentStatus = req.body.paymentStatus;

      await Order.update(updatePayload, {
        where: {
          orderNumber: order.orderNumber,
          orderId:     { [Op.ne]: order.orderId }, // Ã©vite la double update
        },
      });

      // â”€â”€ Notifier en temps rÃ©el (socket) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      const payload = {
        orderNumber:   order.orderNumber,
        status:        req.body.status,
        paymentStatus: req.body.paymentStatus ?? order.paymentStatus,
        updatedAt:     new Date().toISOString(),
      };
      emitOrderUpdate(order.orderNumber, payload);
      emitToUser(String(order.userId), 'order:status_updated', payload);

      // â”€â”€ Push notification Ã  chaque Ã©tape â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      try {
        const STATUS_PUSH = {
          confirmed:  { title: 'âœ… Commande confirmÃ©e',      body: `Votre commande ${order.orderNumber} a Ã©tÃ© confirmÃ©e par l'entreprise.` },
          processing: { title: 'ðŸ”§ Commande en prÃ©paration', body: `Votre commande ${order.orderNumber} est en cours de prÃ©paration.`       },
          shipped:    { title: 'ðŸš´ Commande expÃ©diÃ©e !',     body: `Votre commande ${order.orderNumber} est en route. PrÃ©parez-vous Ã  recevoir votre livraison.` },
          delivered:  { title: 'ðŸ“¦ Commande livrÃ©e !',      body: `Votre commande ${order.orderNumber} a Ã©tÃ© livrÃ©e avec succÃ¨s. Merci !`   },
          cancelled:  { title: 'âŒ Commande annulÃ©e',        body: `Votre commande ${order.orderNumber} a Ã©tÃ© annulÃ©e.`                      },
        };
        const pushData = STATUS_PUSH[req.body.status];
        if (pushData) {
          const owner = await User.findByPk(order.userId, { attributes: ['id', 'expoPushToken'] });
          if (owner?.expoPushToken) {
            const { sendPushNotification } = await import('../services/pushNotification.service.js');
            sendPushNotification(owner.expoPushToken, pushData.title, pushData.body).catch(() => {});
          }
        }
      } catch {}
    }

    res.json({ message: "Commande mise Ã  jour avec succÃ¨s", order });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

export const deleteOrder = async (req, res) => {
  try {
    const order = await Order.findByPk(req.params.id);
    if (!order) return res.status(404).json({ message: "Commande introuvable" });
    await order.destroy();
    res.json({ message: "Commande supprimÃ©e avec succÃ¨s" });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

// Commandes de l'entreprise du company admin connectÃ©
export const getCompanyOrders = async (req, res) => {
  try {
    const userId = req.user?.id;
    const userRoleRecord = await sequelize.models.UserRole.findOne({ where: { userId } });
    const companyId = userRoleRecord?.companyId;
    if (!companyId) return res.status(403).json({ message: "Aucune entreprise associÃ©e Ã  ce compte" });

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

// Statistiques agrÃ©gÃ©es (commandes + paiements) pour la company admin connectÃ©e
export const getMyCompanyStats = async (req, res) => {
  try {
    const userId = req.user?.id;
    const userRoleRecord = await sequelize.models.UserRole.findOne({ where: { userId } });
    const companyId = userRoleRecord?.companyId;
    if (!companyId) return res.status(403).json({ message: "Aucune entreprise associÃ©e Ã  ce compte" });

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


/* â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
 * Ã‰conomies du mois â€” carte Â« Tu as Ã©conomisÃ© ce mois-ci Â» de l'accueil.
 * GET /order/my-savings
 * Ã©conomie d'une ligne = (prix catalogue Ã— quantitÃ©) âˆ’ montant payÃ©, si > 0.
 * Les commandes annulÃ©es ne comptent pas.
 * â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ */
export const getMySavings = async (req, res) => {
  try {
    const userId = req.user?.id;
    const now = new Date();
    const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);

    const rows = await Order.findAll({
      where: { userId, createdAt: { [Op.gte]: monthStart }, status: { [Op.ne]: 'cancelled' } },
      include: [{ model: Product, as: 'product', attributes: ['productId', 'price', 'reduction'] }],
    });

    let saved = 0;
    let spent = 0;
    for (const o of rows) {
      const qty = parseInt(o.quantity || 1, 10);
      const paid = parseFloat(o.totalAmount || 0);
      const catalogue = parseFloat(o.product?.price || 0) * qty;
      spent += paid;
      if (catalogue > paid) saved += catalogue - paid;
    }

    return res.json({
      saved: parseFloat(saved.toFixed(2)),
      spent: parseFloat(spent.toFixed(2)),
      orders: new Set(rows.map((r) => r.orderNumber)).size,
      since: monthStart.toISOString(),
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};


/* â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
 * PrÃ©paiement en EC d'une commande (parcours Â« Payer avec Mes Ecoins Â»).
 * POST /order/prepay/:orderNumber
 * DÃ©bite le solde du client et crÃ©dite l'entreprise (ou BIM), marque la
 * paiement Â« paid Â» â€” le statut reste Â« pending Â» pour qu'elle apparaisse
 * toujours dans les commandes disponibles des livreurs (filtre status: 'pending').
 * â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ */
export const prepayOrder = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const userId = req.user?.id;
    const { orderNumber } = req.params;

    const sender = await User.findByPk(userId, { transaction: t, lock: t.LOCK.UPDATE });
    if (!sender) { await t.rollback(); return res.status(404).json({ message: "Utilisateur introuvable" }); }

    const orderRows = await Order.findAll({ where: { orderNumber, userId }, transaction: t, lock: t.LOCK.UPDATE });
    if (!orderRows.length) { await t.rollback(); return res.status(404).json({ message: "Commande introuvable" }); }
    if (orderRows[0].paymentStatus === 'paid') { await t.rollback(); return res.status(400).json({ message: "Cette commande a dÃ©jÃ  Ã©tÃ© payÃ©e" }); }
    if (orderRows[0].status === 'cancelled') { await t.rollback(); return res.status(400).json({ message: "Cette commande a Ã©tÃ© annulÃ©e" }); }

    const totalAmount = parseFloat(orderRows.reduce((s, o) => s + parseFloat(o.totalAmount), 0).toFixed(2));
    const senderBalance = parseFloat(sender.soldNumber || 0);
    if (totalAmount > senderBalance) { await t.rollback(); return res.status(400).json({ message: "Solde insuffisant. Recharge ton compte ou choisis un autre moyen de paiement." }); }

    const companyId = orderRows[0].companyId;
    let recipient = null;
    if (companyId) {
      const companyRole = await sequelize.models.UserRole.findOne({ where: { companyId }, transaction: t });
      if (companyRole) recipient = await User.findByPk(companyRole.userId, { transaction: t, lock: t.LOCK.UPDATE });
    }
    if (!recipient) {
      recipient = await User.findOne({ where: { email: 'bimbank@bimreseau.com' }, transaction: t, lock: t.LOCK.UPDATE });
    }

    const newSenderBalance = parseFloat((senderBalance - totalAmount).toFixed(2));
    await sender.update({ soldNumber: newSenderBalance }, { transaction: t });
    if (recipient && recipient.id !== sender.id) {
      await recipient.update({ soldNumber: parseFloat((parseFloat(recipient.soldNumber || 0) + totalAmount).toFixed(2)) }, { transaction: t });
    }

    await Order.update(
      { paymentStatus: 'paid', paymentMethod: 'ec' },
      { where: { orderNumber, userId }, transaction: t }
    );

    await Transaction.bulkCreate([
      { amount: totalAmount, status: "rÃ©ussi", description: `Paiement commande ${orderNumber}`, transactionType: "paiement", id: sender.id },
      { amount: totalAmount, status: "rÃ©ussi", description: `RÃ©ception commande ${orderNumber}`, transactionType: "paiement", id: recipient?.id ?? sender.id },
    ], { transaction: t });

    await Notification.create(
      { title: "Paiement rÃ©ussi âœ…", message: `Paiement de ${totalAmount} EC pour la commande ${orderNumber}. Ta livraison arrive.`, type: "SUCCESS", userId: sender.id },
      { transaction: t }
    );

    await t.commit();

    emitOrderUpdate(orderNumber, { orderNumber, status: orderRows[0].status, paymentStatus: 'paid', updatedAt: new Date().toISOString() });
    emitToUser(String(userId), 'order:status_updated', { orderNumber, status: orderRows[0].status });
    emitToUser(String(userId), 'wallet:update', { soldNumber: newSenderBalance });
    emitToUser(String(userId), 'notification', {});
    pushToUser(userId, 'âœ… Paiement rÃ©ussi', `Paiement de ${totalAmount} EC pour la commande ${orderNumber}. Ta livraison arrive.`, { orderNumber }).catch(() => {});

    return res.json({ message: "Paiement rÃ©ussi", orderNumber, amount: totalAmount, soldNumber: newSenderBalance });
  } catch (error) {
    await t.rollback();
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

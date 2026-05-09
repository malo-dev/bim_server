import { Op } from "sequelize";
import { Order, User, Company, Product, Currency } from "../models/index.js";

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

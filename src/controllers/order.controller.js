import { Op } from "sequelize";
import Order from "../models/Order.model.js";
import TransactionPaiement from "../models/TransactionPaiement.model.js";

export const getOrders = async (req, res) => {
  try {
    const {
      companyId,
      productId,
      orderId,
      startDate,
      endDate,
      search,
    } = req.query;

    let where = {};

    if (companyId) where.companyId = companyId;
    if (productId) where.productId = productId;
    if (orderId) where.orderId = orderId;

    if (startDate && endDate) {
      where.createdAt = {
        [Op.between]: [new Date(startDate), new Date(endDate)],
      };
    }

    if (search) {
      where[Op.or] = [
        { orderNumber: { [Op.like]: `%${search}%` } },
        { notes: { [Op.like]: `%${search}%` } },
      ];
    }

    const orders = await Order.findAll({
      where,
      order: [["createdAt", "DESC"]],
    });

    res.json(orders);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Erreur serveur" });
  }
};


export const getOrderById = async (req, res) => {
  try {
    const order = await Order.findByPk(req.params.id);

    if (!order) {
      return res.status(404).json({ message: "Order introuvable" });
    }

    res.json(order);
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur" });
  }
};


export const updateOrder = async (req, res) => {
  try {
    const order = await Order.findByPk(req.params.id);

    if (!order) {
      return res.status(404).json({ message: "Order introuvable" });
    }

    await order.update(req.body);

    res.json({
      message: "Order mis à jour avec succès",
      order,
    });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur" });
  }
};


export const deleteOrder = async (req, res) => {
  try {
    const order = await Order.findByPk(req.params.id);

    if (!order) {
      return res.status(404).json({ message: "Order introuvable" });
    }

    await order.destroy();

    res.json({
      message: "Order supprimé avec succès",
    });
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur" });
  }
};

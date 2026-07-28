import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";
import User from "./User.model.js";

const Order = sequelize.define(
  "Order",
  {
    orderId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    orderNumber: {
      type: DataTypes.STRING(100),
      allowNull: false,
      validate: { notEmpty: true },
    },

    userId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    companyId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    productId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    quantity: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 1,
      validate: { min: 1 },
    },

    unitPrice: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      defaultValue: 0,
    },

    totalAmount: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      validate: { min: 0 },
    },

    status: {
      type: DataTypes.ENUM(
        "pending",
        "confirmed",
        "paid",
        "processing",
        "shipped",
        "delivered",
        "cancelled"
      ),
      allowNull: false,
      defaultValue: "pending",
    },

    paymentMethod: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },

    shippingAddress: {
      type: DataTypes.TEXT,
      allowNull: true,
    },

    notes: {
      type: DataTypes.TEXT,
      allowNull: true,
    },

    clientPhone: {
      type: DataTypes.STRING(30),
      allowNull: true,
    },

    paymentStatus: {
      type: DataTypes.ENUM("pending", "paid", "refunded"),
      defaultValue: "pending",
      allowNull: false,
    },

    livreurId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    estimatedMinutes: {
      type: DataTypes.INTEGER,
      allowNull: true,
      defaultValue: null,
    },
  },
  {
    tableName: "orders",
    timestamps: true,
    indexes: [],
  }
);

export default Order;

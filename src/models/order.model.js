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
      references: {
        model: User,
        key: "id",
      },
      onUpdate: "CASCADE",
      onDelete: "SET NULL",
    },

    companyId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: "companies",
        key: "companyId",
      },
      onUpdate: "CASCADE",
      onDelete: "SET NULL",
    },

    productId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "products", // remplacer par la table réelle des produits
        key: "productId",
      },
      onUpdate: "CASCADE",
      onDelete: "RESTRICT",
    },

    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: "branch_tracks",
        key: "branchTrackId",
      },
      onUpdate: "CASCADE",
      onDelete: "SET NULL",
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
      allowNull: false,
    },

    notes: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  },
  {
    tableName: "orders",
    timestamps: true,
    indexes: [
      {
        unique: true,
        fields: ["orderNumber"],
      },
    ],
  }
);

export default Order;

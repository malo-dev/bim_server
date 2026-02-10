import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const TransactionPaiement = sequelize.define(
  "TransactionPaiement",
  {
    transactionPaiementId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    amount: {
      type: DataTypes.FLOAT,
      allowNull: false,
      validate: { min: 0 },
    },

    description: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },

    targetId: {
      type: DataTypes.STRING(150),
      allowNull: false,
      validate: { notEmpty: true },
    },

    productId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: "products", // ou STRING si c’est volontaire
        key: "productId",
      },
      onUpdate: "CASCADE",
      onDelete: "SET NULL",
    },

    userId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "users",
        key: "id",
      },
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    },
  },
  {
    tableName: "transactions_recharge",
    timestamps: true,
    underscored: false,
  }
);

export default TransactionPaiement;

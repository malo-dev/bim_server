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
     companyId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    productId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    userId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
  },
  {
    tableName: "transactions_recharge",
    timestamps: true,
    underscored: false,
  }
);

export default TransactionPaiement;

import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const Transaction = sequelize.define(
  "Transaction",
  {
    transactionId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },

    amount: {
      type: DataTypes.FLOAT,
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM("réussi", "échoué", "en attente","annuler"),
      defaultValue: "réussi",
    },

    description: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    transactionType: {
     type: DataTypes.ENUM("retrait", "recharge", "transfert","paiement"),
      defaultValue: "Paiement",
    },

    transactionDate: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "users",
        key: "id",
      },
    },

    branchTrackId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: true,
      references: {
        model: "branchTracks",
        key: "branchTrackId",
      },
    },

    commerceId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: true,
      references: {
        model: "commerces",
        key: "commerceId",
      },
    },
  },
  {
    tableName: "transactions",
    timestamps: true,
  }
);

export default Transaction;

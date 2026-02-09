import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const TransactionPaiement = sequelize.define(
  "TransactionPaiement",
  {
    transactionPaiementId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    amount: {
      type: DataTypes.FLOAT,
      allowNull: false,
    },
    description: {
      type: DataTypes.STRING,
      allowNull: true,
    },

     targetId : {
      type: DataTypes.STRING,
      allowNull: false,
    },

     productId : {
      type: DataTypes.STRING,
      allowNull: true,
    },
    
    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "users",
        key: "id",
      },
    },
  },
  {
    tableName: "transactionsRecharge",
    timestamps: true,
  }
);

export default TransactionPaiement;

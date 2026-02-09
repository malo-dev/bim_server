import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const TransactionRecharge = sequelize.define(
  "TransactionRecharge",
  {
    transactionRechargeId: {
      type: DataTypes.INTEGER.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
    },
    amount: {
      type: DataTypes.FLOAT,
      allowNull: false,
      validate: { notEmpty: true },
    },
    telephone: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    reference: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notEmpty: true },
    },
    status: {
      type: DataTypes.ENUM("pending", "success", "failed"),
      defaultValue: "pending",
    },
    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "users",
        key: "id",
      },
      onUpdate: "CASCADE",
      onDelete: "RESTRICT",
    },
  },
  {
    tableName: "transactionsRecharge",
    timestamps: true,
    indexes: [
      {
        unique: true,
        fields: ["reference"], // unicité via index
      },
    ],
  }
);

export default TransactionRecharge;

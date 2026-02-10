import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const Currency = sequelize.define(
  "Currency",
  {
    currencyId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    code: {
      type: DataTypes.STRING(10),
      allowNull: false,
      validate: { notEmpty: true },
    },

    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
      validate: { notEmpty: true },
    },

    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },

    symbol: {
      type: DataTypes.STRING(10),
      allowNull: true,
    },

    rate: {
      type: DataTypes.FLOAT,
      allowNull: true,
      validate: {
        min: 0,
      },
    },
  },
  {
    tableName: "currencies",
    timestamps: true,
    underscored: false,
    indexes: [
      {
        unique: true,
        fields: ["code"],
      },
    ],
  }
);

export default Currency;

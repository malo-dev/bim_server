import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const History = sequelize.define(
  "History",
  {
    historyId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    type: {
      type: DataTypes.STRING(100),
      allowNull: false,
      validate: { notEmpty: true },
    },

    amount: {
      type: DataTypes.FLOAT,
      allowNull: true,
      validate: { min: 0 },
    },

    action: {
      type: DataTypes.STRING(150),
      allowNull: true,
    },

    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },

    status: {
      type: DataTypes.ENUM("réussi", "échoué", "en attente"),
      allowNull: false,
      defaultValue: "réussi",
    },

    date: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },

    userId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: "users",
        key: "id",
      },
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    },
  },
  {
    tableName: "histories",
    timestamps: true,
    underscored: false,
  }
);

export default History;

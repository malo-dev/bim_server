import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";


const History = sequelize.define(
  "History",
  {
    historyId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },

    type: {
      type: DataTypes.STRING, 
      allowNull: false,
    },

    amount: {
      type: DataTypes.FLOAT,
      allowNull: true,
    },

    action: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    description: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    status: {
      type: DataTypes.ENUM("réussi", "échoué", "en attente"),
      defaultValue: "réussi",
    },

    date: {
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
      onDelete: "CASCADE",
    },
  },
  {
    tableName: "histories",
    timestamps: true,
  }
);

export default History;

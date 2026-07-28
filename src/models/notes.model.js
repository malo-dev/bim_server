import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";
import User from "./User.model.js";

const Notes = sequelize.define(
  "Notes",
  {
    noteId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    userId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    companyId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    productId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    totalStars: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

   
    notes: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  },
  {
    tableName: "notes",
    timestamps: true,
  }
);

export default Notes;

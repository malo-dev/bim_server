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
      references: {
        model: User,
        key: "id",
      },
      onUpdate: "CASCADE",
      onDelete: "SET NULL",
    },

    companyId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "companies",
        key: "companyId",
      },
      onUpdate: "CASCADE",
      onDelete: "RESTRICT",
    },

    productId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: "products",
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

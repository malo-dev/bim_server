import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const Category = sequelize.define(
  "Category",
  {
    categoryId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    name: {
      type: DataTypes.STRING(150),
      allowNull: false,
      validate: {
        notEmpty: true,
      },
    },

    description: {
      type: DataTypes.TEXT,
      allowNull: false,
      validate: {
        notEmpty: true,
      },
    },

    commerceId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
  },
  {
    tableName: "categories",
    timestamps: true,
    underscored: false,
    indexes: [
      {
        unique: true,
        fields: ["name", "commerceId"], // unicité logique
      },
    ],
  }
);

export default Category;

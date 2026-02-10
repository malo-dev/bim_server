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
      references: {
        model: "commerces",
        key: "commerceId",
      },
      onUpdate: "CASCADE",
      onDelete: "SET NULL",
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

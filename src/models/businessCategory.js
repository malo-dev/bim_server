import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const BusinessCategory = sequelize.define(
  "BusinessCategory",
  {
    businessId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },

    name: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        notEmpty: true,
      },
    },

    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },

    logo: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    imageUrl: {
      type: DataTypes.STRING,
      allowNull: true,
    },
  },
  {
    tableName: "businessCategories",
    timestamps: true,
    indexes: [
      {
        unique: true,
        fields: ["name"], // ici on met l'unicité via index
      },
    ],
  }
);

export default BusinessCategory;

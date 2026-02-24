import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";
import Currency from "./currency.model.js";

const Product = sequelize.define(
  "Product",
  {
    productId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    name: {
      type: DataTypes.STRING(200),
      allowNull: false,
      validate: { notEmpty: true },
    },


     Warning: {
      type: DataTypes.STRING(400),
      allowNull: true,
      validate: { notEmpty: true },
    },


    price: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      validate: { min: 0 },
    },

     reduction: {
      type: DataTypes.INTEGER,
      allowNull: 'true',
    },


    description: {
      type: DataTypes.TEXT,
      allowNull: false,
      validate: { notEmpty: true },
    },
    unityMesure: {
      type: DataTypes.TEXT,
      allowNull: true
    },

    TVA: {
      type: DataTypes.DECIMAL(5, 2),
      allowNull: true,
      validate: { min: 0 },
    },

    EAN: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },

    qty: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: { min: 0 },
    },

    threshold: {  // renommé pour cohérence
      type: DataTypes.INTEGER,
      allowNull: true,
      validate: { min: 0 },
    },

    expiredAt: {
      type: DataTypes.DATE,
      allowNull: true,
      set(value) {
        if (value) this.setDataValue("expiredAt", new Date(value));
      },
    },

    availability: {  // renommé pour cohérence camelCase
      type: DataTypes.STRING(50),
      allowNull: true,
    },

    imageUrl: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    currencyId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: Currency,
        key: "currencyId",
      },
      onUpdate: "CASCADE",
      onDelete: "RESTRICT",
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

     companyId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: "companies",
        key: "companyId",
      },
      onUpdate: "CASCADE",
      onDelete: "SET NULL",
    },


    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: "branchTracks",
        key: "branchTrackId",
      },
      onUpdate: "CASCADE",
      onDelete: "SET NULL",
    },
  },
  {
    tableName: "products",
    timestamps: true,
  }
);

export default Product;

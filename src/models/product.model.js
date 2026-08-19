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
      allowNull: true,
    },
    unityMesure: {
      type: DataTypes.TEXT,
      allowNull: true
    },

    TVA: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    EAN: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },

    qty: {
      type: DataTypes.DECIMAL(15, 4),
      allowNull: true,
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
      allowNull: true,
    },

    commerceId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

     companyId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },


    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    isRecommended: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },

    isUpselling: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },

    // Prix "à discuter" : affiché à la place du prix chiffré sur l'app.
    priceOnRequest: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },

    // Galerie d'images supplémentaires (en plus de imageUrl, l'image de couverture).
    images: {
      type: DataTypes.JSON,
      allowNull: true,
    },
  },
  {
    tableName: "products",
    timestamps: true,
  }
);

export default Product;

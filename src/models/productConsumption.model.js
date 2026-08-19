import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

// "Fiche de consommation" : une ligne par achat d'un produit (issue d'une
// commande). Sert de base à l'historique consultable dans admin-bimnext et
// au programme de fidélité (10 achats d'un même produit = le 11ème offert).
const ProductConsumption = sequelize.define(
  "ProductConsumption",
  {
    consumptionId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    userId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    productId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    orderId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    companyId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    quantity: {
      type: DataTypes.DECIMAL(15, 4),
      allowNull: false,
      defaultValue: 1,
    },

    unityMesure: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },

    unitPrice: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      defaultValue: 0,
    },

    totalPaid: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      defaultValue: 0,
    },

    // "Signature" : nom de l'utilisateur au moment de la consommation
    // (affiché tel quel dans la fiche admin, sans dépendre d'un compte encore actif).
    signatureName: {
      type: DataTypes.STRING(150),
      allowNull: true,
    },

    // true = cette ligne est le produit offert (bonus fidélité), pas un achat payant.
    isBonus: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },

    consumedAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    tableName: "product_consumptions",
    timestamps: true,
  }
);

export default ProductConsumption;

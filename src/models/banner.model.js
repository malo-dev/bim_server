import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const Banner = sequelize.define(
  "Banner",
  {
    bannerId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    title: {
      type: DataTypes.STRING(150),
      allowNull: false,
      validate: { notEmpty: true },
    },

    // Phrase accrocheuse (ex: "Livraison rassurée, partout à Kinshasa")
    tagline: {
      type: DataTypes.STRING(200),
      allowNull: true,
    },

    imageUrl: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    // Route interne de l'app à ouvrir au clic (ex: /bim-carburant/12) ou lien externe
    linkUrl: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },

    position: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0,
    },

    isActive: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: true,
    },
  },
  {
    tableName: "banners",
    timestamps: true,
  }
);

export default Banner;

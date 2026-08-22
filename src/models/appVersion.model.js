import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

// Une ligne par plateforme (android/ios) que l'admin met à jour à chaque
// publication PlayStore/App Store, pour permettre à l'app de se comparer
// à la dernière version publiée.
const AppVersion = sequelize.define(
  "AppVersion",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    platform: {
      type: DataTypes.ENUM("android", "ios"),
      allowNull: false,
    },

    latestVersion: {
      type: DataTypes.STRING(20),
      allowNull: false,
    },

    minSupportedVersion: {
      type: DataTypes.STRING(20),
      allowNull: true,
    },

    storeUrl: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },

    releaseNotes: {
      type: DataTypes.TEXT,
      allowNull: true,
    },

    forceUpdate: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },

    // Interrupteur global : si false, l'app n'affiche jamais la bannière de
    // mise à jour pour cette plateforme, quelle que soit la version installée.
    promptEnabled: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: true,
    },
  },
  {
    tableName: "app_versions",
    timestamps: true,
    indexes: [
      {
        unique: true,
        fields: ["platform"],
      },
    ],
  }
);

export default AppVersion;

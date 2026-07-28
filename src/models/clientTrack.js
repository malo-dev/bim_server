import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const ClientTrack = sequelize.define(
  "ClientTrack",
  {
    clientTrackId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    name: {
      type: DataTypes.STRING(150),
      allowNull: false,
      validate: { notEmpty: true },
    },

    email: {
      type: DataTypes.STRING(255),
      allowNull: false,
      validate: { notEmpty: true, isEmail: true },
    },

    description: {
      type: DataTypes.TEXT,
      allowNull: false,
      validate: { notEmpty: true },
    },

    imageUrl: {
      type: DataTypes.STRING(500),
      allowNull: true,
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
    tableName: "client_tracks",
    timestamps: true,
    underscored: false,
    indexes: [
      {
        unique: true,
        fields: ["email"],
      },
    ],
  }
);

export default ClientTrack;

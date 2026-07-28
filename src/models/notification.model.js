import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";
import User from "./User.model.js";
import Commerce from "./commerce.model.js";
import ExpeTrack from "./expetrack.model.js";

const Notification = sequelize.define(
  "Notification",
  {
    notificationId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    title: {
      type: DataTypes.STRING(200),
      allowNull: false,
      validate: { notEmpty: true },
    },

    global: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },

    message: {
      type: DataTypes.TEXT,
      allowNull: false,
      validate: { notEmpty: true },
    },

    type: {
      type: DataTypes.ENUM(
        "INFO",
        "SUCCESS",
        "ERREUR",
        "EXPEDITION",
        "RECEPTION",
        "ALERTE",
        "LITIGE"
      ),
      allowNull: false,
      defaultValue: "INFO",
    },

    isRead: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },

    expeTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    userId: {
      type: DataTypes.INTEGER,
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
    tableName: "notifications",
    timestamps: true,
    underscored: false,
  }
);

export default Notification;

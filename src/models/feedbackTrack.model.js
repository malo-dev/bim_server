import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const FeedBackTrack = sequelize.define(
  "FeedBackTrack",
  {
    feedBackTrackId: {
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
      allowNull: true,
      validate: { isEmail: true },
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
    tableName: "feedback_tracks",
    timestamps: true,
    underscored: false,
  }
);

export default FeedBackTrack;

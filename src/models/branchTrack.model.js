import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const BranchTrack = sequelize.define(
  "BranchTrack",
  {
    branchTrackId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    branchTrackName: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },

    branchTrackEmail: {
      type: DataTypes.STRING(255),
      allowNull: false,
      validate: {
        isEmail: true,
      },
    },

    commerceId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    imageUrl: {
      type: DataTypes.STRING(500),
      allowNull: true,
    },
  },
  {
    tableName: "branchTracks",
    timestamps: true,
    underscored: false,
    indexes: [
      {
        unique: true,
        fields: ["branchTrackEmail"],
      },
    ],
  }
);

export default BranchTrack;

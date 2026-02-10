import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const Company = sequelize.define(
  "Company",
  {
    companyId: {
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

    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },

    logo: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },

    location: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },

    email: {
      type: DataTypes.STRING(255),
      allowNull: false,
      validate: { notEmpty: true, isEmail: true },
    },

    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: "branch_tracks",
        key: "branchTrackId",
      },
      onUpdate: "CASCADE",
      onDelete: "SET NULL",
    },

    imageUrl: {
      type: DataTypes.STRING(500),
      allowNull: true,
    },
  },
  {
    tableName: "companies",
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

export default Company;

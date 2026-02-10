import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";
import User from "./User.model.js";

const Commerce = sequelize.define(
  "Commerce",
  {
    commerceId: {
       type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    commerceName: {
      type: DataTypes.STRING(150),
      allowNull: false,
      validate: { notEmpty: true },
    },

    commerceEmail: {
      type: DataTypes.STRING(255),
      allowNull: false,
      validate: { notEmpty: true, isEmail: true },
    },

    userId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: User,
        key: "id",
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
    tableName: "commerces",
    timestamps: true,
    underscored: false,
    indexes: [
      {
        unique: true,
        fields: ["commerceEmail"],
      },
    ],
  }
);

export default Commerce;

import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const Bonus = sequelize.define(
  "Bonus",
  {
    bonusId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    bonusAccount: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },

    userId: {
      type: DataTypes.INTEGER,
      allowNull: true, // requis pour SET NULL
      references: {
        model: "users", // nom exact de la table
        key: "id",
      },
      onUpdate: "CASCADE",
      onDelete: "SET NULL",
    },

    companyId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "companies", // nom exact de la table
        key: "companyId",
      },
      onUpdate: "CASCADE",
      onDelete: "RESTRICT",
    },
  },
  {
    tableName: "bonus",
    timestamps: true,
    underscored: false,
  }
);

export default Bonus;

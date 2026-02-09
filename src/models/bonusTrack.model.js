import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const Bonus = sequelize.define(
  "Bonus",
  {
    bonusId: {
      type: DataTypes.INTEGER.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
    },

    bonusAccount: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
  
 
      references: {
        model: "users",
        key: "id",
      },

       onUpdate: 'CASCADE',
  onDelete: 'SET NULL',
    },

    companyId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: false,
      references: {
        model: "companies",
        key: "companyId",
      },
    },
  },
  {
    tableName: "bonus",
    timestamps: true,
  }
);

export default Bonus;

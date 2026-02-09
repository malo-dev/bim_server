import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const TransactionRetrait = sequelize.define(
  "TransactionRetrait",
  {
    transactionRetraiId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },

    amount: {
      type: DataTypes.FLOAT,
      allowNull: false,
    },
    
    targetId: {
      type: DataTypes.INTEGER,
      allowNull:false
    },
    
    
    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "users",
        key: "id",
      },
    },

    branchTrackId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: true,
      references: {
        model: "branchTracks",
        key: "branchTrackId",
      },
    },

    commerceId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: true,
      references: {
        model: "commerces",
        key: "commerceId",
      },
    },
  },
  {
    tableName: "transactionsRetrait",
    timestamps: true,
  }
);

export default TransactionRetrait;

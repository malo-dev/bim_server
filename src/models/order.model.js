import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";
import User from "./User.model.js";
const Order = sequelize.define(
  "Order",
  {
    orderId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },

    orderNumber: {
      type: DataTypes.STRING,
      allowNull: false,
    },

     id: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: User,
        key: 'id',
      },},

       companyId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "companies",
        key: "companyId",
      }
    
    },

      productId: {
      type: DataTypes.INTEGER,
     allowNull: false,

        references: {
        model: "companies",
        key: "companyId",
      }
    },
     branchTrackId: {
  type: DataTypes.INTEGER.UNSIGNED,
  allowNull: true,
  references: {
    model: 'branchTracks',
    key: 'branchTrackId',
  },
  onUpdate: 'CASCADE',
  onDelete: 'SET NULL',
},
      

    totalAmount: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
    },

    status: {
      type: DataTypes.ENUM(
        "pending",
        "confirmed",
        "paid",
        "processing",
        "shipped",
        "delivered",
        "cancelled"
      ),
      defaultValue: "pending",
    },

    paymentMethod: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    shippingAddress: {
      type: DataTypes.TEXT,
      allowNull: false,
    },

    notes: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  },
  {
    tableName: "orders",
    timestamps: true,
    indexes: [
      {
        unique: true,
        fields: ['orderNumber'],
      },
    ],

  }
);

export default Order;

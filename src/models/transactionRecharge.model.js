import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const TransactionRecharge = sequelize.define(
  'TransactionRecharge',
  {
    transactionRechargeId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    amount: {
      type: DataTypes.FLOAT,
      allowNull: false,
      validate: { min: 0.01 },
    },

    telephone: {
      type: DataTypes.STRING(20),
      allowNull: true,
      comment: 'Numéro de téléphone associé à la recharge',
    },

    reference: {
      type: DataTypes.STRING(100),
      allowNull: false,
      validate: { notEmpty: true },
      comment: 'Référence unique de la recharge',
    },

    orderNumber: {
      type: DataTypes.STRING(100),
      allowNull: true,
      comment: 'orderNumber retourné par FlexPay',
    },

    status: {
      type: DataTypes.ENUM('pending', 'success', 'failed'),
      defaultValue: 'pending',
      comment: 'Statut de la recharge',
    },

    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      comment: 'Référence de l’utilisateur',
    },
  },
  {
    tableName: 'transactionsRecharge',
    timestamps: true,
    indexes: [
      {
        unique: true,
        fields: ['reference'],
      },
    ],
  }
);

export default TransactionRecharge;

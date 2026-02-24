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
      validate: {
        min: 1,   
        max: 1000,
      },
      comment: 'Montant du retrait (min: 5$, max: 1000$)',
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

    status: {
      type: DataTypes.ENUM('pending', 'success', 'failed'),
      defaultValue: 'pending',
      comment: 'Statut de la recharge',
    },

    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'users',
        key: 'id',
      },
      onUpdate: 'CASCADE',
      onDelete: 'RESTRICT',
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

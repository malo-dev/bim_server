import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Transaction = sequelize.define(
  'Transaction',
  {
    transactionId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    amount: {
      type: DataTypes.FLOAT,
      allowNull: false,
      validate: { min: 0 },
      comment: 'Montant de la transaction',
    },

    status: {
      type: DataTypes.ENUM('réussi', 'échoué', 'en attente', 'annuler'),
      defaultValue: 'réussi',
      comment: 'Statut de la transaction',
    },

    description: {
      type: DataTypes.STRING(255),
      allowNull: true,
      comment: 'Description ou commentaire de la transaction',
    },

    transactionType: {
      type: DataTypes.ENUM('retrait', 'recharge', 'transfert', 'paiement'),
      defaultValue: 'paiement',
      comment: 'Type de transaction',
    },

    transactionDate: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
      comment: 'Date de la transaction',
    },

    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'users',
        key: 'id',
      },
      onUpdate: 'CASCADE',
      onDelete: 'CASCADE',
      comment: 'Référence de l’utilisateur',
    },

    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'branchTracks',
        key: 'branchTrackId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
      comment: 'Référence du suivi de branche',
    },

    commerceId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'commerces',
        key: 'commerceId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
      comment: 'Référence du commerce',
    },
  },
  {
    tableName: 'transactions',
    timestamps: true,
  }
);

export default Transaction;

import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const TransactionRetrait = sequelize.define(
  'TransactionRetrait',
  {
    transactionRetraitId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    amount: {
      type: DataTypes.FLOAT,
      allowNull: false,
      validate: {
        min: 5,   
        max: 1000,
      },
      comment: 'Montant du retrait (min: 5$, max: 1000$)',
    },

    maxRetraitParJuur: {
      type: DataTypes.INTEGER,
      allowNull: true,
      defaultValue : 3
    },

    

    targetId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: { notEmpty: true },
      comment: 'ID de la cible du retrait',
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
      comment: "Référence de l'utilisateur",
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
    tableName: 'transactionsRetrait',
    timestamps: true,
  }
);

export default TransactionRetrait;

import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const TransactionTransfert = sequelize.define(
  'TransactionTransfert',
  {
    transactionTransfertId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    amount: {
      type: DataTypes.FLOAT,
      allowNull: false,
      validate: { min: 0 },
      comment: 'Montant du transfert',
    },

    targetId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: { notEmpty: true },
      comment: 'ID de l’utilisateur cible du transfert',
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
      comment: "Référence de l'utilisateur initiateur",
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
    tableName: 'transactionsTransfert',
    timestamps: true,
  }
);

export default TransactionTransfert;

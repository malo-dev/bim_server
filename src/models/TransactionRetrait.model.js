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
      comment: "Référence de l'utilisateur",
    },

    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: 'Référence du suivi de branche',
    },

    commerceId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: 'Référence du commerce',
    },

    currency: {
      type: DataTypes.STRING(10),
      allowNull: false,
      defaultValue: 'USD',
      comment: "Devise choisie par l'utilisateur pour le retrait (USD ou CDF) — le solde reste débité en EC, ceci sert juste à indiquer à l'agent dans quelle devise remettre le cash",
    },

    convertedAmount: {
      type: DataTypes.FLOAT,
      allowNull: true,
      comment: 'Montant converti dans la devise choisie (ex: en CDF), calculé au taux en vigueur au moment du retrait',
    },
  },
  {
    tableName: 'transactionsRetrait',
    timestamps: true,
  }
);

export default TransactionRetrait;

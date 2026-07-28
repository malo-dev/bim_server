import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';
import Product from './product.model.js';
import Commerce from './commerce.model.js';

const RedevTrack = sequelize.define(
  'RedevTrack',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    productId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    customerName: {
      type: DataTypes.STRING(150),
      allowNull: false,
      validate: { notEmpty: true },
      comment: 'Nom du client qui a pris le crédit',
    },

    amountLeft: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      validate: { min: 0 },
      comment: 'Montant restant du crédit',
    },

    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },

    commerceId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    dueDate: {
      type: DataTypes.DATE,
      allowNull: false,
      comment: 'Date limite de paiement pour le crédit',
      set(value) {
        if (value) this.setDataValue('dueDate', new Date(value));
      },
    },

    status: {
      type: DataTypes.ENUM('EN_COURS', 'PAYE', 'EN_RETARD'),
      defaultValue: 'EN_COURS',
      comment: 'Statut du crédit',
    },

    alertSent: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
      comment: 'Indique si une alerte a été envoyée pour ce crédit',
    },
  },
  {
    tableName: 'redevtracks',
    timestamps: true,
  }
);

export default RedevTrack;

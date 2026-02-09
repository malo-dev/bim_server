import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';
import Product from './product.model.js';
import Commerce from './commerce.model.js';

const Redevtrack = sequelize.define(
  'Redevtrack',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },

    
    productId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: Product,
        key: 'productId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'CASCADE',
    },

    customerName: {
      type: DataTypes.STRING,
      allowNull: false,
      comment: 'Nom du client qui a pris le crédit',
    },

    amountLeft: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      comment: 'Montant restant du crédit',
    },

    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },

    commerceId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: true,
      references: {
        model: Commerce,
        key: 'commerceId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
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

    dueDate: {
      type: DataTypes.DATE,
      allowNull: false,
      comment: 'Date limite de paiement pour le crédit',
      set(value) {
        if (value) {
          this.setDataValue('dueDate', new Date(value));
        }
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

export default Redevtrack;

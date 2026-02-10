import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';
import Currency from './currency.model.js';

const ProductSold = sequelize.define(
  'ProductSold',
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
      references: {
        model: 'products',
        key: 'productId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'RESTRICT',
    },

    name: {
      type: DataTypes.STRING(200),
      allowNull: true,
    },

    priceOfSelling: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      validate: { min: 0 },
    },

    priceAfterCredit: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      validate: { min: 0 },
    },

    benefice: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      validate: { min: 0 },
    },

    qty: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: { min: 0 },
    },

    threshold: {
      type: DataTypes.INTEGER,
      allowNull: true,
      validate: { min: 0 },
    },

    availability: {
      type: DataTypes.STRING(50),
      allowNull: true,
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
    },

    currencyId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: Currency,
        key: 'currencyId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'RESTRICT',
    },
  },
  {
    tableName: 'product_solds', // snake_case pour cohérence
    timestamps: true,
  }
);

export default ProductSold;

import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';
import Currency from './currency.model.js';

const Product = sequelize.define(
  'Product',
  {
    productId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    price: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.STRING,
      allowNull: false,
    },
      TVA: {
      type: DataTypes.STRING,
      allowNull: true,
    },
      EAN: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    qty: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    threehold: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    expiredAt: {
      type: DataTypes.DATE,
      allowNull: true,
      set(value) {
        if (value) {
          this.setDataValue('expiredAt', new Date(value));
        }
      },
    },
    Availability: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    imageUrl: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    currencyId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: Currency,
        key: 'currencyId',
      }
     
    },

     commerceId: {
  type: DataTypes.INTEGER.UNSIGNED, 
  allowNull: true,
  references: {
    model: 'commerces',
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

  },
  {
    tableName: 'products',
    timestamps: true,
  }
);

export default Product;

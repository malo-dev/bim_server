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
    },
    productId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'products',
        key: 'productId',
      },
    },

    
    name: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    priceOfSelling: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    priceAfterCredit: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    benefice: {
      type: DataTypes.STRING,
      allowNull: false,
    },

    qty: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    threehold: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    AvailabilityOfProduct: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    commerceId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: true,
      references: {
        model: 'commerces',
        key: 'commerceId',
      },
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


     currencyId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: Currency,
        key: 'currencyId',
      }
     
    },
  },
  {
    tableName: 'productSolds',
    timestamps: true,
  }
);

export default ProductSold;

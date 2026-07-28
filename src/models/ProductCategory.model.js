import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const ProductCategory = sequelize.define(
  'ProductCategory',
  {
    productId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      allowNull: false,
    },

    categoryId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      allowNull: false,
    },
  },
  {
    tableName: 'product_categories', // snake_case pour cohérence
    timestamps: false,
  }
);

export default ProductCategory;

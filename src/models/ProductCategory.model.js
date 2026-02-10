import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const ProductCategory = sequelize.define(
  'ProductCategory',
  {
    productId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      allowNull: false,
      references: {
        model: 'products',
        key: 'productId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'CASCADE',
    },

    categoryId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      allowNull: false,
      references: {
        model: 'categories',
        key: 'categoryId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'CASCADE',
    },
  },
  {
    tableName: 'product_categories', // snake_case pour cohérence
    timestamps: false,
  }
);

export default ProductCategory;

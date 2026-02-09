import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Currency = sequelize.define(
  'Currency',
  {
    currencyId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    code: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notEmpty: true },
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notEmpty: true },
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    symbol: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    rate: {
      type: DataTypes.FLOAT,
      allowNull: true,
    },
  },
  {
    tableName: 'currencies',
    timestamps: true,
    indexes: [
      {
        unique: true,
        fields: ['code'], // unicité via index
      },
    ],
  }
);

export default Currency;

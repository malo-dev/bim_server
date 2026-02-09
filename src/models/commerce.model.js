import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';
import User from './User.model.js';

const Commerce = sequelize.define(
  'Commerce',
  {
    commerceId: {
      type: DataTypes.INTEGER.UNSIGNED,
      autoIncrement: true,
      primaryKey: true,
    },
    commercename: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notEmpty: true },
    },
    commerceemail: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notEmpty: true, isEmail: true },
    },
    id: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: User,
        key: 'id',
      },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
    },
    imageUrl: {
      type: DataTypes.STRING,
      allowNull: true,
    },
  },
  {
    tableName: 'commerces',
    timestamps: true,
    indexes: [
      {
        unique: true,
        fields: ['commerceemail'],
      },
    ],
  }
);

export default Commerce;

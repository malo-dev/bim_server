import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Role = sequelize.define(
  'Role',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
      validate: { notEmpty: true },
      comment: 'Nom unique du rôle',
    },
    description: {
      type: DataTypes.STRING(255),
      allowNull: true,
      comment: 'Description du rôle',
    },
  },
  {
    tableName: 'roles',
    timestamps: true,
    indexes: [
      {
        unique: true,
        fields: ['name'],
      },
    ],
  }
);

export default Role;

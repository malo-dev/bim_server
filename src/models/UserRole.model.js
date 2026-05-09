import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const UserRole = sequelize.define(
  'UserRole',
  {
    userId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
    },
    roleId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
    },
    companyId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
  },
  {
    tableName: 'UserRoles',
    timestamps: false,
  }
);

export default UserRole;

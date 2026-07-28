import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const UserSOS = sequelize.define('UserSOS', {
  sosId: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  category: {
    type: DataTypes.ENUM('securite', 'sante'),
    allowNull: false,
    defaultValue: 'securite',
  },
  type: {
    type: DataTypes.ENUM('suspect', 'urgence', 'secours', 'sante'),
    allowNull: false,
  },
  subType: {
    type: DataTypes.ENUM('ebola', 'cas_suspect', 'autre'),
    allowNull: true,
  },
  caseLocation: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  contactPhone: {
    type: DataTypes.STRING(30),
    allowNull: true,
  },
  latitude: {
    type: DataTypes.DECIMAL(10, 8),
    allowNull: true,
  },
  longitude: {
    type: DataTypes.DECIMAL(11, 8),
    allowNull: true,
  },
  status: {
    type: DataTypes.ENUM('active', 'resolved'),
    defaultValue: 'active',
  },
  resolvedAt: {
    type: DataTypes.DATE,
    allowNull: true,
  },
}, {
  tableName: 'user_sos',
  timestamps: true,
});

export default UserSOS;

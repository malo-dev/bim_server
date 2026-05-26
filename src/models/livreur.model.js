import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Livreur = sequelize.define('Livreur', {
  livreurId: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: { model: 'users', key: 'id' },
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  },
  companyId: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: { model: 'companies', key: 'companyId' },
    onDelete: 'SET NULL',
    onUpdate: 'CASCADE',
  },
  telephone: {
    type: DataTypes.STRING(30),
    allowNull: true,
  },
  idCardRecto: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  idCardVerso: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  motivation: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  status: {
    type: DataTypes.ENUM('pending', 'accepted', 'rejected', 'active'),
    defaultValue: 'pending',
  },
  livreurPassword: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  rating: {
    type: DataTypes.DECIMAL(3, 2),
    defaultValue: 0,
  },
  ratingCount: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  latitude: {
    type: DataTypes.DECIMAL(10, 8),
    allowNull: true,
  },
  longitude: {
    type: DataTypes.DECIMAL(11, 8),
    allowNull: true,
  },
  isOnline: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
}, {
  tableName: 'livreurs',
  timestamps: true,
});

export default Livreur;

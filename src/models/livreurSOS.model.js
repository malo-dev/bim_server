import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const LivreurSOS = sequelize.define('LivreurSOS', {
  sosId: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  livreurId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: { model: 'livreurs', key: 'livreurId' },
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  },
  type: {
    type: DataTypes.ENUM('suspect', 'urgence', 'secours'),
    allowNull: false,
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
  tableName: 'livreur_sos',
  timestamps: true,
});

export default LivreurSOS;

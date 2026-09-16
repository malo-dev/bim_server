import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

// Chauffeur BIM Transport (courses type VTC) — système séparé des Livreurs (colis).
const Chauffeur = sequelize.define('Chauffeur', {
  chauffeurId: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  telephone: {
    type: DataTypes.STRING(30),
    allowNull: true,
  },
  status: {
    type: DataTypes.ENUM('pending', 'accepted', 'rejected', 'active'),
    defaultValue: 'pending',
  },

  // Véhicule
  vehicleMake: { type: DataTypes.STRING(80), allowNull: true },      // "Tesla", "Toyota"...
  vehicleModel: { type: DataTypes.STRING(80), allowNull: true },     // "Model 3", "Corolla"...
  vehicleColor: { type: DataTypes.STRING(40), allowNull: true },
  plateNumber: { type: DataTypes.STRING(30), allowNull: true },
  vehicleTier: {
    type: DataTypes.ENUM('eco', 'confort', 'green', 'van', 'moto'),
    defaultValue: 'eco',
  },
  seats: { type: DataTypes.INTEGER, defaultValue: 4 },

  rating: { type: DataTypes.DECIMAL(3, 2), defaultValue: 5.0 },
  ratingCount: { type: DataTypes.INTEGER, defaultValue: 0 },
  totalRides: { type: DataTypes.INTEGER, defaultValue: 0 },

  latitude: { type: DataTypes.DECIMAL(10, 8), allowNull: true },
  longitude: { type: DataTypes.DECIMAL(11, 8), allowNull: true },
  isOnline: { type: DataTypes.BOOLEAN, defaultValue: false },
  isAvailable: { type: DataTypes.BOOLEAN, defaultValue: true }, // false pendant une course

  avatarUrl: { type: DataTypes.STRING, allowNull: true },
}, {
  tableName: 'chauffeurs',
  timestamps: true,
});

export default Chauffeur;

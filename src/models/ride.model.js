import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

// Course BIM Transport (type VTC — pickup/destination, pas une commande produit).
const Ride = sequelize.define('Ride', {
  rideId: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  rideNumber: { type: DataTypes.STRING(100), allowNull: false },

  userId: { type: DataTypes.INTEGER, allowNull: false },
  chauffeurId: { type: DataTypes.INTEGER, allowNull: true },

  pickupAddress: { type: DataTypes.STRING(255), allowNull: false },
  pickupLat: { type: DataTypes.DECIMAL(10, 8), allowNull: true },
  pickupLng: { type: DataTypes.DECIMAL(11, 8), allowNull: true },

  destinationAddress: { type: DataTypes.STRING(255), allowNull: false },
  destinationLat: { type: DataTypes.DECIMAL(10, 8), allowNull: true },
  destinationLng: { type: DataTypes.DECIMAL(11, 8), allowNull: true },

  vehicleTier: {
    type: DataTypes.ENUM('eco', 'confort', 'green', 'van', 'moto'),
    defaultValue: 'eco',
  },

  distanceKm: { type: DataTypes.DECIMAL(6, 2), allowNull: true },
  durationMin: { type: DataTypes.INTEGER, allowNull: true },

  estimatedFare: { type: DataTypes.DECIMAL(10, 2), allowNull: false },
  finalFare: { type: DataTypes.DECIMAL(10, 2), allowNull: true },
  tip: { type: DataTypes.DECIMAL(10, 2), defaultValue: 0 },

  pickupCode: { type: DataTypes.STRING(6), allowNull: true },

  status: {
    type: DataTypes.ENUM('searching', 'accepted', 'arriving', 'in_progress', 'completed', 'cancelled'),
    defaultValue: 'searching',
  },

  paymentMethod: { type: DataTypes.STRING(30), defaultValue: 'wallet' },
  paymentStatus: { type: DataTypes.ENUM('pending', 'paid'), defaultValue: 'pending' },

  rating: { type: DataTypes.INTEGER, allowNull: true },
  ratingCompliments: { type: DataTypes.JSON, allowNull: true },
  ratingComment: { type: DataTypes.TEXT, allowNull: true },

  cancelReason: { type: DataTypes.STRING(255), allowNull: true },
}, {
  tableName: 'rides',
  timestamps: true,
});

export default Ride;

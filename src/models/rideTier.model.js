import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

// Gamme de véhicule BIM Transport (Bim Eco, Bim Confort...) — tarifs éditables
// depuis admin-bim, remplace les constantes TIERS codées en dur.
const RideTier = sequelize.define('RideTier', {
  tierKey: {
    type: DataTypes.STRING(20),
    primaryKey: true,
  },
  label: { type: DataTypes.STRING(60), allowNull: false },
  base: { type: DataTypes.DECIMAL(10, 2), allowNull: false },     // prix de prise en charge (EC)
  perKm: { type: DataTypes.DECIMAL(10, 2), allowNull: false },    // prix par kilomètre (EC)
  seats: { type: DataTypes.INTEGER, defaultValue: 4 },
  etaMin: { type: DataTypes.INTEGER, defaultValue: 3 },
  active: { type: DataTypes.BOOLEAN, defaultValue: true },
  sortOrder: { type: DataTypes.INTEGER, defaultValue: 0 },
}, {
  tableName: 'ride_tiers',
  timestamps: true,
});

export default RideTier;

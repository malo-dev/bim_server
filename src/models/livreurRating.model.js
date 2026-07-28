import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const LivreurRating = sequelize.define('LivreurRating', {
  ratingId: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  livreurId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  score: {
    type: DataTypes.INTEGER,
    allowNull: false,
    validate: { min: 1, max: 5 },
  },
  comment: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
}, {
  tableName: 'livreur_ratings',
  timestamps: true,
  indexes: [
    { unique: true, fields: ['livreurId', 'userId'] },
  ],
});

export default LivreurRating;

import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const SupportTrack = sequelize.define(
  'SupportTrack',
  {
    supportTrackId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },

    sujet: {
      type: DataTypes.STRING(150),
      allowNull: true,
      comment: 'Sujet du ticket de support',
    },

    email: {
      type: DataTypes.STRING(150),
      allowNull: false,
      validate: { notEmpty: true, isEmail: true },
      comment: 'Email de l’utilisateur',
    },

    description: {
      type: DataTypes.STRING(500),
      allowNull: false,
      validate: { notEmpty: true },
      comment: 'Description du problème ou demande',
    },

    imageUrl: {
      type: DataTypes.STRING,
      allowNull: true,
      comment: 'URL d’une image associée au ticket',
    },

    commerceId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'commerces',
        key: 'commerceId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
    },

    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'branchTracks',
        key: 'branchTrackId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
    },

    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'users',
        key: 'id',
      },
      onUpdate: 'CASCADE',
      onDelete: 'CASCADE',
    },
  },
  {
    tableName: 'supportTracks',
    timestamps: true,
  }
);

export default SupportTrack;

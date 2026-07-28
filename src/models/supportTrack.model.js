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
    },

    branchTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    id: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
  },
  {
    tableName: 'supportTracks',
    timestamps: true,
  }
);

export default SupportTrack;

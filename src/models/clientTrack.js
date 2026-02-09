import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const ClientTrack = sequelize.define(
  'ClientTrack',
  {
    clientTrackId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notEmpty: true },
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notEmpty: true, isEmail: true },
    },
    description: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notEmpty: true },
    },
    imageUrl: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    commerceId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: true,
      references: {
        model: 'commerces',
        key: 'commerceId',
      },
    },
    branchTrackId: {
  type: DataTypes.INTEGER.UNSIGNED,
  allowNull: true,
  references: {
    model: 'branchTracks',
    key: 'branchTrackId',
  },
  onUpdate: 'CASCADE',
  onDelete: 'SET NULL',
},

  },
  {
    tableName: 'clientTracks',
    timestamps: true,
    indexes: [
      {
        unique: true,
        fields: ['email'], // unicité via index
      },
    ],
  }
);

export default ClientTrack;

import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const User = sequelize.define(
  'User',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    username: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notEmpty: true },
    },
    fullname: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    telephone: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    poste: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    adresse: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notEmpty: true, isEmail: true },
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    otp: {
      type: DataTypes.STRING,
      allowNull: true,        
    },
    otpExpires: {
      type: DataTypes.DATE,
      allowNull: true,     
    },
    resetPasswordToken: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    resetPasswordExpiresAt: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    tokenDateAbonnementExpiresAt: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    refreshToken: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    token: {               // harmonisé
      type: DataTypes.STRING,
      allowNull: true,
    },
    tokenAbonnement: {     // harmonisé
      type: DataTypes.STRING,
      allowNull: true,
    },
    accountNumber: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    soldNumber: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
    nRecharge: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
    },
    isActive: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
    isBlocked: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
    isAgent: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
    imageUrl: {
      type: DataTypes.STRING,
      allowNull: true,
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
    expoPushToken: {
      type: DataTypes.STRING,
      allowNull: true,
    },
  },
  {
    tableName: 'users',
    timestamps: true,
    indexes: [
      {
        unique: true,
        fields: ['email'],
      },
    ],
  }
);

export default User;

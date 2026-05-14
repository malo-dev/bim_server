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

    randomly: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    randomlyPlain: {
      type: DataTypes.STRING,
      allowNull: true,
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
    token: {             
      type: DataTypes.STRING,
      allowNull: true,
    },
    TokenAbonemment: {    
      type: DataTypes.STRING,
      allowNull: true,
    },
    accountNumber: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    soldNumber: {
  type: DataTypes.DECIMAL(10, 2), // 10 chiffres max, 2 décimales
  allowNull: true,
  validate: {
    max: 5000,
  },
},
    maxRetraitParJour: {
  type: DataTypes.INTEGER,
  allowNull: false,
  defaultValue: 3,
  validate: {
    min: 1,
  },
  comment: 'Nombre maximum de retraits autorisés par jour',
},

maxRechargeParJour: {
  type: DataTypes.INTEGER,
  allowNull: false,
  defaultValue: 10,
  validate: {
    min: 1,
  },
  comment: 'Nombre maximum de recharges autorisées par jour',
},

maxTransfertParJour: {
  type: DataTypes.INTEGER,
  allowNull: false,
  defaultValue: 5,
  validate: {
    min: 1,
  },
  comment: 'Nombre maximum de transferts autorisés par jour',
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

    // Sécurité login
    loginAttempts: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
      comment: 'Nombre de tentatives de connexion échouées consécutives',
    },
    lockUntil: {
      type: DataTypes.DATE,
      allowNull: true,
      comment: 'Compte verrouillé jusqu\'à cette date',
    },

    // Limite réinitialisation mot de passe
    passwordResetCount: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
      comment: 'Nombre de réinitialisations aujourd\'hui',
    },
    lastPasswordResetDate: {
      type: DataTypes.DATE,
      allowNull: true,
      comment: 'Date de la dernière réinitialisation de mot de passe',
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

import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const SupportTrack = sequelize.define(
  'SupportTrack',
  {
    SupportTrackId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },

    sujet: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
    },

    description: {
      type: DataTypes.STRING,
      allowNull: false,
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


    id: {
          type: DataTypes.INTEGER,
          allowNull: false,
          references: {
            model: "users",
            key: "id",
          },
          onDelete: "CASCADE",
        },
  },
  {
    tableName: 'supportTracks',
    timestamps: true,
  }
);

export default SupportTrack;

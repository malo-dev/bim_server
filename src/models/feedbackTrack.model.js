import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const FeedBackTrack = sequelize.define(
  'FeedBackTrack',
  {
    FeedBackTrackId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
     email: {
      type: DataTypes.STRING,
      allowNull: true,
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

  },
  {
    tableName: 'feedBackTracks',
    timestamps: true,
  }
);

export default FeedBackTrack;

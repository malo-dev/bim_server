import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const BranchTrack = sequelize.define(
  'BranchTrack',
  {
   branchTrackId: {
  type: DataTypes.INTEGER.UNSIGNED,
  primaryKey: true,
  autoIncrement: true,
}
,
    branchTrackname: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    branchTrackemail: {
      type: DataTypes.STRING,
      allowNull: false,
    
    },
    commerceId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: true,
      references: {
        model: 'commerces',
        key: 'commerceId',
      },
    },

    imageUrl: {
      type: DataTypes.STRING,
      allowNull: true,
    },
  },
  {
    tableName: 'branchTracks',
    timestamps: true,
        indexes: [
    {
      unique: true,
      fields: ['branchTrackemail'],
    },
  ],
  }
);

export default BranchTrack;

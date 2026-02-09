import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';
import User from './User.model.js';
import Commerce from './commerce.model.js';
import ExpeTrack from './expetrack.model.js';


const Notification = sequelize.define(
  'Notification',
  {
    notificationId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    title: {
      type: DataTypes.STRING,
      allowNull: false,
    },

    global: {
      type: DataTypes.BOOLEAN,
      allowNull: true,
      defaultValue:false
    },
    message: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    type: {
      type: DataTypes.ENUM(
  'INFO',
  'SUCCESS',
  'ERREUR',
  'EXPEDITION',
  'RECEPTION',
  'ALERTE',
  'LITIGE'
),

      defaultValue: 'INFO',
    },
    isRead: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
    expeTrackId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: ExpeTrack,
        key: 'expeTrackId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
    },
     id: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: User,
        key: 'id',
      },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
    },
    commerceId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: true,
      references: {
        model: Commerce,
        key: 'commerceId',
      },
      onUpdate: 'CASCADE',
      onDelete: 'CASCADE',
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
    tableName: 'notifications',
    timestamps: true,
  }
);




export default Notification;

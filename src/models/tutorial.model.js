import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

const Tutorial = sequelize.define("Tutorial", {
  id: {
    type:          DataTypes.INTEGER,
    primaryKey:    true,
    autoIncrement: true,
  },
  title: {
    type:      DataTypes.STRING,
    allowNull: false,
    validate:  { notEmpty: true },
  },
  description: {
    type:      DataTypes.TEXT,
    allowNull: true,
  },
  youtubeUrl: {
    type:      DataTypes.STRING(512),
    allowNull: false,
  },
  thumbnailUrl: {
    type:      DataTypes.STRING(512),
    allowNull: true,
  },
  order: {
    type:         DataTypes.INTEGER,
    allowNull:    false,
    defaultValue: 0,
  },
  isActive: {
    type:         DataTypes.BOOLEAN,
    allowNull:    false,
    defaultValue: true,
  },
}, {
  tableName:  "tutorials",
  timestamps: true,
});

export default Tutorial;

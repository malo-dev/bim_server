import Sequelize from 'sequelize';
import sequelize from '../config/database.js';
const { DataTypes } = Sequelize;
const Role = sequelize.define(
  'Role',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.STRING,
      allowNull: true,
    }
  },
  {
    tableName: 'roles',
    timestamps: true,
       indexes: [
    {
      unique: true,
      fields: ['name'],
    },
  ],
  }
);
export default Role;

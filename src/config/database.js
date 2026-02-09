import { Sequelize } from 'sequelize';
import dotenv from 'dotenv';
dotenv.config();
console.log('Database configuration loaded',  process.env.DB_PASSWORD);

const sequelize = new Sequelize(
  process.env.DB_NAME || 'bim',
  process.env.DB_USER || 'root',
  process.env.DB_PASSWORD || '',
  {
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT || 3306),
    dialect: 'mysql',
    logging: false,
  }
);

export default sequelize;

// Config sequelize-cli (CommonJS — le projet est en "type": "module", donc .cjs
// explicite pour que ça reste chargeable par la CLI). Mêmes variables d'env que
// src/config/database.js, pour ne pas dupliquer la config à la main.
require('dotenv').config();

const base = {
  username: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'bim',
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 3306),
  dialect: 'mysql',
  logging: false,
};

module.exports = {
  development: base,
  test: base,
  production: base,
};

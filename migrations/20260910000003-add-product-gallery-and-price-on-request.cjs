'use strict';

async function columnExists(queryInterface, table, column) {
  const [rows] = await queryInterface.sequelize.query(`
    SELECT COLUMN_NAME FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = '${table}' AND COLUMN_NAME = '${column}';
  `);
  return rows.length > 0;
}

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface) {
    if (!(await columnExists(queryInterface, 'products', 'images'))) {
      await queryInterface.sequelize.query(`ALTER TABLE products ADD COLUMN images JSON NULL;`);
    }
    if (!(await columnExists(queryInterface, 'products', 'priceOnRequest'))) {
      await queryInterface.sequelize.query(`ALTER TABLE products ADD COLUMN priceOnRequest TINYINT(1) NOT NULL DEFAULT 0;`);
    }
  },
  async down(queryInterface) {
    if (await columnExists(queryInterface, 'products', 'images')) {
      await queryInterface.sequelize.query(`ALTER TABLE products DROP COLUMN images;`);
    }
    if (await columnExists(queryInterface, 'products', 'priceOnRequest')) {
      await queryInterface.sequelize.query(`ALTER TABLE products DROP COLUMN priceOnRequest;`);
    }
  },
};

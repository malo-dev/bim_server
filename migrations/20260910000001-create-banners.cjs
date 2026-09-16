'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface) {
    // IF NOT EXISTS : sûr même si la table a déjà été créée par sequelize.sync()
    await queryInterface.sequelize.query(`
      CREATE TABLE IF NOT EXISTS banners (
        bannerId INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(150) NOT NULL,
        tagline VARCHAR(200) NULL,
        imageUrl VARCHAR(255) NULL,
        linkUrl VARCHAR(255) NULL,
        position INT NOT NULL DEFAULT 0,
        isActive TINYINT(1) NOT NULL DEFAULT 1,
        createdAt DATETIME NOT NULL,
        updatedAt DATETIME NOT NULL
      );
    `);
  },
  async down(queryInterface) {
    await queryInterface.dropTable('banners');
  },
};

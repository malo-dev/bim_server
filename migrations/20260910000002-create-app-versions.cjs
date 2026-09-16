'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface) {
    await queryInterface.sequelize.query(`
      CREATE TABLE IF NOT EXISTS app_versions (
        id INT AUTO_INCREMENT PRIMARY KEY,
        platform ENUM('android', 'ios') NOT NULL,
        latestVersion VARCHAR(20) NOT NULL,
        minSupportedVersion VARCHAR(20) NULL,
        storeUrl VARCHAR(255) NULL,
        releaseNotes TEXT NULL,
        forceUpdate TINYINT(1) NOT NULL DEFAULT 0,
        promptEnabled TINYINT(1) NOT NULL DEFAULT 1,
        createdAt DATETIME NOT NULL,
        updatedAt DATETIME NOT NULL,
        UNIQUE KEY app_versions_platform_unique (platform)
      );
    `);

    // Au cas où la table existait déjà (créée par sync()) sans la colonne promptEnabled.
    const [cols] = await queryInterface.sequelize.query(`
      SELECT COLUMN_NAME FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'app_versions' AND COLUMN_NAME = 'promptEnabled';
    `);
    if (cols.length === 0) {
      await queryInterface.sequelize.query(`
        ALTER TABLE app_versions ADD COLUMN promptEnabled TINYINT(1) NOT NULL DEFAULT 1;
      `);
    }
  },
  async down(queryInterface) {
    await queryInterface.dropTable('app_versions');
  },
};

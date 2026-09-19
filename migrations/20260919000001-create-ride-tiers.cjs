'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface) {
    await queryInterface.sequelize.query(`
      CREATE TABLE IF NOT EXISTS ride_tiers (
        tierKey VARCHAR(20) PRIMARY KEY,
        label VARCHAR(60) NOT NULL,
        base DECIMAL(10,2) NOT NULL,
        perKm DECIMAL(10,2) NOT NULL,
        seats INT NOT NULL DEFAULT 4,
        etaMin INT NOT NULL DEFAULT 3,
        active TINYINT(1) NOT NULL DEFAULT 1,
        sortOrder INT NOT NULL DEFAULT 0,
        createdAt DATETIME NOT NULL,
        updatedAt DATETIME NOT NULL
      );
    `);

    // Seed avec les tarifs qui étaient codés en dur dans ride.controller.js,
    // pour que rien ne change au moment du déploiement de cette migration.
    await queryInterface.sequelize.query(`
      INSERT IGNORE INTO ride_tiers (tierKey, label, base, perKm, seats, etaMin, active, sortOrder, createdAt, updatedAt) VALUES
        ('eco',     'Bim Eco',      3.00, 1.75, 4, 3, 1, 1, NOW(), NOW()),
        ('confort', 'Bim Confort',  5.00, 2.60, 4, 5, 1, 2, NOW(), NOW()),
        ('green',   'Bim Green',    3.50, 2.00, 4, 4, 1, 3, NOW(), NOW()),
        ('van',     'Bim Van',      8.00, 3.30, 6, 8, 1, 4, NOW(), NOW()),
        ('moto',    'Moto Express', 2.00, 1.20, 1, 3, 1, 5, NOW(), NOW());
    `);
  },
  async down(queryInterface) {
    await queryInterface.dropTable('ride_tiers');
  },
};

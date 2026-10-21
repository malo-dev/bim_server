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

    // Grille tarifaire : 1 km = 1 EC pour toutes les gammes, aucun frais de
    // prise en charge fixe (cf. migration 20261021000001 pour les bases déjà
    // déployées avant cette simplification).
    await queryInterface.sequelize.query(`
      INSERT IGNORE INTO ride_tiers (tierKey, label, base, perKm, seats, etaMin, active, sortOrder, createdAt, updatedAt) VALUES
        ('eco',     'Bim Eco',      0, 1.00, 4, 3, 1, 1, NOW(), NOW()),
        ('confort', 'Bim Confort',  0, 1.00, 4, 5, 1, 2, NOW(), NOW()),
        ('green',   'Bim Green',    0, 1.00, 4, 4, 1, 3, NOW(), NOW()),
        ('van',     'Bim Van',      0, 1.00, 6, 8, 1, 4, NOW(), NOW()),
        ('moto',    'Moto Express', 0, 1.00, 1, 3, 1, 5, NOW(), NOW());
    `);
  },
  async down(queryInterface) {
    await queryInterface.dropTable('ride_tiers');
  },
};

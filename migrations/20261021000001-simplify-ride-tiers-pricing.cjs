'use strict';

/** @type {import('sequelize-cli').Migration} */
// Nouvelle grille tarifaire BIM Transport : 1 km = 1 EC pour toutes les
// gammes, plus aucun frais de prise en charge fixe (base = 0).
module.exports = {
  async up(queryInterface) {
    await queryInterface.sequelize.query(`
      UPDATE ride_tiers SET base = 0, perKm = 1.00;
    `);
  },
  async down(queryInterface) {
    await queryInterface.sequelize.query(`
      UPDATE ride_tiers SET base = 3.00, perKm = 1.75 WHERE tierKey = 'eco';
      UPDATE ride_tiers SET base = 5.00, perKm = 2.60 WHERE tierKey = 'confort';
      UPDATE ride_tiers SET base = 3.50, perKm = 2.00 WHERE tierKey = 'green';
      UPDATE ride_tiers SET base = 8.00, perKm = 3.30 WHERE tierKey = 'van';
      UPDATE ride_tiers SET base = 2.00, perKm = 1.20 WHERE tierKey = 'moto';
    `);
  },
};

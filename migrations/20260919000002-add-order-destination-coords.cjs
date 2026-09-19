'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const table = await queryInterface.describeTable('orders');
    if (!table.destinationLat) {
      await queryInterface.addColumn('orders', 'destinationLat', { type: Sequelize.DECIMAL(10, 8), allowNull: true });
    }
    if (!table.destinationLng) {
      await queryInterface.addColumn('orders', 'destinationLng', { type: Sequelize.DECIMAL(11, 8), allowNull: true });
    }
  },
  async down(queryInterface) {
    await queryInterface.removeColumn('orders', 'destinationLat');
    await queryInterface.removeColumn('orders', 'destinationLng');
  },
};

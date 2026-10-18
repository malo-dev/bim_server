'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const table = await queryInterface.describeTable('ride_tiers');
    if (!table.imageUrl) {
      await queryInterface.addColumn('ride_tiers', 'imageUrl', {
        type: Sequelize.STRING,
        allowNull: true,
      });
    }
  },
  async down(queryInterface) {
    await queryInterface.removeColumn('ride_tiers', 'imageUrl');
  },
};

'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const table = await queryInterface.describeTable('users');
    if (!table.notificationEmail) {
      await queryInterface.addColumn('users', 'notificationEmail', {
        type: Sequelize.STRING,
        allowNull: true,
      });
    }
  },
  async down(queryInterface) {
    await queryInterface.removeColumn('users', 'notificationEmail');
  },
};

'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const table = await queryInterface.describeTable('users');
    if (!table.isQuickAccount) {
      await queryInterface.addColumn('users', 'isQuickAccount', {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: false,
      });
    }
    try {
      await queryInterface.addIndex('users', ['telephone']);
    } catch (e) {
      // Index déjà présent — idempotent.
    }
  },
  async down(queryInterface) {
    await queryInterface.removeColumn('users', 'isQuickAccount');
    try {
      await queryInterface.removeIndex('users', ['telephone']);
    } catch (e) {
      // ignore
    }
  },
};

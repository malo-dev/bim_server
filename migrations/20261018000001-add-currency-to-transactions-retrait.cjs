'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const table = await queryInterface.describeTable('transactionsRetrait');
    if (!table.currency) {
      await queryInterface.addColumn('transactionsRetrait', 'currency', {
        type: Sequelize.STRING(10),
        allowNull: false,
        defaultValue: 'USD',
      });
    }
    if (!table.convertedAmount) {
      await queryInterface.addColumn('transactionsRetrait', 'convertedAmount', {
        type: Sequelize.FLOAT,
        allowNull: true,
      });
    }
  },
  async down(queryInterface) {
    await queryInterface.removeColumn('transactionsRetrait', 'currency');
    await queryInterface.removeColumn('transactionsRetrait', 'convertedAmount');
  },
};

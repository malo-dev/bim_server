'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const table = await queryInterface.describeTable('transactionsRecharge');
    if (!table.currency) {
      await queryInterface.addColumn('transactionsRecharge', 'currency', {
        type: Sequelize.STRING(10),
        allowNull: false,
        defaultValue: 'USD',
      });
    }
    if (!table.convertedAmount) {
      await queryInterface.addColumn('transactionsRecharge', 'convertedAmount', {
        type: Sequelize.FLOAT,
        allowNull: true,
      });
    }
  },
  async down(queryInterface) {
    await queryInterface.removeColumn('transactionsRecharge', 'currency');
    await queryInterface.removeColumn('transactionsRecharge', 'convertedAmount');
  },
};

'use strict';

// Recharge approuvée par l'admin : montant réellement crédité et frais
// d'abonnement prélevés (première recharge). Permet à une désapprobation de
// retirer exactement ce qui a été crédité et d'annuler l'abonnement activé.

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const table = await queryInterface.describeTable('transactionsRecharge');
    if (!table.creditedAmount) {
      await queryInterface.addColumn('transactionsRecharge', 'creditedAmount', { type: Sequelize.DECIMAL(15, 2), allowNull: true });
    }
    if (!table.subscriptionFee) {
      await queryInterface.addColumn('transactionsRecharge', 'subscriptionFee', { type: Sequelize.DECIMAL(15, 2), allowNull: true });
    }
  },
  async down(queryInterface) {
    await queryInterface.removeColumn('transactionsRecharge', 'subscriptionFee');
    await queryInterface.removeColumn('transactionsRecharge', 'creditedAmount');
  },
};

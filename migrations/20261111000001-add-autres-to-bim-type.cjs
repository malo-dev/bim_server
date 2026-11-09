'use strict';

// Catalogue BIM NEXT : catégorie « autres » (produits hors eau / gaz /
// carburant), affichés dans la section « Autres produits » de l'app.

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.changeColumn('products', 'bimType', {
      type: Sequelize.ENUM('eau', 'gaz', 'carburant', 'autres'),
      allowNull: true,
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.sequelize.query("UPDATE products SET bimType = NULL WHERE bimType = 'autres'");
    await queryInterface.changeColumn('products', 'bimType', {
      type: Sequelize.ENUM('eau', 'gaz', 'carburant'),
      allowNull: true,
    });
  },
};

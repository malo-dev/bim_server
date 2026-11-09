'use strict';

// Catalogue BIM NEXT : catégorie explicite d'un produit (eau / gaz / carburant)
// et sous-catégorie affichée en puce dans l'app (« Bonbonne 20 L », « Bouteille
// 12 kg », « Essence »…). Les produits existants gardent bimType = NULL et
// restent classés comme avant (secteur de l'entreprise, catégories, nom).

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const table = await queryInterface.describeTable('products');
    if (!table.bimType) {
      await queryInterface.addColumn('products', 'bimType', {
        type: Sequelize.ENUM('eau', 'gaz', 'carburant'),
        allowNull: true,
      });
    }
    if (!table.bimSub) {
      await queryInterface.addColumn('products', 'bimSub', {
        type: Sequelize.STRING(100),
        allowNull: true,
      });
    }
  },
  async down(queryInterface) {
    await queryInterface.removeColumn('products', 'bimSub');
    await queryInterface.removeColumn('products', 'bimType');
  },
};

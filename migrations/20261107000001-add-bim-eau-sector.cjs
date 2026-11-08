'use strict';

// Secteur « BIM Eau » : l'app n'affiche désormais que EAU, GAZ et CARBURANT.
// BIM Gaz et BIM Carburant existent déjà ; on ajoute BIM Eau s'il manque,
// pour que les entreprises d'eau puissent y être rattachées depuis l'admin.
module.exports = {
  async up(queryInterface) {
    const [rows] = await queryInterface.sequelize.query(
      "SELECT businessId FROM businessCategories WHERE name = 'BIM Eau' LIMIT 1"
    );
    if (rows.length) return;
    const now = new Date();
    await queryInterface.bulkInsert('businessCategories', [{
      name: 'BIM Eau',
      description: "Livraison d'eau : bonbonnes, packs et sachets.",
      logo: null,
      imageUrl: null,
      createdAt: now,
      updatedAt: now,
    }]);
  },

  async down(queryInterface) {
    await queryInterface.bulkDelete('businessCategories', { name: 'BIM Eau' });
  },
};

'use strict';

// `passwordSetByUser` : vrai quand l'utilisateur a lui-même choisi son mot de
// passe (inscription BIM NEXT, réinitialisation, « sécuriser mon compte »).
// Les anciens comptes « rapides » ont un mot de passe aléatoire qu'ils n'ont
// jamais vu : à la connexion par numéro, on leur demande d'en créer un.
//
// Reprise des données : les comptes rapides dont le nom est encore
// l'identifiant automatique `quick_xxxxxx` viennent de l'ancien parcours
// (numéro seul) → false. Les comptes rapides créés avec un nom complet (nouveau
// parcours, mot de passe à 6 chiffres) et tous les comptes classiques → true.

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const table = await queryInterface.describeTable('users');
    if (!table.passwordSetByUser) {
      await queryInterface.addColumn('users', 'passwordSetByUser', {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: true,
      });
      await queryInterface.sequelize.query(
        "UPDATE users SET passwordSetByUser = false WHERE isQuickAccount = true AND username LIKE 'quick\\_%'"
      );
    }
  },
  async down(queryInterface) {
    await queryInterface.removeColumn('users', 'passwordSetByUser');
  },
};

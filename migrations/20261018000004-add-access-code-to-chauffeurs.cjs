'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const table = await queryInterface.describeTable('chauffeurs');
    if (!table.accessCode) {
      await queryInterface.addColumn('chauffeurs', 'accessCode', {
        type: Sequelize.STRING(10),
        allowNull: true,
      });
      await queryInterface.addIndex('chauffeurs', ['accessCode'], { unique: true, name: 'chauffeurs_access_code_unique' });
    }
    if (!table.fullname) {
      await queryInterface.addColumn('chauffeurs', 'fullname', {
        type: Sequelize.STRING,
        allowNull: true,
      });
    }
  },
  async down(queryInterface) {
    await queryInterface.removeColumn('chauffeurs', 'accessCode');
    await queryInterface.removeColumn('chauffeurs', 'fullname');
  },
};

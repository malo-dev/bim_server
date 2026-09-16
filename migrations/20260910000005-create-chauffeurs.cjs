'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface) {
    await queryInterface.sequelize.query(`
      CREATE TABLE IF NOT EXISTS chauffeurs (
        chauffeurId INT AUTO_INCREMENT PRIMARY KEY,
        userId INT NOT NULL,
        telephone VARCHAR(30) NULL,
        status ENUM('pending', 'accepted', 'rejected', 'active') NOT NULL DEFAULT 'pending',
        vehicleMake VARCHAR(80) NULL,
        vehicleModel VARCHAR(80) NULL,
        vehicleColor VARCHAR(40) NULL,
        plateNumber VARCHAR(30) NULL,
        vehicleTier ENUM('eco', 'confort', 'green', 'van', 'moto') NOT NULL DEFAULT 'eco',
        seats INT NOT NULL DEFAULT 4,
        rating DECIMAL(3,2) NOT NULL DEFAULT 5.0,
        ratingCount INT NOT NULL DEFAULT 0,
        totalRides INT NOT NULL DEFAULT 0,
        latitude DECIMAL(10,8) NULL,
        longitude DECIMAL(11,8) NULL,
        isOnline TINYINT(1) NOT NULL DEFAULT 0,
        isAvailable TINYINT(1) NOT NULL DEFAULT 1,
        avatarUrl VARCHAR(255) NULL,
        createdAt DATETIME NOT NULL,
        updatedAt DATETIME NOT NULL,
        CONSTRAINT chauffeurs_userId_fk FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
      );
    `);
  },
  async down(queryInterface) {
    await queryInterface.dropTable('chauffeurs');
  },
};

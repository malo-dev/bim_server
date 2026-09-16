'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface) {
    await queryInterface.sequelize.query(`
      CREATE TABLE IF NOT EXISTS rides (
        rideId INT AUTO_INCREMENT PRIMARY KEY,
        rideNumber VARCHAR(100) NOT NULL,
        userId INT NOT NULL,
        chauffeurId INT NULL,
        pickupAddress VARCHAR(255) NOT NULL,
        pickupLat DECIMAL(10,8) NULL,
        pickupLng DECIMAL(11,8) NULL,
        destinationAddress VARCHAR(255) NOT NULL,
        destinationLat DECIMAL(10,8) NULL,
        destinationLng DECIMAL(11,8) NULL,
        vehicleTier ENUM('eco', 'confort', 'green', 'van', 'moto') NOT NULL DEFAULT 'eco',
        distanceKm DECIMAL(6,2) NULL,
        durationMin INT NULL,
        estimatedFare DECIMAL(10,2) NOT NULL,
        finalFare DECIMAL(10,2) NULL,
        tip DECIMAL(10,2) NOT NULL DEFAULT 0,
        pickupCode VARCHAR(6) NULL,
        status ENUM('searching', 'accepted', 'arriving', 'in_progress', 'completed', 'cancelled') NOT NULL DEFAULT 'searching',
        paymentMethod VARCHAR(30) NOT NULL DEFAULT 'wallet',
        paymentStatus ENUM('pending', 'paid') NOT NULL DEFAULT 'pending',
        rating INT NULL,
        ratingCompliments JSON NULL,
        ratingComment TEXT NULL,
        cancelReason VARCHAR(255) NULL,
        createdAt DATETIME NOT NULL,
        updatedAt DATETIME NOT NULL,
        CONSTRAINT rides_userId_fk FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT rides_chauffeurId_fk FOREIGN KEY (chauffeurId) REFERENCES chauffeurs(chauffeurId) ON DELETE SET NULL ON UPDATE CASCADE
      );
    `);
  },
  async down(queryInterface) {
    await queryInterface.dropTable('rides');
  },
};

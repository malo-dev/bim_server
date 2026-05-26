import { createServer } from 'http';
import app from '../app.js';
import './models/index.js';
import sequelize from './config/database.js';
import { initSocket } from './services/socket.service.js';

// eslint-disable-next-line no-undef
const PORT = process.env.PORT || 8083;

const httpServer = createServer(app);

// Initialiser Socket.io sur le serveur HTTP
initSocket(httpServer);

sequelize.sync()
  .then(async () => {
    console.log('✅ Base de données connectée');

    // Patch colonnes FK nullable (ne change rien si déjà NULL-able)
    try {
      await sequelize.query('ALTER TABLE orders MODIFY COLUMN companyId INT NULL');
      console.log('✅ orders.companyId → nullable');
    } catch { /* déjà fait */ }
    try {
      await sequelize.query('ALTER TABLE orders MODIFY COLUMN shippingAddress TEXT NULL');
      console.log('✅ orders.shippingAddress → nullable');
    } catch { /* déjà fait */ }
    try {
      await sequelize.query('ALTER TABLE orders ADD COLUMN quantity INT NOT NULL DEFAULT 1');
      console.log('✅ orders.quantity ajouté');
    } catch { /* colonne déjà présente */ }
    try {
      await sequelize.query('ALTER TABLE orders ADD COLUMN unitPrice DECIMAL(10,2) NOT NULL DEFAULT 0');
      console.log('✅ orders.unitPrice ajouté');
    } catch { /* colonne déjà présente */ }
    try {
      await sequelize.query('ALTER TABLE orders DROP INDEX orderNumber');
      console.log('✅ orders.orderNumber unique index supprimé');
    } catch { /* déjà supprimé */ }

    try {
      await sequelize.query("ALTER TABLE orders ADD COLUMN clientPhone VARCHAR(30) NULL");
      console.log('✅ orders.clientPhone ajouté');
    } catch { /* déjà existant */ }

    try {
      await sequelize.query("ALTER TABLE orders ADD COLUMN paymentStatus ENUM('pending','paid','refunded') NOT NULL DEFAULT 'pending'");
      console.log('✅ orders.paymentStatus ajouté');
    } catch { /* déjà existant */ }

    try {
      await sequelize.query("ALTER TABLE orders ADD COLUMN livreurId INT NULL");
      console.log('✅ orders.livreurId ajouté');
    } catch { /* déjà existant */ }

    // Tables livreurs (créées automatiquement par sequelize.sync, patches de sécurité)
    try {
      await sequelize.query("ALTER TABLE livreurs MODIFY COLUMN companyId INT NULL");
      console.log('✅ livreurs.companyId → nullable');
    } catch { /* ok */ }
    try {
      await sequelize.query("ALTER TABLE livreur_ratings ADD UNIQUE INDEX livreur_user_unique (livreurId, userId)");
      console.log('✅ livreur_ratings unique index ajouté');
    } catch { /* déjà existant */ }
    try {
      await sequelize.query("ALTER TABLE orders ADD COLUMN estimatedMinutes INT NULL");
      console.log('✅ orders.estimatedMinutes ajouté');
    } catch { /* déjà existant */ }
    try {
      await sequelize.query("ALTER TABLE companies ADD COLUMN commissionRate DECIMAL(5,2) NOT NULL DEFAULT 10.00");
      console.log('✅ companies.commissionRate ajouté');
    } catch { /* déjà existant */ }
    try {
      await sequelize.query(`
        CREATE TABLE IF NOT EXISTS user_sos (
          sosId INT AUTO_INCREMENT PRIMARY KEY,
          userId INT NOT NULL,
          category ENUM('securite','sante') NOT NULL DEFAULT 'securite',
          type ENUM('suspect','urgence','secours','sante') NOT NULL,
          subType ENUM('ebola','cas_suspect','autre') NULL,
          caseLocation TEXT NULL,
          contactPhone VARCHAR(30) NULL,
          latitude DECIMAL(10,8) NULL,
          longitude DECIMAL(11,8) NULL,
          status ENUM('active','resolved') NOT NULL DEFAULT 'active',
          resolvedAt DATETIME NULL,
          createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
        )
      `);
      console.log('✅ user_sos créée');
    } catch { /* déjà existant */ }
    // Patch colonnes SOS santé (si table déjà créée sans ces colonnes)
    try {
      await sequelize.query("ALTER TABLE user_sos ADD COLUMN category ENUM('securite','sante') NOT NULL DEFAULT 'securite'");
      console.log('✅ user_sos.category ajouté');
    } catch { /* déjà existant */ }
    try {
      await sequelize.query("ALTER TABLE user_sos MODIFY COLUMN type ENUM('suspect','urgence','secours','sante') NOT NULL");
      console.log('✅ user_sos.type étendu');
    } catch { /* ok */ }
    try {
      await sequelize.query("ALTER TABLE user_sos ADD COLUMN subType ENUM('ebola','cas_suspect','autre') NULL");
      console.log('✅ user_sos.subType ajouté');
    } catch { /* déjà existant */ }
    try {
      await sequelize.query("ALTER TABLE user_sos ADD COLUMN caseLocation TEXT NULL");
      console.log('✅ user_sos.caseLocation ajouté');
    } catch { /* déjà existant */ }
    try {
      await sequelize.query("ALTER TABLE user_sos ADD COLUMN contactPhone VARCHAR(30) NULL");
      console.log('✅ user_sos.contactPhone ajouté');
    } catch { /* déjà existant */ }
    try {
      await sequelize.query(`
        CREATE TABLE IF NOT EXISTS livreur_sos (
          sosId INT AUTO_INCREMENT PRIMARY KEY,
          livreurId INT NOT NULL,
          type ENUM('suspect','urgence','secours') NOT NULL,
          latitude DECIMAL(10,8) NULL,
          longitude DECIMAL(11,8) NULL,
          status ENUM('active','resolved') NOT NULL DEFAULT 'active',
          resolvedAt DATETIME NULL,
          createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          FOREIGN KEY (livreurId) REFERENCES livreurs(livreurId) ON DELETE CASCADE
        )
      `);
      console.log('✅ livreur_sos créée');
    } catch { /* déjà existant */ }

    httpServer.listen(PORT, () => {
      console.log(`🚀 Serveur lancé sur http://localhost:${PORT}`);
      console.log(`🔌 Socket.io actif sur ws://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error('❌ Erreur DB :', err);
  });

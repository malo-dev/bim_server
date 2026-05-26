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

    httpServer.listen(PORT, () => {
      console.log(`🚀 Serveur lancé sur http://localhost:${PORT}`);
      console.log(`🔌 Socket.io actif sur ws://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error('❌ Erreur DB :', err);
  });

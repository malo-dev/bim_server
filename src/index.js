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
    } catch { /* déjà nullable ou table absente */ }

    httpServer.listen(PORT, () => {
      console.log(`🚀 Serveur lancé sur http://localhost:${PORT}`);
      console.log(`🔌 Socket.io actif sur ws://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error('❌ Erreur DB :', err);
  });

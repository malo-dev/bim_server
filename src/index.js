import app from '../app.js';
import './models/index.js';
import sequelize from './config/database.js';
// eslint-disable-next-line no-undef
const PORT = process.env.PORT || 8083;
// sync({ force: false, alter: true })
sequelize.authenticate()
  .then(() => {
    console.log('✅ Base de données connectée');
    app.listen(PORT, () => {
      console.log(`🚀 Serveur lancé sur http://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error('❌ Erreur DB :', err);
  });

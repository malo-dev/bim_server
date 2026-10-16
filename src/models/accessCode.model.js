import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

// Code partagé qui révèle les entrées "staff" (Espace Livreur, Espace
// Chauffeur, Espace Gestion) dans Réglages côté app mobile — remplace les
// codes codés en dur dans bim/constants/accessCodes.ts (jamais changeables,
// visibles par quiconque inspecte le bundle de l'app). Édité depuis
// admin-bim. Ce n'est qu'un filtre d'affichage, pas une sécurité réelle :
// celle-ci reste appliquée côté serveur (rôle BIM requis pour les actions
// d'administration).
const AccessCode = sequelize.define('AccessCode', {
  role: {
    type: DataTypes.ENUM('BIM', 'LIVREUR', 'CHAUFFEUR'),
    primaryKey: true,
  },
  code: { type: DataTypes.STRING(20), allowNull: false },
}, {
  tableName: 'access_codes',
  timestamps: true,
});

export default AccessCode;

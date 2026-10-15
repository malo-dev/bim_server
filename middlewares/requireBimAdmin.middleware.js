import { Role } from '../src/models/index.js';
import sequelize from '../src/config/database.js';

// À utiliser APRÈS authMiddleware (dépend de req.user). Restreint une route
// aux comptes ayant le rôle 'BIM' — les endpoints de gestion globale des
// commandes/utilisateurs n'avaient jusqu'ici aucune vérification de rôle,
// seulement un jeton valide (y compris pour les comptes "rapides" créés
// sans aucune vérification).
const requireBimAdmin = async (req, res, next) => {
  try {
    const userRoleRecord = await sequelize.models.UserRole.findOne({ where: { userId: req.user.id } });
    const roleName = userRoleRecord ? (await Role.findByPk(userRoleRecord.roleId))?.name : null;

    if (roleName !== 'BIM') {
      return res.status(403).json({ message: 'Accès réservé aux administrateurs BIM.' });
    }
    next();
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

export default requireBimAdmin;

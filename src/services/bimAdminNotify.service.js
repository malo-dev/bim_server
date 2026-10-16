import { UserRole, Role, User } from '../models/index.js';
import { sendPushNotification } from './pushNotification.service.js';

// Notifie en push tous les comptes ayant le rôle BIM (agents de l'espace
// Gestion) — utilisé pour les événements que le staff doit suivre en temps
// réel sur son téléphone : nouvelle commande, recharge, nouveau compte,
// retrait. Ne bloque jamais l'action métier qui l'appelle (erreurs avalées).
export async function notifyBimAdmins(title, body) {
  try {
    const bimRole = await Role.findOne({ where: { name: 'BIM' } });
    if (!bimRole) return;

    const userRoles = await UserRole.findAll({ where: { roleId: bimRole.id } });
    const userIds = userRoles.map((ur) => ur.userId);
    if (!userIds.length) return;

    const admins = await User.findAll({
      where: { id: userIds },
      attributes: ['id', 'expoPushToken'],
    });

    await Promise.all(
      admins
        .filter((a) => a.expoPushToken)
        .map((a) => sendPushNotification(a.expoPushToken, title, body).catch(() => {}))
    );
  } catch (error) {
    console.error('[notifyBimAdmins]', error.message);
  }
}

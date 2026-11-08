import { Role, User, UserRole } from '../models/index.js';

// Vrai si ce compte a le rôle BIM (administrateurs : Espace Gestion + admin-bim).
export async function isBimAdminUserId(userId) {
  if (!userId) return false;
  const bimRole = await Role.findOne({ where: { name: 'BIM' } });
  if (!bimRole) return false;
  const link = await UserRole.findOne({ where: { userId, roleId: bimRole.id } });
  return !!link;
}

export async function isBimAdminEmail(email) {
  if (!email) return false;
  const user = await User.findOne({ where: { email: String(email).trim().toLowerCase() }, attributes: ['id'] });
  return user ? isBimAdminUserId(user.id) : false;
}

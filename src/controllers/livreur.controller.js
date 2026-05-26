import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { Livreur, LivreurRating, User, Company, Order, Product } from '../models/index.js';
import sequelize from '../config/database.js';
import { sendEmail } from '../utils/sendEmail.utils.js';
import { emitToUser, getIO, emitOrderUpdate } from '../services/socket.service.js';
import { Op } from 'sequelize';

function generatePassword(length = 8) {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789@#';
  return Array.from({ length }, () => chars[Math.floor(Math.random() * chars.length)]).join('');
}

// Vérifie l'abonnement : JWT valide OU date d'expiration future
function hasActiveSubscription(user) {
  // Condition 1 : date d'expiration explicite
  if (user.tokenDateAbonnementExpiresAt) {
    if (new Date(user.tokenDateAbonnementExpiresAt) > new Date()) return true;
  }
  // Condition 2 : JWT d'abonnement valide
  if (user.TokenAbonemment) {
    try {
      // eslint-disable-next-line no-undef
      jwt.verify(user.TokenAbonemment, process.env.JWT_SECRET);
      return true;
    } catch { /* expiré */ }
  }
  return false;
}

// POST /livreur/apply — Soumettre une candidature
export const applyAsLivreur = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { companyId, telephone, motivation } = req.body;

    const user = await User.findByPk(userId);
    if (!user) return res.status(404).json({ message: 'Utilisateur introuvable' });

    // DEBUG — à retirer après vérification
    console.log('[Livreur Apply] userId:', userId,
      '| TokenAbonemment:', user.TokenAbonemment ? 'PRESENT' : 'NULL',
      '| tokenDateAbonnementExpiresAt:', user.tokenDateAbonnementExpiresAt,
      '| soldNumber:', user.soldNumber
    );

    if (!hasActiveSubscription(user)) {
      return res.status(403).json({
        message: 'Un abonnement BIM NEXT annuel actif est requis pour postuler comme livreur.',
        debug: {
          hasToken: !!user.TokenAbonemment,
          expiresAt: user.tokenDateAbonnementExpiresAt,
          soldNumber: user.soldNumber,
        },
      });
    }

    const existing = await Livreur.findOne({ where: { userId, companyId: companyId || null } });
    if (existing) {
      return res.status(409).json({ message: 'Candidature déjà soumise pour cette entreprise' });
    }

    const idCardRecto = req.files?.idCardRecto?.[0]?.filename
      ? `/images/${req.files.idCardRecto[0].filename}` : null;
    const idCardVerso = req.files?.idCardVerso?.[0]?.filename
      ? `/images/${req.files.idCardVerso[0].filename}` : null;

    const livreur = await Livreur.create({
      userId,
      companyId: companyId || null,
      telephone,
      idCardRecto,
      idCardVerso,
      motivation,
      status: 'pending',
    });

    await sendEmail({
      to: user.email,
      subject: 'BIM NEXT — Candidature livreur reçue',
      html: `
        <h2 style="color:#0353CC">Candidature reçue ✅</h2>
        <p>Bonjour <strong>${user.username}</strong>,</p>
        <p>Votre candidature comme livreur BIM NEXT a bien été reçue.</p>
        <p>Vous serez notifié par email et dans l'application dès qu'elle sera examinée.</p>
        <br/><p style="color:#888">— L'équipe BIM NEXT</p>
      `,
    });

    return res.status(201).json({ message: 'Candidature soumise avec succès', livreur });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// POST /livreur/login — Connexion espace livreur
export const loginLivreur = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password)
      return res.status(400).json({ message: 'Email et mot de passe requis' });

    const user = await User.findOne({ where: { email } });
    if (!user) return res.status(401).json({ message: 'Identifiants incorrects' });

    const livreur = await Livreur.findOne({
      where: { userId: user.id, status: 'active' },
      include: [{ model: Company, as: 'company', attributes: ['companyId', 'name', 'logo'] }],
    });

    if (!livreur || !livreur.livreurPassword)
      return res.status(401).json({ message: 'Aucun compte livreur actif associé à cet email' });

    const match = await bcrypt.compare(password, livreur.livreurPassword);
    if (!match) return res.status(401).json({ message: 'Mot de passe livreur incorrect' });

    // eslint-disable-next-line no-undef
    const token = jwt.sign(
      { userId: user.id, email: user.email, livreurId: livreur.livreurId, isLivreur: true },
      // eslint-disable-next-line no-undef
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    return res.json({
      token,
      user: { id: user.id, username: user.username, email: user.email, imageUrl: user.imageUrl },
      livreur: {
        livreurId: livreur.livreurId,
        status: livreur.status,
        rating: livreur.rating,
        ratingCount: livreur.ratingCount,
        isOnline: livreur.isOnline,
        company: livreur.company,
      },
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// GET /livreur/me — Profil livreur du user connecté
export const getMyLivreurProfile = async (req, res) => {
  try {
    const userId = req.user?.id;
    const livreur = await Livreur.findOne({
      where: { userId },
      include: [{ model: Company, as: 'company', attributes: ['companyId', 'name', 'logo'] }],
    });
    if (!livreur) return res.status(404).json({ message: 'Profil livreur introuvable' });
    return res.json(livreur);
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// PUT /livreur/location — Mise à jour position GPS
export const updateLivreurLocation = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { latitude, longitude } = req.body;

    const livreur = await Livreur.findOne({ where: { userId, status: 'active' } });
    if (!livreur) return res.status(404).json({ message: 'Livreur non trouvé ou non actif' });

    await livreur.update({ latitude, longitude });

    try {
      const io = getIO();
      io.emit(`livreur:location:${livreur.livreurId}`, {
        livreurId: livreur.livreurId,
        latitude,
        longitude,
      });
    } catch {}

    return res.json({ message: 'Position mise à jour' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// PUT /livreur/toggle-online — Activer/désactiver mode livreur
export const toggleLivreurOnline = async (req, res) => {
  try {
    const userId = req.user?.id;
    const livreur = await Livreur.findOne({ where: { userId, status: 'active' } });
    if (!livreur) return res.status(404).json({ message: 'Profil livreur non actif' });

    await livreur.update({ isOnline: !livreur.isOnline });
    return res.json({ isOnline: livreur.isOnline, message: livreur.isOnline ? 'Mode livreur activé' : 'Mode livreur désactivé' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// GET /livreur/company/candidates — Candidatures pour l'entreprise (admin)
export const getCompanyLivreurs = async (req, res) => {
  try {
    const userId = req.user?.id;
    const userRoleRecord = await sequelize.models.UserRole.findOne({ where: { userId } });
    const companyId = userRoleRecord?.companyId;
    if (!companyId) return res.status(403).json({ message: 'Aucune entreprise associée à ce compte' });

    const { status } = req.query;
    const where = { companyId };
    if (status) where.status = status;

    const livreurs = await Livreur.findAll({
      where,
      include: [{ model: User, as: 'user', attributes: ['id', 'username', 'email', 'telephone', 'imageUrl'] }],
      order: [['createdAt', 'DESC']],
    });

    return res.json({ data: livreurs, total: livreurs.length });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// PUT /livreur/:id/status — Accepter/Refuser/Engager (admin)
export const updateLivreurStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const livreur = await Livreur.findByPk(id, {
      include: [{ model: User, as: 'user', attributes: ['id', 'username', 'email'] }],
    });
    if (!livreur) return res.status(404).json({ message: 'Livreur introuvable' });

    const updates = { status };
    let plainPassword = null;

    if (status === 'active') {
      plainPassword = generatePassword();
      updates.livreurPassword = await bcrypt.hash(plainPassword, 10);
    }

    await livreur.update(updates);

    const user = livreur.user;
    const notifMap = {
      accepted: {
        subject: 'Candidature livreur acceptée',
        msg: 'Votre candidature a été acceptée. Vous serez bientôt engagé comme livreur.',
      },
      rejected: {
        subject: 'Candidature livreur refusée',
        msg: 'Malheureusement votre candidature n\'a pas été retenue cette fois.',
      },
      active: {
        subject: 'Vous êtes maintenant livreur BIM NEXT !',
        msg: `Félicitations ! Vous êtes officiellement engagé comme livreur.\n\nVotre mot de passe livreur : <strong>${plainPassword}</strong>\n\nConnectez-vous via le bouton "Espace Livreur" sur la page de connexion de l'app BIM NEXT.`,
      },
    };

    const notif = notifMap[status];
    if (notif && user) {
      await sendEmail({
        to: user.email,
        subject: `BIM NEXT — ${notif.subject}`,
        html: `
          <h2 style="color:#0353CC">${notif.subject}</h2>
          <p>Bonjour <strong>${user.username}</strong>,</p>
          <p>${notif.msg}</p>
          <br/><p style="color:#888">— L'équipe BIM NEXT</p>
        `,
      });

      emitToUser(user.id, 'notification', {
        title: notif.subject,
        body: notif.msg.replace(/<[^>]*>/g, ''),
        type: 'livreur',
      });
    }

    return res.json({ message: 'Statut mis à jour', livreur });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// POST /livreur/:id/rate — Noter un livreur (user)
export const rateLivreur = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { id } = req.params;
    const { score, comment } = req.body;

    if (!score || score < 1 || score > 5)
      return res.status(400).json({ message: 'Note entre 1 et 5 requise' });

    const livreur = await Livreur.findByPk(id);
    if (!livreur) return res.status(404).json({ message: 'Livreur introuvable' });

    const [rating, created] = await LivreurRating.findOrCreate({
      where: { livreurId: id, userId },
      defaults: { livreurId: id, userId, score, comment: comment || null },
    });
    if (!created) await rating.update({ score, comment: comment || null });

    const all = await LivreurRating.findAll({ where: { livreurId: id } });
    const avg = all.reduce((s, r) => s + r.score, 0) / all.length;
    await livreur.update({ rating: parseFloat(avg.toFixed(2)), ratingCount: all.length });

    return res.json({ message: 'Note enregistrée', rating: parseFloat(avg.toFixed(2)), ratingCount: all.length });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// GET /livreur/public/:userId — Profil public livreur (nb entreprises + note)
export const getLivreurPublicProfile = async (req, res) => {
  try {
    const { userId } = req.params;
    const livreurs = await Livreur.findAll({
      where: { userId, status: 'active' },
      include: [{ model: Company, as: 'company', attributes: ['companyId', 'name', 'logo'] }],
    });
    const avg = livreurs.length ? livreurs.reduce((s, l) => s + parseFloat(l.rating || 0), 0) / livreurs.length : 0;
    return res.json({ data: livreurs, companiesCount: livreurs.length, averageRating: parseFloat(avg.toFixed(2)) });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// GET /livreur/orders/available — Commandes disponibles pour ce livreur
export const getAvailableOrders = async (req, res) => {
  try {
    const userId = req.user?.id;
    const livreur = await Livreur.findOne({ where: { userId, status: 'active' } });
    if (!livreur) return res.status(403).json({ message: 'Profil livreur actif requis' });

    // Commandes pending, non encore assignées, pour la même entreprise que le livreur
    const where = { status: 'pending', livreurId: null };
    if (livreur.companyId) where.companyId = livreur.companyId;

    const orders = await Order.findAll({
      where,
      include: [
        { model: User,    as: 'user',    attributes: ['id', 'username', 'telephone'] },
        { model: Company, as: 'company', attributes: ['companyId', 'name'] },
        { model: Product, as: 'product', attributes: ['productId', 'name'] },
      ],
      order: [['createdAt', 'DESC']],
    });

    // Grouper par orderNumber
    const grouped = {};
    for (const o of orders) {
      const d = o.toJSON();
      if (!grouped[d.orderNumber]) {
        grouped[d.orderNumber] = {
          orderNumber: d.orderNumber,
          status:      d.status,
          createdAt:   d.createdAt,
          shippingAddress: d.shippingAddress,
          clientPhone: d.clientPhone,
          user:        d.user,
          company:     d.company,
          items:       [],
          grandTotal:  0,
        };
      }
      grouped[d.orderNumber].items.push({ product: d.product, qty: d.quantity, unitPrice: d.unitPrice, totalAmount: d.totalAmount });
      grouped[d.orderNumber].grandTotal += parseFloat(d.totalAmount);
    }

    const result = Object.values(grouped).map(g => ({ ...g, grandTotal: parseFloat(g.grandTotal.toFixed(2)) }));
    return res.json({ data: result, total: result.length });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// PUT /livreur/orders/accept/:orderNumber — Accepter une commande (verrou atomique)
export const acceptOrder = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { orderNumber } = req.params;

    const livreur = await Livreur.findOne({ where: { userId, status: 'active' } });
    if (!livreur) return res.status(403).json({ message: 'Profil livreur actif requis' });

    // Verrou atomique : UPDATE uniquement si livreurId IS NULL
    const [count] = await Order.update(
      { livreurId: livreur.livreurId, status: 'confirmed' },
      { where: { orderNumber, livreurId: null, status: 'pending' } }
    );

    if (!count) {
      return res.status(409).json({ message: 'Cette commande a déjà été prise par un autre livreur' });
    }

    // Notifier le client en temps réel
    const firstOrder = await Order.findOne({
      where: { orderNumber },
      include: [
        { model: Livreur, as: 'livreur', include: [{ model: User, as: 'user', attributes: ['id', 'username', 'telephone'] }] },
      ],
    });

    emitOrderUpdate(orderNumber, {
      orderNumber,
      status: 'confirmed',
      livreur: firstOrder?.livreur ? {
        livreurId: firstOrder.livreur.livreurId,
        username:  firstOrder.livreur.user?.username,
        telephone: firstOrder.livreur.telephone,
        rating:    firstOrder.livreur.rating,
        latitude:  firstOrder.livreur.latitude,
        longitude: firstOrder.livreur.longitude,
      } : null,
    });

    if (firstOrder?.userId) {
      emitToUser(firstOrder.userId, 'notification', {
        title: 'Livreur assigné 🚴',
        body: `${firstOrder.livreur?.user?.username ?? 'Un livreur'} a accepté votre commande et est en route !`,
        type: 'order',
      });
    }

    return res.json({ message: 'Commande acceptée', livreurId: livreur.livreurId });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// PUT /livreur/orders/cancel/:orderNumber — Libérer une commande (livreur annule)
export const cancelDelivery = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { orderNumber } = req.params;

    const livreur = await Livreur.findOne({ where: { userId, status: 'active' } });
    if (!livreur) return res.status(403).json({ message: 'Profil livreur actif requis' });

    const [count] = await Order.update(
      { livreurId: null, status: 'pending' },
      { where: { orderNumber, livreurId: livreur.livreurId } }
    );

    if (!count) return res.status(404).json({ message: 'Commande introuvable ou non assignée à vous' });

    emitOrderUpdate(orderNumber, {
      orderNumber,
      status: 'pending',
      livreur: null,
    });

    return res.json({ message: 'Livraison annulée, commande de nouveau disponible' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// GET /livreur/orders/mine — Livraisons en cours du livreur
export const getMyDeliveries = async (req, res) => {
  try {
    const userId = req.user?.id;
    const livreur = await Livreur.findOne({ where: { userId, status: 'active' } });
    if (!livreur) return res.status(403).json({ message: 'Profil livreur actif requis' });

    const orders = await Order.findAll({
      where: { livreurId: livreur.livreurId, status: { [Op.notIn]: ['delivered', 'cancelled'] } },
      include: [
        { model: User,    as: 'user',    attributes: ['id', 'username', 'telephone'] },
        { model: Product, as: 'product', attributes: ['productId', 'name'] },
      ],
      order: [['createdAt', 'DESC']],
    });

    const grouped = {};
    for (const o of orders) {
      const d = o.toJSON();
      if (!grouped[d.orderNumber]) {
        grouped[d.orderNumber] = {
          orderNumber: d.orderNumber, status: d.status, createdAt: d.createdAt,
          shippingAddress: d.shippingAddress, clientPhone: d.clientPhone,
          user: d.user, items: [], grandTotal: 0,
        };
      }
      grouped[d.orderNumber].items.push({ product: d.product, qty: d.quantity, totalAmount: d.totalAmount });
      grouped[d.orderNumber].grandTotal += parseFloat(d.totalAmount);
    }

    const result = Object.values(grouped).map(g => ({ ...g, grandTotal: parseFloat(g.grandTotal.toFixed(2)) }));
    return res.json({ data: result, total: result.length });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

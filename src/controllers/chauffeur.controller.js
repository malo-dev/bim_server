import { Chauffeur, User, Ride, RideTier } from '../models/index.js';
import { getIO, emitToUser } from '../services/socket.service.js';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import crypto from 'crypto';

function haversineKm(lat1, lon1, lat2, lon2) {
  const R = 6371;
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = Math.sin(dLat / 2) ** 2 + Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * Math.sin(dLon / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

// ── Devenir chauffeur (inscription) ─────────────────────────────────────────
export const registerChauffeur = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { telephone, vehicleMake, vehicleModel, vehicleColor, plateNumber, vehicleTier, seats } = req.body;

    const existing = await Chauffeur.findOne({ where: { userId } });
    if (existing) {
      return res.status(400).json({ message: 'Vous avez déjà un profil chauffeur' });
    }

    const chauffeur = await Chauffeur.create({
      userId,
      telephone,
      vehicleMake,
      vehicleModel,
      vehicleColor,
      plateNumber,
      vehicleTier: vehicleTier || 'eco',
      seats: seats || 4,
      status: 'pending',
    });

    return res.status(201).json({ message: 'Demande envoyée, en attente de validation', data: chauffeur });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Mon profil chauffeur (app mobile, mode chauffeur) ────────────────────────
export const getMyChauffeur = async (req, res) => {
  try {
    const userId = req.user?.id;
    const chauffeur = await Chauffeur.findOne({ where: { userId } });
    if (!chauffeur) return res.status(404).json({ message: 'Aucun profil chauffeur' });
    return res.status(200).json({ data: chauffeur });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Liste (admin) ────────────────────────────────────────────────────────────
export const getAllChauffeurs = async (req, res) => {
  try {
    const { status, vehicleTier, isOnline, paginate = 'false', page = 1, pageSize = 20 } = req.query;
    const where = {};
    if (status) where.status = status;
    if (vehicleTier) where.vehicleTier = vehicleTier;
    if (isOnline !== undefined) where.isOnline = isOnline === 'true';

    const findOptions = {
      where,
      order: [['createdAt', 'DESC']],
      include: [{ model: User, as: 'user', attributes: ['id', 'username', 'email', 'imageUrl'] }],
    };

    if (paginate === 'true') {
      const limit = parseInt(pageSize, 10);
      const offset = (parseInt(page, 10) - 1) * limit;
      const { rows, count } = await Chauffeur.findAndCountAll({ ...findOptions, limit, offset });
      return res.status(200).json({ data: rows, total: count, currentPage: parseInt(page, 10), totalPages: Math.ceil(count / limit) });
    }

    const chauffeurs = await Chauffeur.findAll(findOptions);
    return res.status(200).json({ data: chauffeurs, total: chauffeurs.length });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

export const getChauffeurById = async (req, res) => {
  try {
    const chauffeur = await Chauffeur.findByPk(req.params.id, {
      include: [{ model: User, as: 'user', attributes: ['id', 'username', 'email', 'imageUrl'] }],
    });
    if (!chauffeur) return res.status(404).json({ message: 'Chauffeur introuvable' });
    return res.status(200).json({ data: chauffeur });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Admin : créer directement un chauffeur actif (sans passer par la demande) ─
// Génère un code à 6 chiffres unique parmi les chauffeurs — donné par l'admin
// au chauffeur pour qu'il accède à l'Espace Chauffeur sans compte préalable.
async function generateUniqueAccessCode() {
  for (let attempt = 0; attempt < 10; attempt++) {
    const code = String(Math.floor(100000 + Math.random() * 900000));
    const exists = await Chauffeur.findOne({ where: { accessCode: code } });
    if (!exists) return code;
  }
  throw new Error('Impossible de générer un code d\'accès unique');
}

export const adminCreateChauffeur = async (req, res) => {
  try {
    const { userId, fullname, telephone, vehicleMake, vehicleModel, vehicleColor, plateNumber, vehicleTier, seats } = req.body;
    // `userId` n'est plus obligatoire : un chauffeur peut être créé sans
    // compte BIM existant, et accéder lui-même via son code d'accès personnel.
    if (!userId && !fullname) {
      return res.status(400).json({ message: 'userId ou fullname requis' });
    }

    const avatarUrl = req.file ? `/images/${req.file.filename}` : null;
    const accessCode = await generateUniqueAccessCode();

    const chauffeur = await Chauffeur.create({
      userId: userId || null,
      fullname: fullname || null,
      accessCode,
      telephone, vehicleMake, vehicleModel, vehicleColor, plateNumber,
      vehicleTier: vehicleTier || 'eco',
      seats: seats || 4,
      status: 'active',
      avatarUrl,
    });
    return res.status(201).json({ message: 'Chauffeur créé', data: chauffeur });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

/* ════════════════════════════════════════════════════════════════════════
   Connexion par code d'accès personnel (pas besoin de compte BIM préalable)
   Body : { accessCode }
   ════════════════════════════════════════════════════════════════════════ */
export const chauffeurAccessLogin = async (req, res) => {
  try {
    const { accessCode } = req.body;
    if (!accessCode || !String(accessCode).trim()) {
      return res.status(400).json({ message: 'Code d\'accès requis' });
    }

    const chauffeur = await Chauffeur.findOne({ where: { accessCode: String(accessCode).trim() } });
    if (!chauffeur) return res.status(404).json({ message: 'Code d\'accès invalide' });
    if (chauffeur.status === 'rejected') {
      return res.status(403).json({ message: 'Ce profil chauffeur a été désactivé. Contactez le support BIM NEXT.' });
    }

    let user;
    if (chauffeur.userId) {
      user = await User.findByPk(chauffeur.userId);
      if (!user) return res.status(404).json({ message: 'Compte associé introuvable. Contactez le support BIM NEXT.' });
    } else {
      // Première connexion avec ce code : on crée le compte BIM du chauffeur
      // à la volée, comme pour l'accès rapide par téléphone.
      const randomPwd = crypto.randomBytes(24).toString('hex');
      const hashedPassword = await bcrypt.hash(randomPwd, 10);
      user = await User.create({
        username: chauffeur.fullname || `Chauffeur${chauffeur.chauffeurId}`,
        email: `chauffeur${chauffeur.chauffeurId}.${Date.now()}@bimreseau.generated`,
        password: hashedPassword,
        telephone: chauffeur.telephone || null,
        fullname: chauffeur.fullname || null,
        isActive: true,
        privacyAcceptedAt: new Date(),
      });
      await chauffeur.update({ userId: user.id });
    }

    const payload = { userId: user.id, email: user.email };
    const refreshToken = jwt.sign(payload, process.env.JWT_REFRESH_SECRET, { expiresIn: '365d' });
    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '30d' });
    await user.update({ refreshToken, Token: token });

    return res.status(200).json({
      message: 'Connexion réussie',
      token, refreshToken, userId: user.id,
    });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

export const updateChauffeur = async (req, res) => {
  try {
    const chauffeur = await Chauffeur.findByPk(req.params.id);
    if (!chauffeur) return res.status(404).json({ message: 'Chauffeur introuvable' });

    const payload = { ...req.body };
    if (req.file) payload.avatarUrl = `/images/${req.file.filename}`;

    await chauffeur.update(payload);
    return res.status(200).json({ message: 'Chauffeur mis à jour', data: chauffeur });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

export const deleteChauffeur = async (req, res) => {
  try {
    const chauffeur = await Chauffeur.findByPk(req.params.id);
    if (!chauffeur) return res.status(404).json({ message: 'Chauffeur introuvable' });
    await chauffeur.destroy();
    return res.status(200).json({ message: 'Chauffeur supprimé' });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Basculer en ligne / hors ligne ──────────────────────────────────────────
export const toggleOnline = async (req, res) => {
  try {
    const userId = req.user?.id;
    const chauffeur = await Chauffeur.findOne({ where: { userId } });
    if (!chauffeur) return res.status(404).json({ message: 'Profil chauffeur introuvable' });

    await chauffeur.update({ isOnline: !chauffeur.isOnline });
    return res.status(200).json({ message: chauffeur.isOnline ? 'En ligne' : 'Hors ligne', data: chauffeur });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Mettre à jour la position (appelé en polling ou via socket côté app chauffeur) ─
export const updateLocation = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { latitude, longitude } = req.body;
    const chauffeur = await Chauffeur.findOne({ where: { userId } });
    if (!chauffeur) return res.status(404).json({ message: 'Profil chauffeur introuvable' });

    const prevLat = chauffeur.latitude;
    const prevLng = chauffeur.longitude;
    await chauffeur.update({ latitude, longitude });

    // Si ce chauffeur a une course active, diffuse sa position aux passagers qui la suivent
    const activeRide = await Ride.findOne({
      where: { chauffeurId: chauffeur.chauffeurId, status: ['accepted', 'arriving', 'in_progress'] },
    });

    const payload = { latitude, longitude };

    // Course démarrée ("Commencer ma course") : le compteur kilométrique
    // (et donc le prix) avance en temps réel à chaque nouvelle position reçue
    // du chauffeur, au lieu de rester bloqué sur l'estimation de départ.
    if (activeRide && activeRide.status === 'in_progress' && prevLat != null && prevLng != null) {
      const segmentKm = haversineKm(Number(prevLat), Number(prevLng), Number(latitude), Number(longitude));
      // Ignore les sauts GPS aberrants (perte de signal, téléport) pour ne pas
      // facturer un trajet qui n'a jamais été parcouru.
      if (segmentKm > 0.005 && segmentKm < 2) {
        const newDistanceKm = parseFloat(activeRide.distanceKm || 0) + segmentKm;
        const tier = await RideTier.findByPk(activeRide.vehicleTier);
        const liveFare = tier
          ? parseFloat((Number(tier.base) + Number(tier.perKm) * newDistanceKm).toFixed(2))
          : activeRide.estimatedFare;

        await activeRide.update({ distanceKm: parseFloat(newDistanceKm.toFixed(3)) });
        payload.distanceKm = parseFloat(newDistanceKm.toFixed(2));
        payload.liveFare = liveFare;
      }
    }

    if (activeRide) {
      try {
        getIO().to(`ride_${activeRide.rideNumber}`).emit('ride:chauffeur_location', payload);
      } catch {}
    }

    return res.status(200).json({ message: 'Position mise à jour' });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

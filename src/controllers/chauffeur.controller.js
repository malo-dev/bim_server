import { Chauffeur, User, Ride } from '../models/index.js';
import { getIO, emitToUser } from '../services/socket.service.js';

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
export const adminCreateChauffeur = async (req, res) => {
  try {
    const { userId, telephone, vehicleMake, vehicleModel, vehicleColor, plateNumber, vehicleTier, seats } = req.body;
    if (!userId) return res.status(400).json({ message: 'userId requis' });

    const avatarUrl = req.file ? `/images/${req.file.filename}` : null;

    const chauffeur = await Chauffeur.create({
      userId, telephone, vehicleMake, vehicleModel, vehicleColor, plateNumber,
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

    await chauffeur.update({ latitude, longitude });

    // Si ce chauffeur a une course active, diffuse sa position aux passagers qui la suivent
    const activeRide = await Ride.findOne({
      where: { chauffeurId: chauffeur.chauffeurId, status: ['accepted', 'arriving', 'in_progress'] },
    });
    if (activeRide) {
      try {
        getIO().to(`ride_${activeRide.rideNumber}`).emit('ride:chauffeur_location', { latitude, longitude });
      } catch {}
    }

    return res.status(200).json({ message: 'Position mise à jour' });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

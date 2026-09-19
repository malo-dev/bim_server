import { Ride, Chauffeur, User, Transaction, RideTier } from '../models/index.js';
import sequelize from '../config/database.js';
import { getIO, emitToUser } from '../services/socket.service.js';

/* ─── Tarification ────────────────────────────────────────────────────────
 * Les gammes (base + prix/km) sont éditables depuis admin-bim, stockées en DB
 * (RideTier) — voir migration 20260919000001-create-ride-tiers. On garde un
 * petit cache mémoire de courte durée pour éviter une requête DB à chaque
 * estimation, tout en restant à jour rapidement après une modification admin.
 *
 * Pas d'intégration geocoding réelle pour le calcul de distance (éviterait
 * d'ajouter une dépendance native + clé API supplémentaire). Si les coordonnées
 * pickup/destination sont fournies, on calcule une vraie distance (Haversine).
 * Sinon, on dérive une distance stable (déterministe) à partir des adresses
 * saisies, pour que l'estimation et la confirmation restent cohérentes.
 */
let tiersCache = null;
let tiersCacheAt = 0;
const TIERS_CACHE_TTL = 30_000; // 30s

async function getTiers() {
  const now = Date.now();
  if (tiersCache && (now - tiersCacheAt) < TIERS_CACHE_TTL) return tiersCache;

  const rows = await RideTier.findAll({ where: { active: true }, order: [['sortOrder', 'ASC']] });
  const map = {};
  for (const r of rows) {
    map[r.tierKey] = {
      label: r.label, base: Number(r.base), perKm: Number(r.perKm),
      seats: r.seats, etaMin: r.etaMin,
    };
  }
  tiersCache = map;
  tiersCacheAt = now;
  return map;
}

function haversineKm(lat1, lon1, lat2, lon2) {
  const R = 6371;
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = Math.sin(dLat / 2) ** 2 + Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * Math.sin(dLon / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

function stableDistanceKm(pickup, destination) {
  const str = `${pickup}|${destination}`.toLowerCase();
  let hash = 0;
  for (let i = 0; i < str.length; i++) hash = (hash * 31 + str.charCodeAt(i)) >>> 0;
  return 2 + (hash % 1400) / 100; // entre 2 et 16 km
}

function computeDistance({ pickupAddress, destinationAddress, pickupLat, pickupLng, destinationLat, destinationLng }) {
  if (pickupLat && pickupLng && destinationLat && destinationLng) {
    return haversineKm(Number(pickupLat), Number(pickupLng), Number(destinationLat), Number(destinationLng));
  }
  return stableDistanceKm(pickupAddress || '', destinationAddress || '');
}

const genPickupCode = () => String(Math.floor(1000 + Math.random() * 9000));

// ── Estimation des tarifs par gamme ─────────────────────────────────────────
export const estimateRide = async (req, res) => {
  try {
    const { pickupAddress, destinationAddress } = req.body;
    if (!pickupAddress || !destinationAddress) {
      return res.status(400).json({ message: 'pickupAddress et destinationAddress requis' });
    }

    const distanceKm = computeDistance(req.body);
    const durationMin = Math.max(3, Math.round(distanceKm * 2.4));

    const TIERS = await getTiers();
    const tiers = Object.entries(TIERS).map(([key, t]) => ({
      tier: key,
      label: t.label,
      seats: t.seats,
      etaMin: t.etaMin,
      price: parseFloat((t.base + t.perKm * distanceKm).toFixed(2)),
    }));

    return res.status(200).json({
      data: { distanceKm: parseFloat(distanceKm.toFixed(2)), durationMin, tiers },
    });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Demande de course ────────────────────────────────────────────────────────
export const requestRide = async (req, res) => {
  try {
    const userId = req.user?.id;
    const {
      pickupAddress, pickupLat, pickupLng,
      destinationAddress, destinationLat, destinationLng,
      vehicleTier, paymentMethod,
    } = req.body;

    if (!pickupAddress || !destinationAddress) {
      return res.status(400).json({ message: 'pickupAddress et destinationAddress requis' });
    }

    const TIERS = await getTiers();
    const tierKey = TIERS[vehicleTier] ? vehicleTier : 'eco';
    const tierInfo = TIERS[tierKey];
    const distanceKm = computeDistance(req.body);
    const durationMin = Math.max(3, Math.round(distanceKm * 2.4));
    const estimatedFare = parseFloat((tierInfo.base + tierInfo.perKm * distanceKm).toFixed(2));

    const rideNumber = `RIDE-${Date.now()}-${userId}`;

    const ride = await Ride.create({
      rideNumber,
      userId,
      pickupAddress, pickupLat: pickupLat || null, pickupLng: pickupLng || null,
      destinationAddress, destinationLat: destinationLat || null, destinationLng: destinationLng || null,
      vehicleTier: tierKey,
      distanceKm: parseFloat(distanceKm.toFixed(2)),
      durationMin,
      estimatedFare,
      paymentMethod: paymentMethod || 'wallet',
      status: 'searching',
    });

    // Matching réel façon Uber/Bolt : la course est offerte à un chauffeur en
    // ligne à la fois (socket 'ride:incoming'), qui peut accepter ou refuser.
    // Sans réponse sous OFFER_TIMEOUT_MS, elle passe au suivant.
    offerToNextDriver(ride.rideId, rideNumber, tierKey);

    return res.status(201).json({ message: 'Recherche d\'un chauffeur en cours', data: ride });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

function emitRideUpdate(rideNumber, payload) {
  try { getIO().to(`ride_${rideNumber}`).emit('ride:status_updated', payload); } catch {}
}

/* ─── Offre de course en temps réel (accepter / refuser côté chauffeur) ────
 * État en mémoire (pas de schéma DB dédié) : rideId -> { chauffeurId,
 * declinedIds, timer }. Une seule offre active à la fois par course ; si le
 * chauffeur ne répond pas dans le délai, ou refuse, on passe au suivant.
 */
const OFFER_TIMEOUT_MS = 15_000;
export const pendingOffers = new Map();

export async function offerToNextDriver(rideId, rideNumber, tierKey) {
  try {
    const ride = await Ride.findByPk(rideId);
    if (!ride || ride.status !== 'searching') { pendingOffers.delete(rideId); return; }

    const declinedIds = pendingOffers.get(rideId)?.declinedIds || [];

    let candidates = await Chauffeur.findAll({
      where: { status: 'active', isOnline: true, isAvailable: true, vehicleTier: tierKey },
    });
    if (candidates.length === 0) {
      candidates = await Chauffeur.findAll({ where: { status: 'active', isOnline: true, isAvailable: true } });
    }
    candidates = candidates.filter((c) => !declinedIds.includes(c.chauffeurId));

    if (candidates.length === 0) {
      pendingOffers.delete(rideId);
      await ride.update({ status: 'cancelled', cancelReason: 'Aucun chauffeur disponible' });
      emitRideUpdate(rideNumber, { status: 'cancelled', reason: 'Aucun chauffeur disponible' });
      return;
    }

    const target = candidates[0];
    const timer = setTimeout(() => {
      const state = pendingOffers.get(rideId);
      if (!state) return;
      state.declinedIds.push(target.chauffeurId);
      offerToNextDriver(rideId, rideNumber, tierKey);
    }, OFFER_TIMEOUT_MS);

    pendingOffers.set(rideId, { chauffeurId: target.chauffeurId, declinedIds, timer });

    emitToUser(target.userId, 'ride:incoming', {
      rideNumber,
      pickupAddress: ride.pickupAddress,
      destinationAddress: ride.destinationAddress,
      distanceKm: ride.distanceKm,
      durationMin: ride.durationMin,
      estimatedFare: ride.estimatedFare,
      vehicleTier: ride.vehicleTier,
      expiresInSec: OFFER_TIMEOUT_MS / 1000,
    });
  } catch (err) {
    console.error('[ride offer] erreur:', err.message);
  }
}

function clearOffer(rideId) {
  const state = pendingOffers.get(rideId);
  if (state?.timer) clearTimeout(state.timer);
  pendingOffers.delete(rideId);
}

// ── Chauffeur accepte l'offre ────────────────────────────────────────────────
export const acceptRide = async (req, res) => {
  try {
    const userId = req.user?.id;
    const chauffeur = await Chauffeur.findOne({ where: { userId } });
    if (!chauffeur) return res.status(404).json({ message: 'Profil chauffeur introuvable' });

    const ride = await Ride.findOne({ where: { rideNumber: req.params.rideNumber } });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });
    if (ride.status !== 'searching') return res.status(400).json({ message: 'Cette course n\'est plus disponible' });

    const state = pendingOffers.get(ride.rideId);
    if (!state || state.chauffeurId !== chauffeur.chauffeurId) {
      return res.status(400).json({ message: 'Cette offre ne vous est plus destinée' });
    }
    clearOffer(ride.rideId);

    await chauffeur.update({ isAvailable: false });
    await ride.update({ chauffeurId: chauffeur.chauffeurId, status: 'accepted', pickupCode: genPickupCode() });
    emitRideUpdate(ride.rideNumber, { status: 'accepted', chauffeurId: chauffeur.chauffeurId });

    return res.status(200).json({ message: 'Course acceptée', data: ride });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Chauffeur refuse l'offre → passe au suivant ─────────────────────────────
export const declineRide = async (req, res) => {
  try {
    const userId = req.user?.id;
    const chauffeur = await Chauffeur.findOne({ where: { userId } });
    if (!chauffeur) return res.status(404).json({ message: 'Profil chauffeur introuvable' });

    const ride = await Ride.findOne({ where: { rideNumber: req.params.rideNumber } });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });

    const state = pendingOffers.get(ride.rideId);
    if (state && state.chauffeurId === chauffeur.chauffeurId) {
      if (state.timer) clearTimeout(state.timer);
      state.declinedIds.push(chauffeur.chauffeurId);
      offerToNextDriver(ride.rideId, ride.rideNumber, ride.vehicleTier);
    }
    return res.status(200).json({ message: 'Course refusée' });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Chauffeur signale son arrivée au point de prise en charge ──────────────
export const arrivedRide = async (req, res) => {
  try {
    const userId = req.user?.id;
    const chauffeur = await Chauffeur.findOne({ where: { userId } });
    if (!chauffeur) return res.status(404).json({ message: 'Profil chauffeur introuvable' });

    const ride = await Ride.findOne({ where: { rideNumber: req.params.rideNumber, chauffeurId: chauffeur.chauffeurId } });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });
    if (ride.status !== 'accepted') return res.status(400).json({ message: 'Statut de course invalide' });

    await ride.update({ status: 'arriving' });
    emitRideUpdate(ride.rideNumber, { status: 'arriving' });
    return res.status(200).json({ message: 'Arrivée signalée', data: ride });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Chauffeur démarre la course (passager à bord) ───────────────────────────
export const startRide = async (req, res) => {
  try {
    const userId = req.user?.id;
    const chauffeur = await Chauffeur.findOne({ where: { userId } });
    if (!chauffeur) return res.status(404).json({ message: 'Profil chauffeur introuvable' });

    const ride = await Ride.findOne({ where: { rideNumber: req.params.rideNumber, chauffeurId: chauffeur.chauffeurId } });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });
    if (!['accepted', 'arriving'].includes(ride.status)) return res.status(400).json({ message: 'Statut de course invalide' });

    await ride.update({ status: 'in_progress' });
    emitRideUpdate(ride.rideNumber, { status: 'in_progress' });
    return res.status(200).json({ message: 'Course démarrée', data: ride });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Chauffeur termine la course (arrivée à destination) ─────────────────────
export const completeRideByChauffeur = async (req, res) => {
  try {
    const userId = req.user?.id;
    const chauffeur = await Chauffeur.findOne({ where: { userId } });
    if (!chauffeur) return res.status(404).json({ message: 'Profil chauffeur introuvable' });

    const ride = await Ride.findOne({ where: { rideNumber: req.params.rideNumber, chauffeurId: chauffeur.chauffeurId } });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });
    if (ride.status !== 'in_progress') return res.status(400).json({ message: 'Statut de course invalide' });

    await completeRideInternal(ride);
    emitRideUpdate(ride.rideNumber, { status: 'completed' });
    return res.status(200).json({ message: 'Course terminée', data: ride });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Chauffeur annule une course déjà acceptée ───────────────────────────────
export const cancelRideByChauffeur = async (req, res) => {
  try {
    const userId = req.user?.id;
    const chauffeur = await Chauffeur.findOne({ where: { userId } });
    if (!chauffeur) return res.status(404).json({ message: 'Profil chauffeur introuvable' });

    const ride = await Ride.findOne({ where: { rideNumber: req.params.rideNumber, chauffeurId: chauffeur.chauffeurId } });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });
    if (['completed', 'cancelled'].includes(ride.status)) {
      return res.status(400).json({ message: 'Cette course ne peut plus être annulée' });
    }

    await chauffeur.update({ isAvailable: true });
    await ride.update({ status: 'cancelled', cancelReason: req.body?.reason || 'Annulée par le chauffeur' });
    emitRideUpdate(ride.rideNumber, { status: 'cancelled', reason: ride.cancelReason });

    return res.status(200).json({ message: 'Course annulée' });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Course active du chauffeur connecté (reprise après réouverture de l'app) ─
export const getChauffeurActiveRide = async (req, res) => {
  try {
    const userId = req.user?.id;
    const chauffeur = await Chauffeur.findOne({ where: { userId } });
    if (!chauffeur) return res.status(404).json({ message: 'Profil chauffeur introuvable' });

    const ride = await Ride.findOne({
      where: { chauffeurId: chauffeur.chauffeurId, status: ['accepted', 'arriving', 'in_progress'] },
      include: [{ model: User, as: 'passenger', attributes: ['id', 'username', 'imageUrl'] }],
      order: [['createdAt', 'DESC']],
    });
    return res.status(200).json({ data: ride || null });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

async function completeRideInternal(ride) {
  const t = await sequelize.transaction();
  try {
    const passenger = await User.findByPk(ride.userId, { transaction: t, lock: t.LOCK.UPDATE });
    const chauffeur = await Chauffeur.findByPk(ride.chauffeurId, { transaction: t });
    const fare = parseFloat(ride.estimatedFare);
    let paymentStatus = 'pending';

    if (passenger && parseFloat(passenger.soldNumber || 0) >= fare) {
      await passenger.update({ soldNumber: parseFloat(passenger.soldNumber || 0) - fare }, { transaction: t });
      if (chauffeur) {
        const driverUser = await User.findByPk(chauffeur.userId, { transaction: t, lock: t.LOCK.UPDATE });
        if (driverUser) await driverUser.update({ soldNumber: parseFloat(driverUser.soldNumber || 0) + fare }, { transaction: t });
      }
      await Transaction.create({
        amount: fare, status: 'réussi', description: `Course BIM Transport ${ride.rideNumber}`,
        transactionType: 'paiement', id: passenger.id,
      }, { transaction: t });
      paymentStatus = 'paid';
    }

    if (chauffeur) {
      await chauffeur.update({
        isAvailable: true,
        totalRides: chauffeur.totalRides + 1,
      }, { transaction: t });
    }

    await ride.update({ status: 'completed', finalFare: fare, paymentStatus }, { transaction: t });
    await t.commit();
  } catch (err) {
    await t.rollback();
    console.error('[ride complete] erreur:', err.message);
  }
}

// ── Détail d'une course ─────────────────────────────────────────────────────
export const getRideByNumber = async (req, res) => {
  try {
    const ride = await Ride.findOne({
      where: { rideNumber: req.params.rideNumber },
      include: [
        { model: Chauffeur, as: 'chauffeur', include: [{ model: User, as: 'user', attributes: ['id', 'username', 'imageUrl'] }] },
        { model: User, as: 'passenger', attributes: ['id', 'username', 'imageUrl', 'telephone'] },
      ],
    });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });
    return res.status(200).json({ data: ride });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Historique des courses du passager ──────────────────────────────────────
export const getUserRides = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { page = 1, pageSize = 20 } = req.query;
    const limit = parseInt(pageSize, 10);
    const offset = (parseInt(page, 10) - 1) * limit;

    const { rows, count } = await Ride.findAndCountAll({
      where: { userId },
      order: [['createdAt', 'DESC']],
      limit, offset,
      include: [
        { model: Chauffeur, as: 'chauffeur', include: [{ model: User, as: 'user', attributes: ['id', 'username', 'imageUrl'] }] },
      ],
    });

    return res.status(200).json({ data: rows, total: count, currentPage: parseInt(page, 10), totalPages: Math.ceil(count / limit) });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Annulation (avant prise en charge) ──────────────────────────────────────
export const cancelRide = async (req, res) => {
  try {
    const userId = req.user?.id;
    const ride = await Ride.findOne({ where: { rideNumber: req.params.rideNumber, userId } });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });
    if (['completed', 'cancelled'].includes(ride.status)) {
      return res.status(400).json({ message: 'Cette course ne peut plus être annulée' });
    }

    if (ride.chauffeurId) {
      const chauffeur = await Chauffeur.findByPk(ride.chauffeurId);
      if (chauffeur) await chauffeur.update({ isAvailable: true });
    }
    clearOffer(ride.rideId);

    await ride.update({ status: 'cancelled', cancelReason: req.body?.reason || 'Annulée par le passager' });
    emitRideUpdate(ride.rideNumber, { status: 'cancelled' });

    return res.status(200).json({ message: 'Course annulée' });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Note, compliments, pourboire, commentaire en fin de course ─────────────
export const rateRide = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const userId = req.user?.id;
    const { stars, compliments, comment, tip } = req.body;

    const ride = await Ride.findOne({ where: { rideNumber: req.params.rideNumber, userId }, transaction: t, lock: t.LOCK.UPDATE });
    if (!ride) { await t.rollback(); return res.status(404).json({ message: 'Course introuvable' }); }
    if (ride.status !== 'completed') { await t.rollback(); return res.status(400).json({ message: 'La course doit être terminée pour être notée' }); }

    const tipAmount = parseFloat(tip || 0);
    if (tipAmount > 0) {
      const passenger = await User.findByPk(userId, { transaction: t, lock: t.LOCK.UPDATE });
      if (passenger && parseFloat(passenger.soldNumber || 0) >= tipAmount) {
        await passenger.update({ soldNumber: parseFloat(passenger.soldNumber || 0) - tipAmount }, { transaction: t });
        if (ride.chauffeurId) {
          const chauffeur = await Chauffeur.findByPk(ride.chauffeurId, { transaction: t });
          if (chauffeur) {
            const driverUser = await User.findByPk(chauffeur.userId, { transaction: t, lock: t.LOCK.UPDATE });
            if (driverUser) await driverUser.update({ soldNumber: parseFloat(driverUser.soldNumber || 0) + tipAmount }, { transaction: t });
          }
        }
        await Transaction.create({
          amount: tipAmount, status: 'réussi', description: `Pourboire course ${ride.rideNumber}`,
          transactionType: 'paiement', id: userId,
        }, { transaction: t });
      }
    }

    if (ride.chauffeurId && stars) {
      const chauffeur = await Chauffeur.findByPk(ride.chauffeurId, { transaction: t });
      if (chauffeur) {
        const newCount = chauffeur.ratingCount + 1;
        const newRating = ((parseFloat(chauffeur.rating) * chauffeur.ratingCount) + Number(stars)) / newCount;
        await chauffeur.update({ rating: newRating.toFixed(2), ratingCount: newCount }, { transaction: t });
      }
    }

    await ride.update({
      rating: stars || null,
      ratingCompliments: compliments || null,
      ratingComment: comment || null,
      tip: tipAmount,
    }, { transaction: t });

    await t.commit();
    return res.status(200).json({ message: 'Merci pour votre avis', data: ride });
  } catch (error) {
    await t.rollback();
    return res.status(500).json({ message: error.message });
  }
};

import { Ride, Chauffeur, User, Transaction, RideTier } from '../models/index.js';
import { Op } from 'sequelize';
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

    // Le passager choisit lui-même son chauffeur (voir getAvailableChauffeurs
    // + offerRideToChauffeur ci-dessous) — pas de dispatch automatique ici.
    return res.status(201).json({ message: 'Course créée — choisissez votre chauffeur', data: ride });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

function emitRideUpdate(rideNumber, payload) {
  try { getIO().to(`ride_${rideNumber}`).emit('ride:status_updated', payload); } catch {}
}

/* ─── Offre de course en temps réel (accepter / refuser côté chauffeur) ────
 * État en mémoire (pas de schéma DB dédié) : rideId -> { chauffeurId, timer }.
 * Le passager choisit lui-même le chauffeur à qui envoyer l'offre (voir
 * getAvailableChauffeurs + offerRideToChauffeur) ; si ce chauffeur ne répond
 * pas sous OFFER_TIMEOUT_MS ou refuse, la course redevient "searching" et le
 * passager peut en choisir un autre dans la liste — pas de cycle automatique.
 */
const OFFER_TIMEOUT_MS = 15_000;
export const pendingOffers = new Map();

function clearOffer(rideId) {
  const state = pendingOffers.get(rideId);
  if (state?.timer) clearTimeout(state.timer);
  pendingOffers.delete(rideId);
}

async function sendOfferToChauffeur(ride, chauffeur) {
  const timer = setTimeout(() => {
    pendingOffers.delete(ride.rideId);
    emitRideUpdate(ride.rideNumber, { status: 'searching', reason: 'Le chauffeur n\'a pas répondu' });
  }, OFFER_TIMEOUT_MS);

  pendingOffers.set(ride.rideId, { chauffeurId: chauffeur.chauffeurId, timer });

  emitToUser(chauffeur.userId, 'ride:incoming', {
    rideNumber: ride.rideNumber,
    pickupAddress: ride.pickupAddress,
    destinationAddress: ride.destinationAddress,
    distanceKm: ride.distanceKm,
    durationMin: ride.durationMin,
    estimatedFare: ride.estimatedFare,
    vehicleTier: ride.vehicleTier,
    expiresInSec: OFFER_TIMEOUT_MS / 1000,
  });
}

// ── Liste des chauffeurs disponibles, triés par proximité (passager choisit) ─
export const getAvailableChauffeurs = async (req, res) => {
  try {
    const userId = req.user?.id;
    const ride = await Ride.findOne({ where: { rideNumber: req.params.rideNumber, userId } });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });
    if (ride.status !== 'searching') return res.status(400).json({ message: 'Cette course n\'est plus en recherche de chauffeur' });

    let candidates = await Chauffeur.findAll({
      where: { status: 'active', isOnline: true, isAvailable: true, vehicleTier: ride.vehicleTier },
      include: [{ model: User, as: 'user', attributes: ['id', 'username'] }],
    });
    if (candidates.length === 0) {
      candidates = await Chauffeur.findAll({
        where: { status: 'active', isOnline: true, isAvailable: true },
        include: [{ model: User, as: 'user', attributes: ['id', 'username'] }],
      });
    }

    const hasPickupCoords = ride.pickupLat && ride.pickupLng;
    const list = candidates.map((c) => {
      const distanceKm = hasPickupCoords && c.latitude && c.longitude
        ? haversineKm(Number(ride.pickupLat), Number(ride.pickupLng), Number(c.latitude), Number(c.longitude))
        : null;
      return {
        chauffeurId: c.chauffeurId,
        username: c.user?.username ?? 'Chauffeur',
        vehicleTier: c.vehicleTier,
        rating: c.rating,
        distanceKm: distanceKm !== null ? parseFloat(distanceKm.toFixed(2)) : null,
      };
    }).sort((a, b) => {
      if (a.distanceKm === null) return 1;
      if (b.distanceKm === null) return -1;
      return a.distanceKm - b.distanceKm;
    });

    return res.status(200).json({ data: list });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Le passager envoie l'offre à un chauffeur qu'il a choisi dans la liste ──
export const offerRideToChauffeur = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { rideNumber, chauffeurId } = req.params;

    const ride = await Ride.findOne({ where: { rideNumber, userId } });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });
    if (ride.status !== 'searching') return res.status(400).json({ message: 'Cette course n\'est plus en recherche de chauffeur' });

    const chauffeur = await Chauffeur.findOne({ where: { chauffeurId, status: 'active', isOnline: true, isAvailable: true } });
    if (!chauffeur) return res.status(404).json({ message: 'Ce chauffeur n\'est plus disponible' });

    clearOffer(ride.rideId);
    await sendOfferToChauffeur(ride, chauffeur);

    return res.status(200).json({ message: 'Offre envoyée au chauffeur' });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

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

// ── Chauffeur refuse l'offre → le passager en choisit un autre dans la liste ─
export const declineRide = async (req, res) => {
  try {
    const userId = req.user?.id;
    const chauffeur = await Chauffeur.findOne({ where: { userId } });
    if (!chauffeur) return res.status(404).json({ message: 'Profil chauffeur introuvable' });

    const ride = await Ride.findOne({ where: { rideNumber: req.params.rideNumber } });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });

    const state = pendingOffers.get(ride.rideId);
    if (state && state.chauffeurId === chauffeur.chauffeurId) {
      clearOffer(ride.rideId);
      emitRideUpdate(ride.rideNumber, { status: 'searching', reason: 'Chauffeur indisponible' });
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

// ── Démarrage de la course — déclenché par le PASSAGER une fois le chauffeur
//    arrivé (bouton "Commencer la course" côté client) ─────────────────────
export const startRide = async (req, res) => {
  try {
    const userId = req.user?.id;

    const ride = await Ride.findOne({ where: { rideNumber: req.params.rideNumber } });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });

    const chauffeur = await Chauffeur.findOne({ where: { chauffeurId: ride.chauffeurId } });
    const isPassenger = ride.userId === userId;
    const isAssignedChauffeur = chauffeur && chauffeur.userId === userId;
    if (!isPassenger && !isAssignedChauffeur) {
      return res.status(403).json({ message: 'Non autorisé pour cette course' });
    }
    if (!['accepted', 'arriving'].includes(ride.status)) return res.status(400).json({ message: 'Statut de course invalide' });

    // On repart de 0 km au démarrage réel de la course : `distanceKm` servait
    // jusqu'ici à l'estimation (pickup → destination à vol d'oiseau), le
    // compteur en temps réel (voir chauffeur.controller.updateLocation) part
    // du point de prise en charge, pas de l'estimation de départ.
    await ride.update({ status: 'in_progress', distanceKm: 0 });
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

    // Prix final basé sur la distance réellement parcourue (compteur en
    // temps réel démarré avec "Démarrer la course") plutôt que la simple
    // estimation de départ — sauf si le compteur n'a jamais avancé (ex: GPS
    // indisponible), où l'estimation de départ reste la meilleure base.
    const tier = await RideTier.findByPk(ride.vehicleTier, { transaction: t });
    const trackedKm = parseFloat(ride.distanceKm || 0);
    const fare = (tier && trackedKm > 0.05)
      ? parseFloat((Number(tier.base) + Number(tier.perKm) * trackedKm).toFixed(2))
      : parseFloat(ride.estimatedFare);
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

/* ════════════════════════════════════════════════════════════════════════
   ADMIN — supervision des courses (admin-bim)
   ════════════════════════════════════════════════════════════════════════ */

// ── Liste de toutes les courses (tous utilisateurs) — filtrable par statut/période ──
export const getAllRidesAdmin = async (req, res) => {
  try {
    const { page = 1, pageSize = 20, status, period } = req.query;
    const limit = parseInt(pageSize, 10);
    const offset = (parseInt(page, 10) - 1) * limit;

    const where = {};
    if (status) where.status = status;
    if (period) {
      const start = new Date();
      if (period === 'today') start.setHours(0, 0, 0, 0);
      else if (period === 'week') start.setDate(start.getDate() - 7);
      else if (period === 'month') start.setMonth(start.getMonth() - 1);
      where.createdAt = { [Op.gte]: start };
    }

    const { rows, count } = await Ride.findAndCountAll({
      where,
      order: [['createdAt', 'DESC']],
      limit, offset,
      include: [
        { model: User, as: 'passenger', attributes: ['id', 'username', 'email', 'telephone'] },
        {
          model: Chauffeur, as: 'chauffeur',
          include: [{ model: User, as: 'user', attributes: ['id', 'username', 'telephone'] }],
        },
      ],
    });

    return res.status(200).json({ data: rows, total: count, currentPage: parseInt(page, 10), totalPages: Math.ceil(count / limit) });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Assignation manuelle d'un chauffeur par un admin (dispatch) ──────────────
// Utile quand le matching automatique ne trouve personne, ou pour prioriser
// un chauffeur précis — l'admin appelle alors lui-même le chauffeur pour lui
// dire d'aller récupérer le client, donc pas besoin d'un accept/decline côté
// chauffeur comme pour une offre automatique : l'affectation est immédiate.
export const adminAssignChauffeur = async (req, res) => {
  try {
    const { rideNumber } = req.params;
    const { chauffeurId } = req.body;
    if (!chauffeurId) return res.status(400).json({ message: 'chauffeurId est obligatoire' });

    const ride = await Ride.findOne({ where: { rideNumber } });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });
    if (ride.status !== 'searching') {
      return res.status(400).json({ message: 'Cette course n\'est plus en attente d\'un chauffeur' });
    }

    const chauffeur = await Chauffeur.findByPk(chauffeurId);
    if (!chauffeur) return res.status(404).json({ message: 'Chauffeur introuvable' });
    if (!chauffeur.isAvailable) {
      return res.status(400).json({ message: 'Ce chauffeur n\'est pas disponible actuellement' });
    }

    clearOffer(ride.rideId);
    await chauffeur.update({ isAvailable: false });
    await ride.update({ chauffeurId: chauffeur.chauffeurId, status: 'accepted', pickupCode: genPickupCode() });

    emitRideUpdate(ride.rideNumber, { status: 'accepted', chauffeurId: chauffeur.chauffeurId });
    emitToUser(chauffeur.userId, 'ride:incoming', {
      rideNumber: ride.rideNumber,
      pickupAddress: ride.pickupAddress,
      destinationAddress: ride.destinationAddress,
      distanceKm: ride.distanceKm,
      durationMin: ride.durationMin,
      estimatedFare: ride.estimatedFare,
      vehicleTier: ride.vehicleTier,
      assignedByAdmin: true,
    });

    return res.status(200).json({ message: 'Chauffeur assigné à la course', data: ride });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Chauffeurs en ligne et disponibles, pour le sélecteur d'assignation admin ──
export const getAvailableChauffeursAdmin = async (req, res) => {
  try {
    // Pas de condition `isOnline` : contrairement au matching automatique de
    // l'app (qui pousse l'offre en temps réel), l'admin appelle lui-même le
    // chauffeur par téléphone — il n'a donc pas besoin d'avoir l'app ouverte
    // pour être assignable, juste d'être actif et pas déjà sur une course.
    const chauffeurs = await Chauffeur.findAll({
      where: { status: 'active', isAvailable: true },
      include: [{ model: User, as: 'user', attributes: ['id', 'username', 'telephone'] }],
      order: [['isOnline', 'DESC'], ['rating', 'DESC']],
    });
    return res.status(200).json({ data: chauffeurs });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

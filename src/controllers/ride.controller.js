import { Ride, Chauffeur, User, Transaction, RideTier } from '../models/index.js';
import { Op } from 'sequelize';
import sequelize from '../config/database.js';
import { getIO, emitToUser } from '../services/socket.service.js';
import { pushToUser } from '../services/pushNotification.service.js';
import { isBimAdminUserId } from '../utils/bimAdmin.util.js';

// Statuts d'une course « vivante » (chauffeur assigné, pas encore terminée).
const LIVE = ['accepted', 'arriving', 'in_progress'];
// Une recherche de chauffeur abandonnée depuis plus longtemps n'est plus proposée.
const SEARCH_TTL_MS = 20 * 60 * 1000;

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

    // Une seule course à la fois : si une course est déjà en route, on la renvoie.
    const live = await Ride.findOne({ where: { userId, status: LIVE }, order: [['createdAt', 'DESC']] });
    if (live) {
      return res.status(409).json({ message: 'Tu as déjà une course en cours.', code: 'RIDE_IN_PROGRESS', rideNumber: live.rideNumber });
    }
    // Recherches précédentes jamais abouties : annulées pour ne pas les laisser traîner.
    const stale = await Ride.findAll({ where: { userId, status: 'searching' } });
    for (const r of stale) {
      clearOffer(r.rideId);
      await r.update({ status: 'cancelled', cancelReason: 'Remplacée par une nouvelle demande' });
    }

    const TIERS = await getTiers();
    const tierKey = TIERS[vehicleTier] ? vehicleTier : Object.keys(TIERS)[0];
    const tierInfo = TIERS[tierKey];
    if (!tierInfo) return res.status(503).json({ message: 'Aucune gamme de véhicule disponible pour le moment.' });
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

  pendingOffers.set(ride.rideId, { chauffeurId: chauffeur.chauffeurId, timer, expiresAt: Date.now() + OFFER_TIMEOUT_MS });

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

    // TOUS les chauffeurs en ligne et libres (le passager choisit) : ceux de
    // la gamme demandée d'abord, puis par distance du point de prise en charge.
    const candidates = await Chauffeur.findAll({
      where: { status: 'active', isOnline: true, isAvailable: true },
      include: [{ model: User, as: 'user', attributes: ['id', 'username', 'fullname', 'imageUrl'] }],
    });

    const hasPickupCoords = ride.pickupLat && ride.pickupLng;
    const offer = pendingOffers.get(ride.rideId);
    const list = candidates.map((c) => {
      const distanceKm = hasPickupCoords && c.latitude && c.longitude
        ? haversineKm(Number(ride.pickupLat), Number(ride.pickupLng), Number(c.latitude), Number(c.longitude))
        : null;
      return {
        chauffeurId: c.chauffeurId,
        username: c.fullname || c.user?.fullname || c.user?.username || 'Chauffeur',
        avatarUrl: c.avatarUrl || c.user?.imageUrl || null,
        vehicleTier: c.vehicleTier,
        sameTier: c.vehicleTier === ride.vehicleTier,
        vehicle: [c.vehicleMake, c.vehicleModel].filter(Boolean).join(' ') || null,
        vehicleColor: c.vehicleColor || null,
        plateNumber: c.plateNumber || null,
        seats: c.seats,
        rating: c.rating,
        totalRides: c.totalRides,
        distanceKm: distanceKm !== null ? parseFloat(distanceKm.toFixed(2)) : null,
        // ~2,5 min/km en ville, 2 min minimum.
        etaMin: distanceKm !== null ? Math.max(2, Math.round(distanceKm * 2.5)) : null,
        pending: offer?.chauffeurId === c.chauffeurId,
      };
    }).sort((a, b) => {
      if (a.sameTier !== b.sameTier) return a.sameTier ? -1 : 1;
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
    // App du chauffeur en arrière-plan : le push le réveille.
    pushToUser(chauffeur.userId, '🚖 Nouvelle course', `${ride.pickupAddress} → ${ride.destinationAddress} · ${ride.estimatedFare} EC. Ouvre l'app pour accepter.`, { rideNumber: ride.rideNumber }).catch(() => {});

    return res.status(200).json({ message: 'Offre envoyée au chauffeur', expiresInSec: OFFER_TIMEOUT_MS / 1000 });
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

    // Mise à jour conditionnelle : si la course a été annulée ou prise entre-temps, on n'écrase rien.
    const [count] = await Ride.update(
      { chauffeurId: chauffeur.chauffeurId, status: 'accepted', pickupCode: genPickupCode() },
      { where: { rideId: ride.rideId, status: 'searching' } }
    );
    if (!count) return res.status(409).json({ message: 'Cette course n\'est plus disponible' });
    await chauffeur.update({ isAvailable: false });
    await ride.reload();
    emitRideUpdate(ride.rideNumber, { rideNumber: ride.rideNumber, status: 'accepted', chauffeurId: chauffeur.chauffeurId });
    emitToUser(ride.userId, 'ride:status_updated', { rideNumber: ride.rideNumber, status: 'accepted' });
    pushToUser(ride.userId, '🚖 Chauffeur trouvé', `${chauffeur.fullname || 'Ton chauffeur'} a accepté ta course et arrive.${chauffeur.plateNumber ? ` Plaque : ${chauffeur.plateNumber}.` : ''}`, { rideNumber: ride.rideNumber }).catch(() => {});

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
    emitRideUpdate(ride.rideNumber, { rideNumber: ride.rideNumber, status: 'arriving' });
    emitToUser(ride.userId, 'ride:status_updated', { rideNumber: ride.rideNumber, status: 'arriving' });
    pushToUser(ride.userId, '📍 Ton chauffeur est là', `Il t'attend au point de prise en charge. Donne-lui ton code : ${ride.pickupCode}.`, { rideNumber: ride.rideNumber }).catch(() => {});
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

    // Le chauffeur démarre avec le code que le passager lui donne : preuve que
    // le bon passager est monté. Le passager, lui, peut démarrer directement.
    if (isAssignedChauffeur && !isPassenger) {
      const code = String(req.body?.pickupCode ?? '').trim();
      if (!ride.pickupCode || code !== String(ride.pickupCode)) {
        return res.status(400).json({ message: 'Code incorrect. Demande au passager le code affiché dans son app.' });
      }
    }

    // On repart de 0 km au démarrage réel de la course : `distanceKm` servait
    // jusqu'ici à l'estimation (pickup → destination à vol d'oiseau), le
    // compteur en temps réel (voir chauffeur.controller.updateLocation) part
    // du point de prise en charge, pas de l'estimation de départ.
    await ride.update({ status: 'in_progress', distanceKm: 0 });
    emitRideUpdate(ride.rideNumber, { rideNumber: ride.rideNumber, status: 'in_progress' });
    emitToUser(ride.userId, 'ride:status_updated', { rideNumber: ride.rideNumber, status: 'in_progress' });
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

    // Avant : une erreur de paiement était avalée et la course annoncée
    // « terminée » alors qu'elle restait en cours en base.
    const { fare, paymentStatus } = await completeRideInternal(ride);
    const payload = { rideNumber: ride.rideNumber, status: 'completed', finalFare: fare, paymentStatus };
    emitRideUpdate(ride.rideNumber, payload);
    emitToUser(ride.userId, 'ride:status_updated', payload);
    pushToUser(ride.userId, '🏁 Course terminée',
      paymentStatus === 'paid'
        ? `${fare} EC payés depuis ton solde. Merci d'avoir roulé avec BIM NEXT !`
        : `Solde insuffisant : règle ${fare} EC en espèces au chauffeur.`,
      { rideNumber: ride.rideNumber }).catch(() => {});
    if (paymentStatus === 'paid') {
      pushToUser(chauffeur.userId, '💰 Paiement reçu', `${fare} EC crédités sur ton solde pour la course.`, { rideNumber: ride.rideNumber }).catch(() => {});
    }
    return res.status(200).json({ message: 'Course terminée', data: ride, finalFare: fare, paymentStatus });
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
    emitRideUpdate(ride.rideNumber, { rideNumber: ride.rideNumber, status: 'cancelled', reason: ride.cancelReason });
    emitToUser(ride.userId, 'ride:status_updated', { rideNumber: ride.rideNumber, status: 'cancelled', reason: ride.cancelReason });
    pushToUser(ride.userId, '❌ Course annulée', 'Le chauffeur a annulé la course. Tu peux en commander une autre.', { rideNumber: ride.rideNumber }).catch(() => {});

    return res.status(200).json({ message: 'Course annulée' });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Offre en attente pour le chauffeur connecté ─────────────────────────────
// Filet de sécurité de l'événement socket « ride:incoming » : si l'app était
// fermée (ouverte depuis le push), l'offre est récupérée ici.
export const getChauffeurPendingOffer = async (req, res) => {
  try {
    const chauffeur = await Chauffeur.findOne({ where: { userId: req.user?.id } });
    if (!chauffeur) return res.status(404).json({ message: 'Profil chauffeur introuvable' });

    for (const [rideId, state] of pendingOffers.entries()) {
      if (state.chauffeurId !== chauffeur.chauffeurId) continue;
      const left = Math.floor((state.expiresAt - Date.now()) / 1000);
      if (left <= 1) continue;
      const ride = await Ride.findByPk(rideId);
      if (!ride || ride.status !== 'searching') continue;
      return res.status(200).json({
        data: {
          rideNumber: ride.rideNumber,
          pickupAddress: ride.pickupAddress,
          destinationAddress: ride.destinationAddress,
          distanceKm: ride.distanceKm,
          durationMin: ride.durationMin,
          estimatedFare: ride.estimatedFare,
          vehicleTier: ride.vehicleTier,
          expiresInSec: left,
        },
      });
    }
    return res.status(200).json({ data: null });
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
    // Verrou sur la course : deux clics « Terminer » ne débitent pas deux fois.
    const fresh = await Ride.findByPk(ride.rideId, { transaction: t, lock: t.LOCK.UPDATE });
    if (!fresh || fresh.status !== 'in_progress') throw new Error('Cette course n\'est plus en cours');
    ride = fresh;
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
    return { fare, paymentStatus };
  } catch (err) {
    await t.rollback();
    console.error('[ride complete] erreur:', err.message);
    throw err;
  }
}

// ── Détail d'une course ─────────────────────────────────────────────────────
// Visible uniquement par le passager, le chauffeur assigné et les admins BIM.
// Le code d'accès du chauffeur n'est jamais renvoyé (il permettait de se
// connecter à l'Espace Chauffeur), et le code de prise en charge n'est montré
// qu'au passager (le chauffeur doit le lui demander pour démarrer).
const CHAUFFEUR_PUBLIC = ['chauffeurId', 'userId', 'fullname', 'telephone', 'vehicleMake', 'vehicleModel', 'vehicleColor', 'plateNumber', 'vehicleTier', 'seats', 'rating', 'ratingCount', 'totalRides', 'latitude', 'longitude', 'avatarUrl'];

const loadRide = (where) => Ride.findOne({
  where,
  include: [
    { model: Chauffeur, as: 'chauffeur', attributes: CHAUFFEUR_PUBLIC, include: [{ model: User, as: 'user', attributes: ['id', 'username', 'fullname', 'imageUrl'] }] },
    { model: User, as: 'passenger', attributes: ['id', 'username', 'fullname', 'imageUrl', 'telephone'] },
  ],
  order: [['createdAt', 'DESC']],
});

export const getRideByNumber = async (req, res) => {
  try {
    const userId = req.user?.id;
    const ride = await loadRide({ rideNumber: req.params.rideNumber });
    if (!ride) return res.status(404).json({ message: 'Course introuvable' });

    const isPassenger = ride.userId === userId;
    const isChauffeur = ride.chauffeur?.userId === userId;
    if (!isPassenger && !isChauffeur && !(await isBimAdminUserId(userId))) {
      return res.status(403).json({ message: 'Non autorisé pour cette course' });
    }
    const data = ride.toJSON();
    if (!isPassenger) delete data.pickupCode;
    return res.status(200).json({ data });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Course en cours du passager (bandeau « course en cours » de l'accueil) ──
export const getMyActiveRide = async (req, res) => {
  try {
    const userId = req.user?.id;
    let ride = await loadRide({ userId, status: LIVE });
    if (!ride) {
      ride = await loadRide({ userId, status: 'searching', createdAt: { [Op.gte]: new Date(Date.now() - SEARCH_TTL_MS) } });
    }
    return res.status(200).json({ data: ride ? ride.toJSON() : null });
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
        { model: Chauffeur, as: 'chauffeur', attributes: CHAUFFEUR_PUBLIC, include: [{ model: User, as: 'user', attributes: ['id', 'username', 'imageUrl'] }] },
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

    if (ride.status === 'in_progress') {
      return res.status(400).json({ message: 'La course a déjà démarré : demande au chauffeur de la terminer.' });
    }

    let chauffeur = null;
    if (ride.chauffeurId) {
      chauffeur = await Chauffeur.findByPk(ride.chauffeurId);
      if (chauffeur) await chauffeur.update({ isAvailable: true });
    }
    clearOffer(ride.rideId);

    await ride.update({ status: 'cancelled', cancelReason: req.body?.reason || 'Annulée par le passager' });
    emitRideUpdate(ride.rideNumber, { rideNumber: ride.rideNumber, status: 'cancelled', reason: ride.cancelReason });
    if (chauffeur?.userId) {
      emitToUser(chauffeur.userId, 'ride:status_updated', { rideNumber: ride.rideNumber, status: 'cancelled', reason: ride.cancelReason });
      pushToUser(chauffeur.userId, '❌ Course annulée', 'Le passager a annulé la course.', { rideNumber: ride.rideNumber }).catch(() => {});
    }

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

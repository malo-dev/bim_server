import { Ride, Chauffeur, User, Transaction } from '../models/index.js';
import sequelize from '../config/database.js';
import { getIO, emitToUser } from '../services/socket.service.js';

/* ─── Tarification ────────────────────────────────────────────────────────
 * Pas d'intégration cartographique/geocoding réelle pour l'instant (éviterait
 * d'ajouter une dépendance native + clé API supplémentaire). Si les coordonnées
 * pickup/destination sont fournies, on calcule une vraie distance (Haversine).
 * Sinon, on dérive une distance stable (déterministe) à partir des adresses
 * saisies, pour que l'estimation et la confirmation restent cohérentes.
 */
const TIERS = {
  eco:     { label: 'Bim Eco',     base: 3,   perKm: 1.75, seats: 4, etaMin: 3, image: 'eco' },
  confort: { label: 'Bim Confort', base: 5,   perKm: 2.6,  seats: 4, etaMin: 5, image: 'confort' },
  green:   { label: 'Bim Green',   base: 3.5, perKm: 2,    seats: 4, etaMin: 4, image: 'green' },
  van:     { label: 'Bim Van',     base: 8,   perKm: 3.3,  seats: 6, etaMin: 8, image: 'van' },
  moto:    { label: 'Moto Express',base: 2,   perKm: 1.2,  seats: 1, etaMin: 3, image: 'moto' },
};

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

    // Matching automatique simulé (pas d'app chauffeur dédiée pour l'instant) :
    // recherche un chauffeur en ligne/disponible, idéalement de la bonne gamme.
    simulateMatching(ride.rideId, rideNumber, tierKey);

    return res.status(201).json({ message: 'Recherche d\'un chauffeur en cours', data: ride });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

function emitRideUpdate(rideNumber, payload) {
  try { getIO().to(`ride_${rideNumber}`).emit('ride:status_updated', payload); } catch {}
}

async function simulateMatching(rideId, rideNumber, tierKey) {
  setTimeout(async () => {
    try {
      const ride = await Ride.findByPk(rideId);
      if (!ride || ride.status !== 'searching') return; // annulée entre-temps

      let chauffeur = await Chauffeur.findOne({
        where: { status: 'active', isOnline: true, isAvailable: true, vehicleTier: tierKey },
      });
      if (!chauffeur) {
        chauffeur = await Chauffeur.findOne({ where: { status: 'active', isOnline: true, isAvailable: true } });
      }

      if (!chauffeur) {
        await ride.update({ status: 'cancelled', cancelReason: 'Aucun chauffeur disponible' });
        emitRideUpdate(rideNumber, { status: 'cancelled', reason: 'Aucun chauffeur disponible' });
        return;
      }

      await chauffeur.update({ isAvailable: false });
      await ride.update({ chauffeurId: chauffeur.chauffeurId, status: 'accepted', pickupCode: genPickupCode() });
      emitRideUpdate(rideNumber, { status: 'accepted', chauffeurId: chauffeur.chauffeurId });

      // Simule l'arrivée puis le trajet jusqu'à destination.
      setTimeout(async () => {
        const r = await Ride.findByPk(rideId);
        if (!r || r.status !== 'accepted') return;
        await r.update({ status: 'in_progress' });
        emitRideUpdate(rideNumber, { status: 'in_progress' });

        setTimeout(async () => {
          const r2 = await Ride.findByPk(rideId);
          if (!r2 || r2.status !== 'in_progress') return;
          await completeRideInternal(r2);
          emitRideUpdate(rideNumber, { status: 'completed' });
        }, 18000);
      }, 8000);
    } catch (err) {
      console.error('[ride matching] erreur:', err.message);
    }
  }, 4000);
}

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

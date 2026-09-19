import express from 'express';
import {
  estimateRide,
  requestRide,
  getRideByNumber,
  getUserRides,
  cancelRide,
  rateRide,
  acceptRide,
  declineRide,
  arrivedRide,
  startRide,
  completeRideByChauffeur,
  cancelRideByChauffeur,
  getChauffeurActiveRide,
} from '../controllers/ride.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();

router.post('/estimate', authMiddleware, estimateRide);
router.post('/request', authMiddleware, requestRide);
router.get('/history', authMiddleware, getUserRides);
router.get('/chauffeur/active', authMiddleware, getChauffeurActiveRide);
router.get('/:rideNumber', authMiddleware, getRideByNumber);
router.put('/:rideNumber/cancel', authMiddleware, cancelRide);
router.post('/:rideNumber/rate', authMiddleware, rateRide);

// ── Côté chauffeur (mode chauffeur, même app) ──
router.post('/:rideNumber/accept', authMiddleware, acceptRide);
router.post('/:rideNumber/decline', authMiddleware, declineRide);
router.put('/:rideNumber/arrived', authMiddleware, arrivedRide);
router.put('/:rideNumber/start', authMiddleware, startRide);
router.put('/:rideNumber/complete', authMiddleware, completeRideByChauffeur);
router.put('/:rideNumber/chauffeur-cancel', authMiddleware, cancelRideByChauffeur);

export default router;

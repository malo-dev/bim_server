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
  getAllRidesAdmin,
  adminAssignChauffeur,
  getAvailableChauffeursAdmin,
  getAvailableChauffeurs,
  offerRideToChauffeur,
} from '../controllers/ride.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();

router.post('/estimate', authMiddleware, estimateRide);
router.post('/request', authMiddleware, requestRide);
router.get('/history', authMiddleware, getUserRides);
router.get('/chauffeur/active', authMiddleware, getChauffeurActiveRide);

// ── Le passager choisit lui-même son chauffeur ──
router.get('/:rideNumber/chauffeurs', authMiddleware, getAvailableChauffeurs);
router.post('/:rideNumber/offer/:chauffeurId', authMiddleware, offerRideToChauffeur);

// ── Admin (admin-bim) ──
router.get('/admin/all', authMiddleware, getAllRidesAdmin);
router.get('/admin/available-chauffeurs', authMiddleware, getAvailableChauffeursAdmin);
router.post('/admin/:rideNumber/assign', authMiddleware, adminAssignChauffeur);
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

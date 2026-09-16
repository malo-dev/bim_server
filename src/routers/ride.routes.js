import express from 'express';
import {
  estimateRide,
  requestRide,
  getRideByNumber,
  getUserRides,
  cancelRide,
  rateRide,
} from '../controllers/ride.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();

router.post('/estimate', authMiddleware, estimateRide);
router.post('/request', authMiddleware, requestRide);
router.get('/history', authMiddleware, getUserRides);
router.get('/:rideNumber', authMiddleware, getRideByNumber);
router.put('/:rideNumber/cancel', authMiddleware, cancelRide);
router.post('/:rideNumber/rate', authMiddleware, rateRide);

export default router;

import express from 'express';
import { getAllConsumptions, getLoyaltyProgress } from '../controllers/productConsumption.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();

router.get('/', authMiddleware, getAllConsumptions);
router.get('/loyalty-progress', authMiddleware, getLoyaltyProgress);

export default router;

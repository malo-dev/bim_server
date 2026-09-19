import express from 'express';
import {
  getAllTiers,
  createTier,
  updateTier,
  deleteTier,
} from '../controllers/rideTier.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();

router.get('/', authMiddleware, getAllTiers);
router.post('/', authMiddleware, createTier);
router.put('/:tierKey', authMiddleware, updateTier);
router.delete('/:tierKey', authMiddleware, deleteTier);

export default router;

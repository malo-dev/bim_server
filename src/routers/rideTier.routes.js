import express from 'express';
import {
  getAllTiers,
  createTier,
  updateTier,
  deleteTier,
} from '../controllers/rideTier.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import upload from '../../middlewares/upload.js';

const router = express.Router();

router.get('/', authMiddleware, getAllTiers);
router.post('/', authMiddleware, upload.single('image'), createTier);
router.put('/:tierKey', authMiddleware, upload.single('image'), updateTier);
router.delete('/:tierKey', authMiddleware, deleteTier);

export default router;

import express from 'express';
import {
  getAllExpeTracks,
  getExpeTrackById,
  createExpeTrack,
  updateExpeTrack,
  deleteExpeTrack,
} from '../controllers/expetrack.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import upload from '../../middlewares/upload.js';

const router = express.Router();
router.get('/', authMiddleware, getAllExpeTracks);
router.get('/:id', authMiddleware, getExpeTrackById);
router.post('/create', authMiddleware, upload.single('image'), createExpeTrack);
router.put('/update/:id', authMiddleware, upload.single('image'), updateExpeTrack);
router.delete('/delete/:id', authMiddleware, deleteExpeTrack);
export default router;

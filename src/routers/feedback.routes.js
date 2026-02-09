import express from 'express';
import {
  getAllFeedBackTracks,
  getFeedBackTrackById,
  createFeedBackTrack,
  updateFeedBackTrack,
  deleteFeedBackTrack,
} from '../controllers/feedback.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import upload from '../../middlewares/upload.js';

const router = express.Router();
router.get('/', authMiddleware, getAllFeedBackTracks);
router.get('/:id', authMiddleware, getFeedBackTrackById);
router.post('/create', authMiddleware, upload.single('image'), createFeedBackTrack);
router.put('/update/:id', authMiddleware, upload.single('image'), updateFeedBackTrack);
router.delete('/delete/:id', authMiddleware, deleteFeedBackTrack);
export default router;

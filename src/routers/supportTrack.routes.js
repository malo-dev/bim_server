import express from 'express';
import {
  getAllSupportTracks,
  getSupportTrackById,
  createSupportTrack,
  updateSupportTrack,
  deleteSupportTrack,
} from '../controllers/supportTrack.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import upload from '../../middlewares/upload.js';
const router = express.Router();
router.get('/', authMiddleware, getAllSupportTracks);
router.get('/:id', authMiddleware, getSupportTrackById);
router.post('/create', authMiddleware,upload.single('image') ,createSupportTrack);
router.put('/update/:id', authMiddleware,upload.single('image'), updateSupportTrack);
router.delete('/delete/:id', authMiddleware, deleteSupportTrack);
export default router;

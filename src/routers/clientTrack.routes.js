import express from 'express';
import {
  getAllClientTracks,
  getClientTrackById,
  createClientTrack,
  updateClientTrack,
  deleteClientTrack,
} from '../controllers/clientTrack.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import upload from '../../middlewares/upload.js';

const router = express.Router();
router.get('/', authMiddleware, getAllClientTracks);
router.get('/:id', authMiddleware, getClientTrackById);
router.post('/create', authMiddleware, upload.single('image'),createClientTrack);
router.put('/update/:id', authMiddleware,upload.single('image'), updateClientTrack);
router.delete('/delete/:id', authMiddleware, deleteClientTrack);
export default router;

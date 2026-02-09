import express from 'express';
import {
  getAllBranchTracks,
  getBranchTrackById,
  createBranchTrack,
  updateBranchTrack,
  deleteBranchTrack,
} from '../controllers/branchTrack.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import upload from '../../middlewares/upload.js';
const router = express.Router();
router.get('/', authMiddleware, getAllBranchTracks);
router.get('/:id', authMiddleware, getBranchTrackById);
router.post('/create', authMiddleware,upload.single('image'), createBranchTrack);
router.put('/update/:id',upload.single('image'), authMiddleware, updateBranchTrack);
router.delete('/delete/:id', authMiddleware, deleteBranchTrack);
export default router;

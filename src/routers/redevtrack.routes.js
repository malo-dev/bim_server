import express from 'express';
import {
  getAllRedevtracks,
  getRedevtrackById,
 createRedevtrack,
  updateRedevtrack,
  deleteRedevtrack,
} from '../controllers/redevtrack.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();
router.get('/', authMiddleware, getAllRedevtracks);
router.get('/:id', authMiddleware,  getRedevtrackById);
router.post('/create', authMiddleware, createRedevtrack);
router.put('/update/:id', authMiddleware, updateRedevtrack);
router.delete('/delete/:id', authMiddleware, deleteRedevtrack);
export default router;

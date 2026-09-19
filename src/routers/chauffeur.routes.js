import express from 'express';
import {
  registerChauffeur,
  getMyChauffeur,
  getAllChauffeurs,
  getChauffeurById,
  adminCreateChauffeur,
  updateChauffeur,
  deleteChauffeur,
  toggleOnline,
  updateLocation,
} from '../controllers/chauffeur.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import upload from '../../middlewares/upload.js';

const router = express.Router();

router.get('/', authMiddleware, getAllChauffeurs);
router.get('/me', authMiddleware, getMyChauffeur);
router.get('/:id', authMiddleware, getChauffeurById);
router.post('/register', authMiddleware, registerChauffeur);
router.post('/admin-create', authMiddleware, upload.single('image'), adminCreateChauffeur);
router.put('/update/:id', authMiddleware, upload.single('image'), updateChauffeur);
router.delete('/delete/:id', authMiddleware, deleteChauffeur);
router.put('/toggle-online', authMiddleware, toggleOnline);
router.put('/location', authMiddleware, updateLocation);

export default router;

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
  chauffeurAccessLogin,
} from '../controllers/chauffeur.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import upload from '../../middlewares/upload.js';
import requireBimAdmin from '../../middlewares/requireBimAdmin.middleware.js';

const router = express.Router();

// Public — connexion par code d'accès personnel (pas de compte requis au préalable)
router.post('/access', chauffeurAccessLogin);

router.get('/', authMiddleware, requireBimAdmin, getAllChauffeurs);
router.get('/me', authMiddleware, getMyChauffeur);
router.get('/:id', authMiddleware, requireBimAdmin, getChauffeurById);
router.post('/register', authMiddleware, registerChauffeur);
router.post('/admin-create', authMiddleware, requireBimAdmin, upload.single('image'), adminCreateChauffeur);
router.put('/update/:id', authMiddleware, requireBimAdmin, upload.single('image'), updateChauffeur);
router.delete('/delete/:id', authMiddleware, requireBimAdmin, deleteChauffeur);
router.put('/toggle-online', authMiddleware, toggleOnline);
router.put('/location', authMiddleware, updateLocation);

export default router;

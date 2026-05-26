import { Router } from 'express';
import multer from 'multer';
import path from 'path';
import {
  applyAsLivreur,
  loginLivreur,
  getMyLivreurProfile,
  updateLivreurLocation,
  toggleLivreurOnline,
  getCompanyLivreurs,
  updateLivreurStatus,
  rateLivreur,
  getLivreurPublicProfile,
  getAvailableOrders,
  acceptOrder,
  cancelDelivery,
  getMyDeliveries,
  getMyEarnings,
  sendSOS,
  resolveSOS,
  getSOSAlerts,
} from '../controllers/livreur.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

// Multer dédié livreur — 300KB par image
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'public/images'),
  filename: (req, file, cb) => {
    const unique = `livreur-${Date.now()}-${Math.round(Math.random() * 1e9)}`;
    cb(null, unique + path.extname(file.originalname));
  },
});
const uploadId = multer({
  storage,
  limits: { fileSize: 300 * 1024 },
  fileFilter: (req, file, cb) => {
    const ok = /jpeg|jpg|png/.test(path.extname(file.originalname).toLowerCase());
    cb(ok ? null : new Error('Image JPEG/PNG uniquement'), ok);
  },
}).fields([
  { name: 'idCardRecto', maxCount: 1 },
  { name: 'idCardVerso', maxCount: 1 },
]);

const router = Router();

// Public
router.post('/login', loginLivreur);

// Candidature (user authentifié)
router.post('/apply', authMiddleware, uploadId, applyAsLivreur);

// Profil livreur du user connecté
router.get('/me', authMiddleware, getMyLivreurProfile);

// Mode livreur
router.put('/location', authMiddleware, updateLivreurLocation);
router.put('/toggle-online', authMiddleware, toggleLivreurOnline);

// Profil public d'un livreur (par userId)
router.get('/public/:userId', authMiddleware, getLivreurPublicProfile);

// Admin entreprise
router.get('/company/candidates', authMiddleware, getCompanyLivreurs);
router.put('/:id/status', authMiddleware, updateLivreurStatus);

// Notation (user)
router.post('/:id/rate', authMiddleware, rateLivreur);

// Gestion des livraisons (livreur)
router.get('/orders/available', authMiddleware, getAvailableOrders);
router.get('/orders/mine',      authMiddleware, getMyDeliveries);
router.put('/orders/accept/:orderNumber',  authMiddleware, acceptOrder);
router.put('/orders/cancel/:orderNumber',  authMiddleware, cancelDelivery);

// Revenus / commissions
router.get('/earnings', authMiddleware, getMyEarnings);

// Alertes SOS
router.post('/sos',               authMiddleware, sendSOS);
router.get('/sos/alerts',         authMiddleware, getSOSAlerts);
router.put('/sos/:sosId/resolve', authMiddleware, resolveSOS);

export default router;

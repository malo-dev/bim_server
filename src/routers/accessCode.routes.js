import express from 'express';
import {
  getAllAccessCodes,
  updateAccessCode,
  verifyAccessCode,
} from '../controllers/accessCode.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import requireBimAdmin from '../../middlewares/requireBimAdmin.middleware.js';

const router = express.Router();

// App mobile : n'importe quel compte connecté peut tenter un code.
router.post('/verify', authMiddleware, verifyAccessCode);

// admin-bim : réservé aux administrateurs BIM.
router.get('/', authMiddleware, requireBimAdmin, getAllAccessCodes);
router.put('/:role', authMiddleware, requireBimAdmin, updateAccessCode);

export default router;

import { Router } from 'express';
import {
  login,
  register,
  askPasswordReset,
  resetPassword,
  getAllUsers,
  desactivateUser,
  updateUser,
  getUserById,
  updateUserPassword,
  deleteUser,
  deleteAccount,
  refreshToken,
  createUsers,
  blockUser,
  logOut,
  verifyOtp,
  storeExpoPushToken,
  createAgent,
  veryfUserPass,
  updateSoldNumber,
  createBimAdmin,
  createCompanyAccount,
  bootstrapAdmin,
  getDashboardStats,
  resetBimAdminPassword,
  requestBimReset,
  getAdminAccounts,
  createCommerceAccount,
} from '../controllers/auth.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import upload from '../../middlewares/upload.js';
const router = Router();
router.post('/reset-password', resetPassword);
router.post('/register', register);
router.post('/create',authMiddleware, createUsers);
router.post('/agent',createAgent);
router.post('/login', login);
router.post('/logOut', logOut);
router.post('/ask-password-reset', askPasswordReset);
router.post('/resetPwd', resetPassword);
router.get('/users', authMiddleware, getAllUsers);
router.get('/users/:id', authMiddleware, getUserById);
router.put('/users/:id/activate', authMiddleware, desactivateUser);
router.put('/users/:id/block-user', authMiddleware, blockUser);
router.put('/users/:id/profile', authMiddleware, upload.single('image'), updateUser);
router.put('/users/:id/password', authMiddleware, updateUserPassword);
router.delete('/users/:id', authMiddleware, deleteUser);
router.post('/refresh-token', refreshToken);
router.post('/verify-otp', verifyOtp);
router.post('/users/:userId/expoPushToken', storeExpoPushToken);
router.post('/verifyPwd', veryfUserPass);
router.delete('/account', authMiddleware, deleteAccount);
router.put('/users/:id/sold', authMiddleware, updateSoldNumber);

// Création des comptes admin (BIM ou Entreprise)
router.post('/create-bim-admin', authMiddleware, createBimAdmin);
router.post('/create-company-account', authMiddleware, createCompanyAccount);

// Bootstrap : premier admin (public — bloqué si un admin BIM existe déjà)
router.post('/bootstrap', bootstrapAdmin);

// Etape 1 : envoie l'OTP par email
router.post('/request-bim-reset', requestBimReset);
// Etape 2 : verifie OTP + nouveau mot de passe
router.post('/reset-bim-password', resetBimAdminPassword);

// Dashboard stats
router.get('/dashboard-stats', authMiddleware, getDashboardStats);

// Liste des comptes admin (BIM + COMPANY_ADMIN)
router.get('/admin-accounts', authMiddleware, getAdminAccounts);

// Commerce + gestionnaire
router.post('/create-commerce-account', authMiddleware, createCommerceAccount);

export default router;

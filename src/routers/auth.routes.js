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
  addCompanyAdmin,
  getMyCompanyAdmins,
  updateMyCompanyAdmin,
  deleteMyCompanyAdmin,
  getOtps,
  getUsersBalanceStats,
  getTransactionPassword,
  adminRechargeUser,
  adminResetUserPassword,
  sendUserSOS,
  resolveUserSOS,
  getUserSOSAlerts,
  resetAllBalances,
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
// Routes spécifiques avant /:id pour éviter les conflits de pattern
router.get('/users/balance-stats', authMiddleware, getUsersBalanceStats);
router.get('/users/:id', authMiddleware, getUserById);
router.put('/users/:id/activate', authMiddleware, desactivateUser);
router.put('/users/:id/block-user', authMiddleware, blockUser);
router.put('/users/:id/profile', authMiddleware, upload.single('image'), updateUser);
router.put('/users/:id/password', authMiddleware, updateUserPassword);
router.delete('/users/:id', authMiddleware, deleteUser);
router.get('/users/:id/transaction-password', authMiddleware, getTransactionPassword);
router.post('/users/:id/admin-recharge', authMiddleware, adminRechargeUser);
router.post('/users/:id/admin-reset-password', authMiddleware, adminResetUserPassword);
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

// OTPs des utilisateurs
router.get('/otps', authMiddleware, getOtps);

// Liste des comptes admin (BIM + COMPANY_ADMIN)
router.get('/admin-accounts', authMiddleware, getAdminAccounts);

// Ajout d'un admin à une entreprise existante
router.post('/add-company-admin', authMiddleware, addCompanyAdmin);

// Commerce + gestionnaire
router.post('/create-commerce-account', authMiddleware, createCommerceAccount);

// Portail entreprise : gestion des comptes admins de la company
router.get('/my-company-admins', authMiddleware, getMyCompanyAdmins);
router.put('/my-company-admins/:id', authMiddleware, updateMyCompanyAdmin);
router.delete('/my-company-admins/:id', authMiddleware, deleteMyCompanyAdmin);

// SOS utilisateur
router.post('/sos', authMiddleware, sendUserSOS);
router.get('/sos/alerts', authMiddleware, getUserSOSAlerts);
router.put('/sos/:sosId/resolve', authMiddleware, resolveUserSOS);

// ⚠️  Zone dangereuse — action irréversible (super admin BIM uniquement)
router.post('/admin/reset-all-balances', authMiddleware, resetAllBalances);

export default router;

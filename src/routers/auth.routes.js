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
  refreshToken,
  createUsers,
  blockUser,
  logOut,
  verifyOtp,
  storeExpoPushToken,
  createAgent,
  veryfUserPass
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

export default router;

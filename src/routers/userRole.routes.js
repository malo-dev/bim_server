import express from 'express';
import {
  getAllUserRoles,
  getUserRoleById,
  createUserRoles,
  updateUserRole,
  deleteUserRole,
} from '../controllers/userRole.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();
router.get('/', authMiddleware, getAllUserRoles);
router.get('/:id', authMiddleware, getUserRoleById);
router.post('/create', authMiddleware, createUserRoles);
router.put('/update/:id', authMiddleware, updateUserRole);
router.delete('/delete/:id', authMiddleware, deleteUserRole);
export default router;

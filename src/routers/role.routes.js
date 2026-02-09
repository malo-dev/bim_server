import { Router } from 'express';
import {
  createRole,
  deleteRole,
  getAllRoles,
  getRoleById,
  updateRole,
} from '../controllers/role.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
const router = Router();

router.get('/', authMiddleware, getAllRoles);
router.get('/:id', authMiddleware, getRoleById);
router.post('/create', authMiddleware, createRole);
router.put('/:id', authMiddleware, updateRole);
router.delete('/:id', authMiddleware, deleteRole);
export default router;

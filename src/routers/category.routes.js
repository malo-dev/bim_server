import express from 'express';
import {
  getAllCategorys,
  getCategoryById,
  createCategory,
  updateCategory,
  deleteCategory,
} from '../controllers/category.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();
router.get('/', authMiddleware, getAllCategorys);
router.get('/:id', authMiddleware, getCategoryById);
router.post('/create', authMiddleware, createCategory);
router.put('/update/:id', authMiddleware, updateCategory);
router.delete('/delete/:id', authMiddleware, deleteCategory);
export default router;

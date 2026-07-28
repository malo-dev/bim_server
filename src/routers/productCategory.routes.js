import express from 'express';
import {
  getAllProductCategorys,
  getProductCategoryById,
  createproductCategorys,
  updateProductCategory,
  deleteproductCategory,
  unlinkProductCategory,
  getProductsByCategoryId,
} from '../controllers/productCategory.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();
router.get('/', authMiddleware, getAllProductCategorys);
router.get('/by-category/:id', authMiddleware, getProductsByCategoryId);
router.get('/:id', authMiddleware, getProductCategoryById);
router.post('/create', authMiddleware, createproductCategorys);
router.post('/unlink', authMiddleware, unlinkProductCategory);
router.put('/update/:id', authMiddleware, updateProductCategory);
router.delete('/delete/:id', authMiddleware, deleteproductCategory);
export default router;

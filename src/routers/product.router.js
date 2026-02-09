import express from 'express';
import {
  getAllProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
} from '../controllers/product.controller.js';
import upload from '../../middlewares/upload.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
const router = express.Router();
router.get('/', authMiddleware, getAllProducts);
router.get('/:id', authMiddleware, getProductById);
router.post('/create', authMiddleware, upload.single('image'), createProduct);
router.put('/update/:id', authMiddleware, upload.single('image'), updateProduct);
router.delete('/delete/:id', authMiddleware, deleteProduct);
export default router;

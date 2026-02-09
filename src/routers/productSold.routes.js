import express from 'express';
import {
  getAllProductSolds,
  getProductSoldById,
  createProductSolds,
  updateProductSold,
  deleteProductSold,
} from '../controllers/productSold.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();
router.get('/', authMiddleware, getAllProductSolds);
router.get('/:id', authMiddleware, getProductSoldById);
router.post('/create', authMiddleware, createProductSolds);
router.put('/update/:id', authMiddleware, updateProductSold);
router.delete('/delete/:id', authMiddleware, deleteProductSold);
export default router;

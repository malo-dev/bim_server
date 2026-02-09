import express from 'express';
import {
  getAllCommerces,
  getCommerceById,
  createCommerce,
  updateCommerce,
  deleteCommerce,
} from '../controllers/commerce.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import upload from '../../middlewares/upload.js';
const router = express.Router();
router.get('/', authMiddleware, getAllCommerces);
router.get('/:id', authMiddleware, getCommerceById);
router.post('/create', authMiddleware, upload.single('image'),createCommerce);
router.put('/update/:id', authMiddleware, upload.single('image'),updateCommerce);
router.delete('/delete/:id', authMiddleware, deleteCommerce);
export default router;

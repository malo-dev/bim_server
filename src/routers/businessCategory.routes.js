import express from 'express';
import {
  getAllBusinessCategories,
  getBusinessCategoryById,
  createBusinessCategory,
  updateBusinessCategory,
  deleteBusinessCategory,
} from '../controllers/businessCategoy.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import upload from '../../middlewares/upload.js';
const router = express.Router();
router.get('/', authMiddleware, getAllBusinessCategories);
router.get('/:id', authMiddleware,  getBusinessCategoryById);
router.post('/create', authMiddleware, createBusinessCategory);
router.put('/update/:id',upload.single('image'), authMiddleware, updateBusinessCategory);
router.delete('/delete/:id', authMiddleware, deleteBusinessCategory);
export default router;

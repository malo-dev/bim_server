import express from 'express';
import {
  getAllBanners,
  getBannerById,
  createBanner,
  updateBanner,
  deleteBanner,
} from '../controllers/banner.controller.js';
import upload from '../../middlewares/upload.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();

router.get('/', authMiddleware, getAllBanners);
router.get('/:id', authMiddleware, getBannerById);
router.post('/create', authMiddleware, upload.single('image'), createBanner);
router.put('/update/:id', authMiddleware, upload.single('image'), updateBanner);
router.delete('/delete/:id', authMiddleware, deleteBanner);

export default router;

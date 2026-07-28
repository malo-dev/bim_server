import { Router } from 'express';
import { getUserFavorites, toggleFavorite, getFavoriteIds } from '../controllers/favorite.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = Router();

router.get('/',        authMiddleware, getUserFavorites);
router.get('/ids',     authMiddleware, getFavoriteIds);
router.post('/toggle', authMiddleware, toggleFavorite);

export default router;

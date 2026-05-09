import { Router } from 'express';
import { getOrders, getOrderById, updateOrder, deleteOrder, getCompanyOrders, getMyCompanyStats } from '../controllers/order.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = Router();

router.get('/my-stats', authMiddleware, getMyCompanyStats);
router.get('/my-orders', authMiddleware, getCompanyOrders);
router.get('/', authMiddleware, getOrders);
router.get('/:id', authMiddleware, getOrderById);
router.put('/:id', authMiddleware, updateOrder);
router.delete('/:id', authMiddleware, deleteOrder);

export default router;

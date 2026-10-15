import { Router } from 'express';
import { getOrders, getOrderById, updateOrder, deleteOrder, getCompanyOrders, getMyCompanyStats, createOrder, getUserOrders, markOrderPaidOnDelivery, payOrderAtDelivery } from '../controllers/order.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import requireBimAdmin from '../../middlewares/requireBimAdmin.middleware.js';

const router = Router();

router.post('/create', authMiddleware, createOrder);
router.post('/pay/:orderNumber', authMiddleware, payOrderAtDelivery);
router.put('/pay-delivery/:orderNumber', authMiddleware, markOrderPaidOnDelivery);
router.get('/my-stats', authMiddleware, getMyCompanyStats);
router.get('/my-orders', authMiddleware, getCompanyOrders);
router.get('/mine', authMiddleware, getUserOrders);
// Listing global / suppression : réservés aux administrateurs BIM (ni le
// portail entreprise ni l'app mobile grand public ne les utilisent).
router.get('/', authMiddleware, requireBimAdmin, getOrders);
router.get('/:id', authMiddleware, getOrderById);
router.put('/:id', authMiddleware, updateOrder);
router.delete('/:id', authMiddleware, requireBimAdmin, deleteOrder);

export default router;

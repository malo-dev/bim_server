import express from 'express';
import {
  getAllNotifications,
  getNotificationById ,
 createNotification,
  updateNotification,
 deleteNotification ,
  markAsRead,
  markAllAsRead,
} from '../controllers/notification.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();
router.get('/', authMiddleware, getAllNotifications);
router.put('/mark_all_read', authMiddleware, markAllAsRead);
router.get('/:id', authMiddleware, getNotificationById );
router.post('/create', authMiddleware,createNotification);
router.put('/update/:id', authMiddleware, updateNotification);
router.delete('/delete/:id', authMiddleware,deleteNotification );
router.put('/mark_read/:id', authMiddleware, markAsRead);
export default router;

import express from 'express';
import {
  getAllHistorys,
  getHistoryById,
  createHistory,
  updateHistory,
  deleteHistory,
} from '../controllers/history.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();
router.get('/', authMiddleware, getAllHistorys);
router.get('/:id', authMiddleware, getHistoryById);
router.post('/create', authMiddleware, createHistory);
router.put('/update/:id', authMiddleware, updateHistory);
router.delete('/delete/:id', authMiddleware, deleteHistory);
export default router;

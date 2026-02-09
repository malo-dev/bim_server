import express from 'express';
import {
  getAllCurrencys,
  getCurrencyById,
  createCurrency,
  updateCurrency,
  deleteCurrency,
} from '../controllers/currency.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();
router.get('/', authMiddleware, getAllCurrencys);
router.get('/:id', authMiddleware, getCurrencyById);
router.post('/create', authMiddleware, createCurrency);
router.put('/update/:id', authMiddleware, updateCurrency);
router.delete('/delete/:id', authMiddleware, deleteCurrency);
export default router;

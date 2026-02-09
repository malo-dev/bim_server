import express from 'express';
import {
  getAllTransactions,
  getTransactionById,
  createTransaction,
  updateTransaction,
  deleteTransaction,
  createPaiement,
  checkRechargeStatus,
  createRecharge,
  createTransfert,
  recharge,
  createRetrait
} from '../controllers/transaction.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();


router.get('/', authMiddleware, getAllTransactions);
router.get('/:id', authMiddleware, getTransactionById);
router.post('/create', authMiddleware, createTransaction);
router.put('/update/:id', authMiddleware, updateTransaction);
router.delete('/delete/:id', authMiddleware, deleteTransaction);
router.post('/transfert', authMiddleware, createTransfert);
router.post('/paiement', authMiddleware, createPaiement);
router.post('/createrecharge', authMiddleware, createRecharge);
router.post('/recharge', authMiddleware, recharge );
router.post('/retrait', authMiddleware,  createRetrait );
router.get('/recharge/status', authMiddleware, checkRechargeStatus);
export default router;

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
  createRetrait,
  getTransactionsPaiement,
  getTransactionPaiementById,
  updateTransactionPaiement,
  deleteTransactionPaiement,
  getRechargesList,
  getRetraitsList,
  getPaiementsList,
  approveRecharge,
  rejectRecharge,
  reverseRecharge,
} from '../controllers/transaction.controller.js';

import { recharge, flexpayCallback, flexpayApproved, flexpayCancel, flexpayDecline, verifyPayment } from '../controllers/recharge.controller.js'
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
router.post('/recharge/callback', flexpayCallback);
router.get('/recharge/approved/:reference', flexpayApproved);
router.get('/recharge/cancel/:reference', flexpayCancel);
router.get('/recharge/decline/:reference', flexpayDecline);
router.post('/retrait', authMiddleware,  createRetrait );
router.get('/recharge/status', authMiddleware, checkRechargeStatus);
router.post('/recharge/verify', authMiddleware, verifyPayment);
router.get("/transactions", getTransactionsPaiement);
router.get("/transactions/:id", getTransactionPaiementById);
router.put("/transactions/:id", updateTransactionPaiement);
router.delete("/transactions/:id", deleteTransactionPaiement);

// Admin lists (paginated, with period & company filters)
router.get("/admin/recharges", authMiddleware, getRechargesList);
router.get("/admin/retraits", authMiddleware, getRetraitsList);
router.get("/admin/paiements", authMiddleware, getPaiementsList);

// Admin approve/reject/reverse recharge
router.patch("/admin/recharges/:id/approve", authMiddleware, approveRecharge);
router.patch("/admin/recharges/:id/reject",  authMiddleware, rejectRecharge);
router.patch("/admin/recharges/:id/reverse", authMiddleware, reverseRecharge);

export default router;

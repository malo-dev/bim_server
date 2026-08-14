import express from 'express';
import authMiddleware from '../../middlewares/auth.middleware.js';
import {
  adminListAgents,
  adminCreateAgent,
  adminToggleAgent,
  agentGetMyRetraits,
  agentGetStats,
} from '../controllers/agent.controller.js';

const router = express.Router();

// ── Admin endpoints (use bim_admin_token or regular auth) ─────────────────────
router.get('/admin/list',          authMiddleware, adminListAgents);
router.post('/admin/create',       authMiddleware, adminCreateAgent);
router.put('/admin/:id/toggle',    authMiddleware, adminToggleAgent);

// ── Agent mobile endpoints ─────────────────────────────────────────────────────
router.get('/my-retraits',         authMiddleware, agentGetMyRetraits);
router.get('/stats',               authMiddleware, agentGetStats);

export default router;

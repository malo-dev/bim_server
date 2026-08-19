import express from 'express';
import { getAppVersion, getAllAppVersions, upsertAppVersion } from '../controllers/appVersion.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';

const router = express.Router();

router.get('/', authMiddleware, getAllAppVersions);
router.get('/check', authMiddleware, getAppVersion);
router.post('/upsert', authMiddleware, upsertAppVersion);

export default router;

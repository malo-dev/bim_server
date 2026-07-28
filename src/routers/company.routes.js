import express from 'express';
import {
  getAllCompanies,
  getCompanyById ,
  createCompany,
  updateCompany,
  deleteCompany,
} from '../controllers/company.controller.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import upload from '../../middlewares/upload.js';
const router = express.Router();
router.get('/', authMiddleware, getAllCompanies);
router.get('/:id', authMiddleware,  getCompanyById );
router.post('/create', authMiddleware, upload.fields([{ name: 'logo' }, { name: 'image' }]), createCompany);
router.put('/update/:id', authMiddleware, upload.fields([{ name: 'logo' }, { name: 'image' }]), updateCompany);
router.delete('/delete/:id', authMiddleware, deleteCompany);
export default router;

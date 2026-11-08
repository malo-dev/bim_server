import express from 'express';
import {
  getAllProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
  addProductImages,
  removeProductImage,
  getBimCatalogue,
} from '../controllers/product.controller.js';
import upload from '../../middlewares/upload.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
const router = express.Router();
router.get('/', authMiddleware, getAllProducts);
// Catalogue BIM NEXT (eau / gaz / carburant) — doit rester AVANT '/:id'.
router.get('/bim-catalogue', authMiddleware, getBimCatalogue);
router.get('/:id', authMiddleware, getProductById);
router.post('/create', authMiddleware, upload.single('image'), createProduct);
router.put('/update/:id', authMiddleware, upload.single('image'), updateProduct);
router.delete('/delete/:id', authMiddleware, deleteProduct);
router.post('/:id/images', authMiddleware, upload.array('images', 6), addProductImages);
router.delete('/:id/images', authMiddleware, removeProductImage);
export default router;

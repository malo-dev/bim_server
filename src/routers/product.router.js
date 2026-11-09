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
  getBimAdminProducts,
  createBimProduct,
  updateBimProduct,
} from '../controllers/product.controller.js';
import upload from '../../middlewares/upload.js';
import authMiddleware from '../../middlewares/auth.middleware.js';
import requireBimAdmin from '../../middlewares/requireBimAdmin.middleware.js';
const router = express.Router();

// Envoi d'image : une erreur multer (format refusé…) renvoie un 400 lisible
// au lieu d'une page d'erreur HTML.
const singleImage = (req, res, next) =>
  upload.single('image')(req, res, (err) => {
    if (err) return res.status(400).json({ message: "Image refusée : formats acceptés JPG, PNG ou GIF." });
    next();
  });

router.get('/', authMiddleware, getAllProducts);
// Catalogue BIM NEXT (eau / gaz / carburant) — doit rester AVANT '/:id'.
router.get('/bim-catalogue', authMiddleware, getBimCatalogue);
// Administration du catalogue BIM NEXT (admin-bim) — AVANT '/:id'.
router.get('/bim-admin', authMiddleware, requireBimAdmin, getBimAdminProducts);
router.post('/bim-admin', authMiddleware, requireBimAdmin, singleImage, createBimProduct);
router.put('/bim-admin/:id', authMiddleware, requireBimAdmin, singleImage, updateBimProduct);
router.get('/:id', authMiddleware, getProductById);
// Création / modification / suppression : administrateurs BIM uniquement
// (avant, n'importe quel compte connecté pouvait modifier les prix).
router.post('/create', authMiddleware, requireBimAdmin, upload.single('image'), createProduct);
router.put('/update/:id', authMiddleware, requireBimAdmin, upload.single('image'), updateProduct);
router.delete('/delete/:id', authMiddleware, requireBimAdmin, deleteProduct);
router.post('/:id/images', authMiddleware, requireBimAdmin, upload.array('images', 6), addProductImages);
router.delete('/:id/images', authMiddleware, requireBimAdmin, removeProductImage);
export default router;

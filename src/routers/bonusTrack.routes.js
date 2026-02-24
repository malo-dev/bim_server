import express from "express";
import {
  getAllBonus,
  getBonusById,
  createBonus,
  updateBonus,
  deleteBonus,
  getBonusWithUserAndCompany,
} from "../controllers/bonus.controller.js";
import authMiddleware from '../../middlewares/auth.middleware.js';
const router = express.Router();

router.get("/",authMiddleware, getAllBonus);
router.get("/with-user-company",authMiddleware, getBonusWithUserAndCompany);
router.get("/:id", authMiddleware,getBonusById);
router.post("/create", authMiddleware,createBonus);
router.put("/update/:id",authMiddleware, updateBonus);
router.delete("/delete/:id", authMiddleware,deleteBonus);

export default router;

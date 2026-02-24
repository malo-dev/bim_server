import express from "express";
import {
  getAllNotes ,
  getNoteById,
  getNotesByCompany,
  getNotesByProduct,
  createNote,
    updateNote,
  deleteNote
} from "../controllers/notes.company.controller.js";
import authMiddleware from '../../middlewares/auth.middleware.js';
const router = express.Router();

router.get("/", authMiddleware,getAllNotes);
router.get("/:id",authMiddleware, getNoteById);
router.get("/company/:id",authMiddleware, getNotesByCompany);
router.post("/product/:id",authMiddleware, getNotesByProduct);
router.post("/create",authMiddleware, createNote);
router.put("/update/:id",authMiddleware, updateNote);
router.delete("/delete/:id",authMiddleware, deleteNote);

export default router;

import express from "express";
import {
  adminListTutorials,
  adminCreateTutorial,
  adminUpdateTutorial,
  adminDeleteTutorial,
  publicListTutorials,
} from "../controllers/tutorial.controller.js";
import authMiddleware from "../../middlewares/auth.middleware.js";

const router = express.Router();

/* ── Public ─────────────────────────────────── */
router.get("/list",             authMiddleware, publicListTutorials);

/* ── Admin ───────────────────────────────────── */
router.get("/admin/list",       authMiddleware, adminListTutorials);
router.post("/admin/create",    authMiddleware, adminCreateTutorial);
router.put("/admin/:id",        authMiddleware, adminUpdateTutorial);
router.delete("/admin/:id",     authMiddleware, adminDeleteTutorial);

export default router;

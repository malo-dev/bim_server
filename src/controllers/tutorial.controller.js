import Tutorial from "../models/tutorial.model.js";
import { Op } from "sequelize";

/* ─── Helpers ────────────────────────────────────────────── */

/**
 * Extract YouTube video ID from various URL formats:
 *  https://www.youtube.com/watch?v=VIDEO_ID
 *  https://youtu.be/VIDEO_ID
 *  https://www.youtube.com/embed/VIDEO_ID
 */
function extractYouTubeId(url = "") {
  const patterns = [
    /[?&]v=([^&#]+)/,
    /youtu\.be\/([^?&#]+)/,
    /\/embed\/([^?&#]+)/,
  ];
  for (const re of patterns) {
    const m = url.match(re);
    if (m) return m[1];
  }
  return null;
}

function buildThumbnail(youtubeUrl, provided) {
  if (provided) return provided;
  const id = extractYouTubeId(youtubeUrl);
  return id ? `https://img.youtube.com/vi/${id}/hqdefault.jpg` : null;
}

/* ─── Admin CRUD ─────────────────────────────────────────── */

/** GET /api/v1/tutorial/admin/list */
export const adminListTutorials = async (req, res) => {
  try {
    const tutorials = await Tutorial.findAll({
      order: [["order", "ASC"], ["createdAt", "DESC"]],
    });
    return res.json({ tutorials });
  } catch (err) {
    console.error("[adminListTutorials]", err);
    return res.status(500).json({ message: "Erreur serveur." });
  }
};

/** POST /api/v1/tutorial/admin/create */
export const adminCreateTutorial = async (req, res) => {
  try {
    const { title, description, youtubeUrl, thumbnailUrl, order } = req.body;
    if (!title || !youtubeUrl) {
      return res.status(400).json({ message: "Titre et URL YouTube requis." });
    }
    const thumbnail = buildThumbnail(youtubeUrl, thumbnailUrl);
    const tutorial = await Tutorial.create({
      title: title.trim(),
      description: description?.trim() || null,
      youtubeUrl:  youtubeUrl.trim(),
      thumbnailUrl: thumbnail,
      order:    order ?? 0,
      isActive: true,
    });
    return res.status(201).json({ message: "Tutoriel créé.", tutorial });
  } catch (err) {
    console.error("[adminCreateTutorial]", err);
    return res.status(500).json({ message: "Erreur serveur." });
  }
};

/** PUT /api/v1/tutorial/admin/:id */
export const adminUpdateTutorial = async (req, res) => {
  try {
    const { id } = req.params;
    const tutorial = await Tutorial.findByPk(id);
    if (!tutorial) return res.status(404).json({ message: "Tutoriel introuvable." });

    const { title, description, youtubeUrl, thumbnailUrl, order, isActive } = req.body;
    const newUrl  = youtubeUrl?.trim()     ?? tutorial.youtubeUrl;
    const thumbnail = buildThumbnail(newUrl, thumbnailUrl ?? tutorial.thumbnailUrl);

    await tutorial.update({
      title:        title?.trim()       ?? tutorial.title,
      description:  description?.trim() ?? tutorial.description,
      youtubeUrl:   newUrl,
      thumbnailUrl: thumbnail,
      order:        order              ?? tutorial.order,
      isActive:     isActive           ?? tutorial.isActive,
    });
    return res.json({ message: "Tutoriel mis à jour.", tutorial });
  } catch (err) {
    console.error("[adminUpdateTutorial]", err);
    return res.status(500).json({ message: "Erreur serveur." });
  }
};

/** DELETE /api/v1/tutorial/admin/:id */
export const adminDeleteTutorial = async (req, res) => {
  try {
    const { id } = req.params;
    const tutorial = await Tutorial.findByPk(id);
    if (!tutorial) return res.status(404).json({ message: "Tutoriel introuvable." });
    await tutorial.destroy();
    return res.json({ message: "Tutoriel supprimé." });
  } catch (err) {
    console.error("[adminDeleteTutorial]", err);
    return res.status(500).json({ message: "Erreur serveur." });
  }
};

/* ─── Public (mobile) ────────────────────────────────────── */

/** GET /api/v1/tutorial/list  — tous les tutoriels actifs */
export const publicListTutorials = async (req, res) => {
  try {
    const tutorials = await Tutorial.findAll({
      where:  { isActive: true },
      order:  [["order", "ASC"], ["createdAt", "DESC"]],
      attributes: ["id", "title", "description", "youtubeUrl", "thumbnailUrl"],
    });
    return res.json({ tutorials });
  } catch (err) {
    console.error("[publicListTutorials]", err);
    return res.status(500).json({ message: "Erreur serveur." });
  }
};

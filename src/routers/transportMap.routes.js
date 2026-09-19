import express from 'express';
import { renderTransportMap } from '../controllers/transportMap.controller.js';

const router = express.Router();

// Page publique (chargée dans une WebView, pas d'auth) — aucune donnée
// sensible n'y transite : uniquement des coordonnées GPS de la course en cours.
router.get('/map', renderTransportMap);

export default router;

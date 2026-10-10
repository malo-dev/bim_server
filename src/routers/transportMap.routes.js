import express from 'express';
import { renderTransportMap, geocodeAddress } from '../controllers/transportMap.controller.js';

const router = express.Router();

// Page publique (chargée dans une WebView, pas d'auth) — aucune donnée
// sensible n'y transite : uniquement des coordonnées GPS de la course en cours.
router.get('/map', renderTransportMap);
router.get('/geocode', geocodeAddress);

export default router;

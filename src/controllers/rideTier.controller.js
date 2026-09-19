import { RideTier } from '../models/index.js';

// ── Liste des gammes (public — app mobile + admin) ──────────────────────────
export const getAllTiers = async (req, res) => {
  try {
    const { onlyActive } = req.query;
    const where = onlyActive === 'true' ? { active: true } : {};
    const tiers = await RideTier.findAll({ where, order: [['sortOrder', 'ASC']] });
    return res.status(200).json({ data: tiers });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Créer une gamme ──────────────────────────────────────────────────────────
export const createTier = async (req, res) => {
  try {
    const { tierKey, label, base, perKm, seats, etaMin, sortOrder } = req.body;
    if (!tierKey || !label || base === undefined || perKm === undefined) {
      return res.status(400).json({ message: 'tierKey, label, base et perKm sont obligatoires' });
    }
    const existing = await RideTier.findByPk(tierKey);
    if (existing) return res.status(400).json({ message: 'Cette gamme existe déjà' });

    const tier = await RideTier.create({
      tierKey, label, base, perKm,
      seats: seats || 4, etaMin: etaMin || 3, sortOrder: sortOrder || 0,
    });
    return res.status(201).json({ message: 'Gamme créée', data: tier });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Mettre à jour une gamme (tarifs, libellé, activation...) ────────────────
export const updateTier = async (req, res) => {
  try {
    const tier = await RideTier.findByPk(req.params.tierKey);
    if (!tier) return res.status(404).json({ message: 'Gamme introuvable' });
    await tier.update(req.body);
    return res.status(200).json({ message: 'Gamme mise à jour', data: tier });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Supprimer une gamme ──────────────────────────────────────────────────────
export const deleteTier = async (req, res) => {
  try {
    const tier = await RideTier.findByPk(req.params.tierKey);
    if (!tier) return res.status(404).json({ message: 'Gamme introuvable' });
    await tier.destroy();
    return res.status(200).json({ message: 'Gamme supprimée' });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

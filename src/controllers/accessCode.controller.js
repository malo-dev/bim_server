import { AccessCode } from '../models/index.js';

// ── Liste des codes (admin-bim uniquement) ──────────────────────────────────
export const getAllAccessCodes = async (req, res) => {
  try {
    const codes = await AccessCode.findAll({ order: [['role', 'ASC']] });
    return res.status(200).json({ data: codes });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Modifier le code d'un rôle (admin-bim uniquement) ───────────────────────
export const updateAccessCode = async (req, res) => {
  try {
    const { role } = req.params;
    const { code } = req.body;
    if (!code || !String(code).trim()) {
      return res.status(400).json({ message: 'Le code est obligatoire' });
    }
    const [record] = await AccessCode.upsert(
      { role, code: String(code).trim() },
      { returning: true }
    );
    return res.status(200).json({ message: 'Code mis à jour', data: record });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// ── Vérification d'un code (app mobile — révèle les entrées staff) ──────────
export const verifyAccessCode = async (req, res) => {
  try {
    const { code } = req.body;
    const record = code
      ? await AccessCode.findOne({ where: { code: String(code).trim() } })
      : null;
    if (!record) {
      return res.status(404).json({ message: 'Code invalide' });
    }
    return res.status(200).json({ role: record.role });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

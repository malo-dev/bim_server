import bcrypt from 'bcryptjs';
import { Op } from 'sequelize';
import { User, TransactionRetrait } from '../models/index.js';
import { sendEmail } from '../utils/sendEmail.utils.js';

function generatePassword(length = 10) {
  const chars = 'ABCDEFGHJKMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789@#!';
  return Array.from({ length }, () => chars[Math.floor(Math.random() * chars.length)]).join('');
}

function getDateFrom(period) {
  const now = new Date();
  switch (period) {
    case 'today':  { const d = new Date(now); d.setHours(0,0,0,0); return d; }
    case 'week':   { const d = new Date(now); d.setDate(d.getDate() - 7); return d; }
    case 'month':  { const d = new Date(now); d.setDate(1); d.setHours(0,0,0,0); return d; }
    case 'year':   { const d = new Date(now); d.setMonth(0,1); d.setHours(0,0,0,0); return d; }
    default: return null;
  }
}

// ── Admin: list agents ─────────────────────────────────────────────────────────
export const adminListAgents = async (req, res) => {
  try {
    const { search, page = 1, pageSize = 20 } = req.query;
    const limit  = parseInt(pageSize);
    const offset = (parseInt(page) - 1) * limit;

    const where = { isAgent: true };
    if (search) {
      where[Op.or] = [
        { username:      { [Op.like]: `%${search}%` } },
        { email:         { [Op.like]: `%${search}%` } },
        { accountNumber: { [Op.like]: `%${search}%` } },
        { telephone:     { [Op.like]: `%${search}%` } },
      ];
    }

    const startOfDay = new Date(); startOfDay.setHours(0, 0, 0, 0);

    const { rows, count } = await User.findAndCountAll({
      where,
      attributes: ['id', 'username', 'email', 'telephone', 'soldNumber', 'accountNumber', 'isBlocked', 'isAgent', 'createdAt'],
      limit,
      offset,
      order: [['createdAt', 'DESC']],
    });

    const enriched = await Promise.all(rows.map(async (agent) => {
      const [todayCount, todaySum] = await Promise.all([
        TransactionRetrait.count({ where: { targetId: agent.id, createdAt: { [Op.gte]: startOfDay } } }),
        TransactionRetrait.sum('amount', { where: { targetId: agent.id, createdAt: { [Op.gte]: startOfDay } } }),
      ]);
      return { ...agent.toJSON(), todayCount: todayCount ?? 0, todaySum: todaySum ?? 0 };
    }));

    return res.json({
      data:        enriched,
      total:       count,
      currentPage: parseInt(page),
      totalPages:  Math.ceil(count / limit),
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ── Admin: create agent ────────────────────────────────────────────────────────
export const adminCreateAgent = async (req, res) => {
  try {
    const { username, email, telephone } = req.body;
    if (!username || !email || !telephone) {
      return res.status(400).json({ message: 'username, email et telephone sont requis' });
    }

    const tmpPassword = generatePassword(10);

    // If user already exists, just promote to agent
    let user = await User.findOne({ where: { email } });
    if (user) {
      if (user.isAgent) {
        return res.status(409).json({ message: 'Cet utilisateur est déjà un agent' });
      }
      await user.update({ isAgent: true });
    } else {
      const hashed        = await bcrypt.hash(tmpPassword, 10);
      const accountNumber = `AGT-${Date.now().toString(36).toUpperCase()}`;
      user = await User.create({
        username,
        email,
        password:      hashed,
        telephone,
        isAgent:       true,
        isActive:      true,
        soldNumber:    0,
        accountNumber,
      });
    }

    // Send welcome email with credentials
    try {
      await sendEmail({
        to:      email,
        subject: 'BIM NEXT — Votre compte Agent est prêt',
        html: `
          <div style="font-family:sans-serif;max-width:520px;margin:auto;padding:32px 24px;border:1px solid #e5e7eb;border-radius:12px">
            <h2 style="color:#0353CC;margin-bottom:8px">Bienvenue, Agent BIM NEXT !</h2>
            <p>Bonjour <strong>${username}</strong>,</p>
            <p>Votre compte agent BIM NEXT a été créé avec succès. Vous pouvez maintenant traiter les retraits des clients depuis l'application mobile.</p>
            <div style="background:#f8fafc;border-radius:8px;padding:16px;margin:20px 0">
              <p style="margin:0 0 8px"><strong>Identifiants de connexion :</strong></p>
              <p style="margin:4px 0">Email : <code style="background:#e5e7eb;padding:2px 6px;border-radius:4px">${email}</code></p>
              <p style="margin:4px 0">Mot de passe : <code style="background:#e5e7eb;padding:2px 6px;border-radius:4px">${tmpPassword}</code></p>
              <p style="margin:4px 0">Numéro de compte : <code style="background:#e5e7eb;padding:2px 6px;border-radius:4px">${user.accountNumber}</code></p>
            </div>
            <p>Les clients utilisent votre <strong>numéro de compte</strong> pour effectuer un retrait via vous.</p>
            <p style="color:#6b7280;font-size:13px;margin-top:24px">— L'équipe BIM NEXT</p>
          </div>
        `,
      });
    } catch (_emailErr) {
      // Email failure shouldn't block the response
    }

    return res.status(201).json({
      message:       'Agent créé avec succès. Identifiants envoyés par email.',
      user:          { id: user.id, username: user.username, email: user.email, accountNumber: user.accountNumber, isAgent: user.isAgent },
      plainPassword: tmpPassword,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ── Admin: toggle agent (block / unblock / demote) ─────────────────────────────
export const adminToggleAgent = async (req, res) => {
  try {
    const { id }     = req.params;
    const { action } = req.body; // 'block' | 'unblock' | 'remove'

    const user = await User.findByPk(id);
    if (!user || !user.isAgent) {
      return res.status(404).json({ message: 'Agent introuvable' });
    }

    if      (action === 'block')   await user.update({ isBlocked: true });
    else if (action === 'unblock') await user.update({ isBlocked: false });
    else if (action === 'remove')  await user.update({ isAgent: false });
    else return res.status(400).json({ message: "Action invalide. Utilisez 'block', 'unblock' ou 'remove'." });

    return res.json({ message: 'Agent mis à jour', user: { id: user.id, isBlocked: user.isBlocked, isAgent: user.isAgent } });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ── Agent (mobile): get my received retraits ────────────────────────────────────
export const agentGetMyRetraits = async (req, res) => {
  try {
    const agentId = req.user?.id;
    const { period, startDate, endDate, page = 1, pageSize = 20 } = req.query;

    const agent = await User.findByPk(agentId);
    if (!agent || !agent.isAgent) {
      return res.status(403).json({ message: 'Accès réservé aux agents BIM NEXT' });
    }

    const limit  = parseInt(pageSize);
    const offset = (parseInt(page) - 1) * limit;

    const where = { targetId: agentId };

    if (period) {
      const from = getDateFrom(period);
      if (from) where.createdAt = { [Op.gte]: from };
    } else if (startDate && endDate) {
      where.createdAt = { [Op.between]: [new Date(startDate), new Date(endDate)] };
    }

    const { rows, count } = await TransactionRetrait.findAndCountAll({
      where,
      include: [{ model: User, as: 'sender', attributes: ['id', 'username', 'email', 'telephone', 'accountNumber'] }],
      order:   [['createdAt', 'DESC']],
      limit,
      offset,
      distinct: true,
    });

    const totalAmount = await TransactionRetrait.sum('amount', { where }) || 0;

    return res.json({
      data:        rows,
      total:       count,
      currentPage: parseInt(page),
      totalPages:  Math.ceil(count / limit),
      totalAmount,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ── Agent (mobile): get stats ──────────────────────────────────────────────────
export const agentGetStats = async (req, res) => {
  try {
    const agentId = req.user?.id;
    const agent   = await User.findByPk(agentId, {
      attributes: ['id', 'username', 'soldNumber', 'accountNumber', 'isAgent'],
    });

    if (!agent || !agent.isAgent) {
      return res.status(403).json({ message: 'Accès réservé aux agents BIM NEXT' });
    }

    const now            = new Date();
    const startOfDay     = new Date(now); startOfDay.setHours(0,0,0,0);
    const startOfWeek    = new Date(now); startOfWeek.setDate(now.getDate() - 7);
    const startOfMonth   = new Date(now); startOfMonth.setDate(1); startOfMonth.setHours(0,0,0,0);

    const [todayCount, todayTotal, weekTotal, monthTotal, allTimeTotal, allTimeCount] = await Promise.all([
      TransactionRetrait.count({ where: { targetId: agentId, createdAt: { [Op.gte]: startOfDay } } }),
      TransactionRetrait.sum('amount', { where: { targetId: agentId, createdAt: { [Op.gte]: startOfDay } } }),
      TransactionRetrait.sum('amount', { where: { targetId: agentId, createdAt: { [Op.gte]: startOfWeek } } }),
      TransactionRetrait.sum('amount', { where: { targetId: agentId, createdAt: { [Op.gte]: startOfMonth } } }),
      TransactionRetrait.sum('amount', { where: { targetId: agentId } }),
      TransactionRetrait.count({ where: { targetId: agentId } }),
    ]);

    return res.json({
      agent: {
        id:            agent.id,
        username:      agent.username,
        soldNumber:    agent.soldNumber,
        accountNumber: agent.accountNumber,
      },
      stats: {
        todayCount:   todayCount   ?? 0,
        todayTotal:   todayTotal   ?? 0,
        weekTotal:    weekTotal    ?? 0,
        monthTotal:   monthTotal   ?? 0,
        allTimeTotal: allTimeTotal ?? 0,
        allTimeCount: allTimeCount ?? 0,
      },
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

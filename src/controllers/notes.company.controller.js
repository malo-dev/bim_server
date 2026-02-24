import { Notes, Company, Product, User } from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import { Op } from 'sequelize';

/* ═══════════════════════════════════════════════════════════════════════
   NOTES CONTROLLER
   ═══════════════════════════════════════════════════════════════════════ */

/* ── GET ALL NOTES ────────────────────────────────────────────────────── */
export const getAllNotes = async (req, res) => {
  try {
    const {
      search,
      period,
      paginate = 'false',
      page = 1,
      pageSize = 20,
      companyId,
      productId,
      branchTrackId,
      userId,
    } = req.query;

    const isPaginate = paginate.toLowerCase() === 'true';
    const limit       = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset      = (currentPage - 1) * limit;

    const whereClause = {};

    if (companyId)     whereClause.companyId     = companyId;
    if (productId)     whereClause.productId     = productId;
    if (branchTrackId) whereClause.branchTrackId = branchTrackId;
    if (userId)        whereClause.userId        = userId;

    if (search) {
      whereClause[Op.and] = [
        ...(whereClause[Op.and] || []),
        {
          [Op.or]: [
            { notes:      { [Op.like]: `%${search}%` } },
            { totalStars: { [Op.like]: `%${search}%` } },
          ],
        },
      ];
    }

    if (period) {
      const startDate = getDateRangeByPeriod(period);
      if (startDate) {
        whereClause.createdAt = { [Op.gte]: startDate };
      }
    }

    const findOptions = {
      where: whereClause,
      order: [['createdAt', 'DESC']],
    //   include: [
    //     { model: User,    as: 'user',    attributes: ['id', 'username', 'email'] },
    //     { model: Product, as: 'product', attributes: ['productId', 'name', 'price'] },
    //     { model: Company, as: 'company', attributes: ['companyId', 'name'] },
    //   ],
    };

    if (isPaginate) {
      const { rows, count } = await Notes.findAndCountAll({
        ...findOptions,
        limit,
        offset,
      });

      return res.status(200).json({
        data: rows,
        total: count,
        currentPage,
        totalPages: Math.ceil(count / limit),
      });
    }

    const notes = await Notes.findAll(findOptions);

    return res.status(200).json({
      data: notes,
      total: notes.length,
      currentPage: 1,
      totalPages: 1,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Erreur lors de la récupération des notes',
      error: error.message,
    });
  }
};

/* ── GET NOTE BY ID ───────────────────────────────────────────────────── */
export const getNoteById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'ID de note invalide' });
    }

    const note = await Notes.findByPk(parsedId);

    if (!note) {
      return res.status(404).json({ message: 'Note introuvable' });
    }

    return res.status(200).json({
      data: note,
      message: 'Note récupérée avec succès',
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Erreur lors de la récupération de la note',
      error: error.message,
    });
  }
};

/* ── GET NOTES BY COMPANY ─────────────────────────────────────────────── */
export const getNotesByCompany = async (req, res) => {
  try {
    const { companyId } = req.params;
    const {
      productId,
      paginate = 'false',
      page = 1,
      pageSize = 20,
      period,
    } = req.query;

    const isPaginate  = paginate.toLowerCase() === 'true';
    const limit       = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset      = (currentPage - 1) * limit;

    // Vérifier que la company existe
    const company = await Company.findByPk(companyId);
    if (!company) {
      return res.status(404).json({ message: 'Entreprise introuvable' });
    }

    const whereClause = { companyId };
    if (productId) whereClause.productId = productId;

    if (period) {
      const startDate = getDateRangeByPeriod(period);
      if (startDate) whereClause.createdAt = { [Op.gte]: startDate };
    }

    const findOptions = {
      where: whereClause,
      order: [['createdAt', 'DESC']]
    //   include: [
    //     { model: User,    as: 'user',    attributes: ['id', 'username', 'email'] },
    //     { model: Product, as: 'product', attributes: ['productId', 'name', 'price'] },
    //   ],
    };

    if (isPaginate) {
      const { rows, count } = await Notes.findAndCountAll({
        ...findOptions,
        limit,
        offset,
      });

      // Calcul de la moyenne des étoiles
      const allNotes     = await Notes.findAll({ where: whereClause, attributes: ['totalStars'] });
      const avgStars     = allNotes.length
        ? (allNotes.reduce((sum, n) => sum + (n.totalStars || 0), 0) / allNotes.length).toFixed(1)
        : 0;

      return res.status(200).json({
        data: rows,
        total: count,
        currentPage,
        totalPages: Math.ceil(count / limit),
        averageStars: parseFloat(avgStars),
        companyName: company.name,
      });
    }

    const notes    = await Notes.findAll(findOptions);
    const avgStars = notes.length
      ? (notes.reduce((sum, n) => sum + (n.totalStars || 0), 0) / notes.length).toFixed(1)
      : 0;

    return res.status(200).json({
      data: notes,
      total: notes.length,
      currentPage: 1,
      totalPages: 1,
      averageStars: parseFloat(avgStars),
      companyName: company.name,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Erreur lors de la récupération des notes de l\'entreprise',
      error: error.message,
    });
  }
};

/* ── GET NOTES BY PRODUCT ─────────────────────────────────────────────── */
export const getNotesByProduct = async (req, res) => {
  try {
    const { productId } = req.params;
    const {
      companyId,
      paginate = 'false',
      page = 1,
      pageSize = 20,
    } = req.query;

    const isPaginate  = paginate.toLowerCase() === 'true';
    const limit       = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset      = (currentPage - 1) * limit;

    const product = await Product.findByPk(productId);
    if (!product) {
      return res.status(404).json({ message: 'Produit introuvable' });
    }

    const whereClause = { productId };
    if (companyId) whereClause.companyId = companyId;

    const findOptions = {
      where: whereClause,
      order: [['createdAt', 'DESC']]
    //   include: [
    //     { model: User,    as: 'user',    attributes: ['id', 'username', 'email'] },
    //     { model: Company, as: 'company', attributes: ['companyId', 'name'] },
    //   ],
    };

    if (isPaginate) {
      const { rows, count } = await Notes.findAndCountAll({ ...findOptions, limit, offset });
      const allNotes = await Notes.findAll({ where: whereClause, attributes: ['totalStars'] });
      const avgStars = allNotes.length
        ? (allNotes.reduce((sum, n) => sum + (n.totalStars || 0), 0) / allNotes.length).toFixed(1)
        : 0;

      return res.status(200).json({
        data: rows,
        total: count,
        currentPage,
        totalPages: Math.ceil(count / limit),
        averageStars: parseFloat(avgStars),
        productName: product.name,
      });
    }

    const notes    = await Notes.findAll(findOptions);
    const avgStars = notes.length
      ? (notes.reduce((sum, n) => sum + (n.totalStars || 0), 0) / notes.length).toFixed(1)
      : 0;

    return res.status(200).json({
      data: notes,
      total: notes.length,
      currentPage: 1,
      totalPages: 1,
      averageStars: parseFloat(avgStars),
      productName: product.name,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Erreur lors de la récupération des notes du produit',
      error: error.message,
    });
  }
};

/* ── CREATE NOTE ──────────────────────────────────────────────────────── */
export const createNote = async (req, res) => {
  try {
    const { companyId, productId, userId, totalStars, notes, branchTrackId } = req.body;

    if (!companyId) {
      return res.status(400).json({ message: 'Le champ companyId est obligatoire' });
    }

    if (totalStars !== undefined && (totalStars < 1 || totalStars > 5)) {
      return res.status(400).json({ message: 'totalStars doit être compris entre 1 et 5' });
    }

    // Vérifier que la company existe
    const company = await Company.findByPk(companyId);
    if (!company) {
      return res.status(404).json({ message: 'Entreprise introuvable' });
    }

    // Vérifier que le produit existe si fourni
    if (productId) {
      const product = await Product.findByPk(productId);
      if (!product) {
        return res.status(404).json({ message: 'Produit introuvable' });
      }
    }

    const newNote = await Notes.create({
      companyId,
      productId:     productId     || null,
      userId:        userId        || null,
      branchTrackId: branchTrackId || null,
      totalStars:    totalStars    || null,
      notes:         notes         || null,
    });

    // const noteWithRelations = await Notes.findByPk(newNote.noteId, {
    //   include: [
    //     { model: User,    as: 'user',    attributes: ['id', 'username', 'email'] },
    //     { model: Product, as: 'product', attributes: ['productId', 'name', 'price'] },
    //     { model: Company, as: 'company', attributes: ['companyId', 'name'] },
    //   ],
      // });
      
        const noteWithRelations = await Notes.findByPk(newNote.noteId);

    return res.status(201).json({
      message: 'Note créée avec succès',
      data: noteWithRelations,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Erreur lors de la création de la note',
      error: error.message,
    });
  }
};

/* ── UPDATE NOTE ──────────────────────────────────────────────────────── */
export const updateNote = async (req, res) => {
  try {
    const { id } = req.params;

    const note = await Notes.findByPk(id);
    if (!note) {
      return res.status(404).json({ message: 'Note introuvable' });
    }

    const { totalStars } = req.body;
    if (totalStars !== undefined && (totalStars < 1 || totalStars > 5)) {
      return res.status(400).json({ message: 'totalStars doit être compris entre 1 et 5' });
    }

    await note.update(req.body);

    const updatedNote = await Notes.findByPk(id, {
      include: [
        { model: User,    as: 'user',    attributes: ['id', 'username', 'email'] },
        { model: Product, as: 'product', attributes: ['productId', 'name', 'price'] },
        { model: Company, as: 'company', attributes: ['companyId', 'name'] },
      ],
    });

    return res.status(200).json({
      message: 'Note mise à jour avec succès',
      data: updatedNote,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Erreur lors de la mise à jour de la note',
      error: error.message,
    });
  }
};

/* ── DELETE NOTE ──────────────────────────────────────────────────────── */
export const deleteNote = async (req, res) => {
  try {
    const { id } = req.params;

    const note = await Notes.findByPk(id);
    if (!note) {
      return res.status(404).json({ message: 'Note introuvable' });
    }

    await note.destroy();

    return res.status(200).json({ message: 'Note supprimée avec succès' });
  } catch (error) {
    return res.status(500).json({
      message: 'Erreur lors de la suppression de la note',
      error: error.message,
    });
  }
};

import { Op } from 'sequelize';
import { Redevtrack } from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';

export const getAllRedevtracks = async (req, res) => {
  try {
    const {
      search,
      period,
      paginate = 'false',
      page = 1,
      pageSize = 20,
      commerceId,
      branchTrackId,
    } = req.query;

   

    const isPaginate = paginate === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

     const whereClause = {};
            if (commerceId) {
      whereClause.commerceId = commerceId;
    }


     
       if (commerceId && branchTrackId) {
      whereClause[Op.and] = [
        {
          [Op.or]: [
            { branchTrackId },
            { branchTrackId: null }, 
          ],
        },
      ];
    }

           if (search) {
      whereClause[Op.and] = [
        ...(whereClause[Op.and] || []),
        {
          [Op.or]: [
          { customerName: { [Op.like]: `%${search}%` } },
            { description: { [Op.like]: `%${search}%` } },
          ],
        },
      ];
    }

   

  

    if (period) {
      const startDate = getDateRangeByPeriod(period);
      if (startDate) {
        whereClause.createdAt = {
          [Op.gte]: startDate,
        };
      }
    }

    const findOptions = {
      where: whereClause,
      order: [['createdAt', 'ASC']],
    };

    if (isPaginate) {
      const { rows, count } = await Redevtrack.findAndCountAll({
        ...findOptions,
        limit,
        offset,
      });

      return res.status(200).json({
        message: 'Redevtracks récupérés avec succès',
        data: rows,
        pagination: {
          total: count,
          page: currentPage,
          pageSize: limit,
          totalPages: Math.ceil(count / limit),
        },
      });
    }

    const redevtracks = await Redevtrack.findAll(findOptions);

    return res.status(200).json({
      message: 'Redevtracks récupérés avec succès',
      data: redevtracks,
      total: redevtracks.length,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Erreur serveur',
      error: error.message,
    });
  }
};

export const getRedevtrackById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'ID Redevtrack invalide' });
    }

    const item = await Redevtrack.findByPk(parsedId);

    if (!item) {
      return res.status(404).json({ message: 'Redevtrack non trouvé' });
    }

    res.status(200).json({
      message: 'Redevtrack récupéré avec succès',
      data: item,
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de la récupération', error });
  }
};

export const createRedevtrack = async (req, res) => {
  try {
    const { customerName, productId, amountLeft, description, commerceId, branchTrackId, dueDate } =
      req.body;

    if (!customerName || !productId || !amountLeft || !commerceId || !dueDate) {
      return res.status(400).json({
        message: 'customerName, productId, amountLeft, commerceId et dueDate sont obligatoires',
      });
    }

    const newItem = await Redevtrack.create({
      customerName,
      productId,
      amountLeft,
      description: description || null,
      commerceId,
      branchTrackId: branchTrackId || null,
      dueDate,
    });

    return res.status(201).json({
      message: 'Redevtrack créé avec succès',
      data: newItem,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Erreur lors de la création du Redevtrack',
      error: error.message,
    });
  }
};

export const updateRedevtrack = async (req, res) => {
  try {
    const { id } = req.params;
    const item = await Redevtrack.findByPk(id);

    if (!item) {
      return res.status(404).json({ message: 'Redevtrack non trouvé' });
    }

    const updatedItem = await item.update(req.body);

    res.status(200).json({
      message: 'Redevtrack mis à jour avec succès',
      data: updatedItem,
    });
  } catch (error) {
    res.status(500).json({
      message: 'Erreur lors de la mise à jour',
      error: error.message,
    });
  }
};

export const deleteRedevtrack = async (req, res) => {
  try {
    const { id } = req.params;
    const item = await Redevtrack.findByPk(id);

    if (!item) {
      return res.status(404).json({ message: 'Redevtrack non trouvé' });
    }

    await item.destroy();

    res.status(200).json({
      message: 'Redevtrack supprimé avec succès',
    });
  } catch (error) {
    res.status(500).json({
      message: 'Erreur lors de la suppression',
      error: error.message,
    });
  }
};

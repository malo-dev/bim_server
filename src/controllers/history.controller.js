import { History } from '../models/index.js';
import { Op} from 'sequelize';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';

export const getAllHistorys = async (req, res) => {
  try {
    const {
      search,
      paginate = 'false',
      page = 1,
      pageSize = 20,
      commerceId,
      branchTrackId,
      period,
      userId,
      type,
      status
    } = req.query;
        const isPaginate = paginate === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

     const whereClause = {};

         if (commerceId) {
      whereClause.commerceId = commerceId;
    }
    if (type) {
      whereClause.type= type    ;
    }


         if (userId) {
      whereClause.id = userId;
    }


          if (status) {
      whereClause.status = status;
    }


       if (commerceId && branchTrackId) {
      whereClause[Op.and] = [
        {
          [Op.or]: [
            { branchTrackId },
          ],
        },
      ];
    }


  

       if (search) {
      whereClause[Op.and] = [
        ...(whereClause[Op.and] || []),
        {
          [Op.or]: [
            { action: { [Op.like]: `%${search}%` } },
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

    const queryOptions = {
      where: whereClause,
    
      order: [['createdAt', 'DESC']],
    };

    if (isPaginate) {
      const { rows, count } = await History.findAndCountAll({
        ...queryOptions,
        limit,
        offset,
      });

      return res.status(200).json({
        message: 'Requête passée avec succès',
        data: rows,
          total: count,
          page: currentPage,
          pageSize: limit,
          totalPages: Math.ceil(count / limit),
      });
    }

    const categories = await History.findAll(queryOptions);

    return res.status(200).json({
      message: 'Requête passée avec succès',
      data: categories,
      total: categories.length,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Server error',
      error: error.message,
    });
  }
};

export const getHistoryById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid History ID' });
    }

    const HistoryItem = await History.findByPk(parsedId);

    if (!HistoryItem) {
      return res.status(404).json({ message: 'History not found' });
    }

    res.status(200).json({
      data: HistoryItem,
      message: 'History retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving History', error });
  }
};

export const createHistory = async (req, res) => {
  try {
    const { type, description, commerceId, branchTrackId, amount, action, status, userId } = req.body;


    if (!userId) {
      return res.status(401).json({
        message: "Vous n'êtes pas autorisé à effectuer cette requête.",
      });
    }

    const historyItem = await History.create({
      type,
      description,
      commerceId: commerceId || null,
      branchTrackId: branchTrackId || null,
      amount:amount || null ,
      action,
      status,
      id:userId, 
    });

    return res.status(201).json({
      message: "Historique ajouté avec succès.",
      data: historyItem,
    });
  } catch (error) {
    console.error("Erreur lors de la création de l'historique :", error);
    return res.status(500).json({
      message: "Une erreur serveur est survenue. Veuillez réessayer plus tard.",
      error: error.message,
    });
  }
};

export const updateHistory = async (req, res) => {
  try {
    const { id } = req.params;

    const HistoryItem = await History.findByPk(id);
    if (!HistoryItem) {
      return res.status(404).json({ message: 'History not found' });
    }

    const response = await HistoryItem.update(req.body);

    res.status(200).json({
      message: 'History updated successfully',
      data: response,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteHistory = async (req, res) => {
  try {
    const { id } = req.params;

    const HistoryItem = await History.findByPk(id);
    if (!HistoryItem) {
      return res.status(404).json({ message: 'History not found' });
    }

    await HistoryItem.destroy();

    res.status(200).json({
      message: 'History deleted successfully',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


import { Notification } from '../models/index.js';
import { Op } from 'sequelize';
import { parseFiltersConvert } from '../utils/parseFilters.utils.js';
import {getDateRangeByPeriod} from '../utils/getDateRangeByPeriod.util.js';

export const getAllNotifications = async (req, res) => {
  try {
    const { search, commerceId, userId, branchTrackId, paginate = "false", page = 1, pageSize = 20, filters } = req.query;

    const parsedFilters = parseFiltersConvert(Array.isArray(filters) ? filters : [filters]);

    const isPaginate = paginate.toLowerCase() === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

    const whereClause = {};

    // Filtre par type
    if (parsedFilters.type) {
      whereClause.type = parsedFilters.type;
    }

    // Filtre par commerce
    

   

     if (commerceId && branchTrackId ) {
      whereClause[Op.and] = [
        {
          [Op.or]: [
            { branchTrackId },
          ],
        },
      ];
    }
    const id = userId

       if (commerceId && id ) {
      whereClause[Op.and] = [
        {
          [Op.or]: [
            { id},
            
          ],
        },
      ];
    }

    

    // Filtre lecture
    if (parsedFilters.isRead !== null) {
      whereClause.isRead = parsedFilters.isRead;
    }

    // Filtre recherche
    if (search) {
      whereClause[Op.and] = [
        ...(whereClause[Op.and] || []),
        {
          [Op.or]: [
            { title: { [Op.like]: `%${search}%` } },
            { message: { [Op.like]: `%${search}%` } },
          ],
        },
      ];
    }

    // Filtre période
    if (parsedFilters.period) {
      const startDate = getDateRangeByPeriod(parsedFilters.period);
      if (startDate) {
        whereClause.createdAt = { [Op.gte]: startDate };
      }
    }

    const findOptions = {
      where: whereClause,
      order: [["createdAt", "DESC"]],
    };

    if (isPaginate) {
      const { rows, count } = await Notification.findAndCountAll({
        ...findOptions,
        limit,
        offset,
      });

      return res.status(200).json({
        data: rows,
        total: count,
        currentPage: currentPage,
        totalPages: Math.ceil(count / limit),
      });
    }

    const notifications = await Notification.findAll(findOptions);
    res.status(200).json({
      data: notifications,
      total: notifications.length,
      currentPage: 1,
      totalPages: 1,
    });

  } catch (error) {
    res.status(500).json({ message: "Erreur lors de la récupération des notifications", error: error.message });
  }
};


export const getNotificationById = async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (!id) return res.status(400).json({ message: 'ID de notification invalide' });

    const notification = await Notification.findByPk(id);
    if (!notification) return res.status(404).json({ message: 'Notification non trouvée' });

    res.status(200).json({ data: notification });
  } catch (error) {
    res.status(500).json({ message: "Erreur lors de la récupération de la notification", error: error.message });
  }
};

export const createNotification = async (req, res) => {
  try {
    const { title, message, type, isRead, expeTrackId, userId, commerceId, branchTrackId } = req.body;


    if (!title || !message ) {
      return res.status(400).json({
        message: "Les champs 'title', 'message' sont obligatoires.",
      });
    }


    const notification = await Notification.create({
      title,
      message,
      type: type || 'INFO',
      isRead: isRead ?? false, 
      expeTrackId: expeTrackId || null,
      userId: userId || null,
      commerceId : commerceId || null,
      branchTrackId: branchTrackId || null,
    });

    return res.status(201).json({
      message: "Notification créée avec succès.",
      data: notification,
    });
  } catch (error) {
  console.error("Erreur lors de la création de la notification :", error);

  if (error.name === "SequelizeValidationError") {
    return res.status(400).json({
      message: "Erreur de validation.",
      errors: error.errors.map(err => ({
        field: err.path,
        message: err.message,
      })),
    });
  }

  return res.status(500).json({
    message: "Une erreur serveur est survenue lors de la création de la notification.",
    error: error.message,
  });
}

};


export const updateNotification = async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (!id) return res.status(400).json({ message: 'ID de notification invalide' });

    const notification = await Notification.findByPk(id);
    if (!notification) return res.status(404).json({ message: 'Notification non trouvée' });

    await notification.update(req.body);
    res.status(200).json({ message: 'Notification mise à jour avec succès', data: notification });
  } catch (error) {
    res.status(500).json({ message: "Erreur lors de la mise à jour de la notification", error: error.message });
  }
};

export const deleteNotification = async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (!id) return res.status(400).json({ message: 'ID de notification invalide' });

    const notification = await Notification.findByPk(id);
    if (!notification) return res.status(404).json({ message: 'Notification non trouvée' });

    await notification.destroy();
    res.status(200).json({ message: 'Notification supprimée avec succès' });
  } catch (error) {
    res.status(500).json({ message: "Erreur lors de la suppression de la notification", error: error.message });
  }
};


export const markAsRead = async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (!id) return res.status(400).json({ message: 'ID de notification invalide' });

    const notification = await Notification.findByPk(id);
    if (!notification) return res.status(404).json({ message: 'Notification non trouvée' });

    await notification.update({ isRead: true });
    res.status(200).json({ message: 'Notification marquée comme lue', data: notification });
  } catch (error) {
    res.status(500).json({ message: "Erreur lors de la mise à jour de la notification", error: error.message });
  }
};


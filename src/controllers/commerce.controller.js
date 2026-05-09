import { BranchTrack, Commerce } from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import { Op } from 'sequelize';
import path from 'path';
import fs from 'fs';

export const getAllCommerces = async (req, res) => {
  try {
    const { search, period, paginate = 'false', page = 1, pageSize = 20, id} = req.query;

    const isPaginate = paginate === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

    const whereClause = {};
    if (id) {
      whereClause.id = id;
    }

    if (search) {
      whereClause[Op.and] = [
        {
          [Op.or]: [
            { commercename: { [Op.like]: `%${search}%` } },
            { commerceemail: { [Op.like]: `%${search}%` } },
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
      include: [
        {
          model: BranchTrack,
          as: 'branchTrack',
        },
      ],
    };

    if (isPaginate) {
      const { rows, count } = await Commerce.findAndCountAll({
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

    const Commerces = await Commerce.findAll(findOptions);

    return res.status(200).json({
      data: Commerces,
      total: Commerces.length,
      currentPage: 1,
      totalPages: 1,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Error retrieving Commerces',
      error: error.message,
    });
  }
};

export const getCommerceById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid Commerce ID' });
    }

    const CommerceItem = await Commerce.findByPk(parsedId,{
        include: [
        {
          model: BranchTrack,
          as: 'branchTrack',
        },
      ],
    });

    if (!CommerceItem) {
      return res.status(404).json({ message: 'Commerce not found' });
    }

    res.status(200).json({
      data: CommerceItem,
      message: 'Commerce retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving Commerce', error });
  }
};

export const createCommerce = async (req, res) => {
  try {
    const { id: userId, commercename, commerceemail } = req.body;

    if (!userId) {
      return res.status(409).json({
        message: "L'id de l'utilisateur est obligatoire",
      });
    }

    if (!commercename || !commerceemail) {
      return res.status(409).json({
        message: 'Nom et email du commerce sont obligatoires',
      });
    }

    const imageUrl = req.file ? `/images/${req.file.filename}` : null;

    const commerceExist = await Commerce.findOne({
      where: {
        commercename: commercename,
        commerceemail: commerceemail,
      },
    });

    if (commerceExist) {
      return res.status(409).json({
        message: 'Ce commerce existe déjà',
      });
    }

    const commerceItem = await Commerce.create({
      commercename: commercename,
      commerceemail: commerceemail,
      id: userId,
      imageUrl,
    });

    return res.status(201).json({
      message: 'Commerce ajouté avec succès',
      data: commerceItem,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Server error',
      error: error.message,
    });
  }
};

export const updateCommerce = async (req, res) => {
  try {
    const { id } = req.params;

    const CommerceItems = await Commerce.findByPk(id);
    if (!CommerceItems) {
      return res.status(404).json({ message: 'Commerce not found' });
    }

    let imageUrl = CommerceItems.imageUrl;

    if (req.file) {
      if (CommerceItems.imageUrl) {
        const oldImagePath = path.join('public', CommerceItems.imageUrl.replace('/images/', 'images/'));

        if (fs.existsSync(oldImagePath)) {
          fs.unlinkSync(oldImagePath);
        }
      }

      imageUrl = `/images/${req.file.filename}`;
    }

    await CommerceItems.update({
      ...req.body,
      imageUrl,
    });

    res.status(200).json({
      message: 'Commerce updated successfully',
      data: CommerceItems,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteCommerce = async (req, res) => {
  try {
    const { id } = req.params;
    const CommerceItems = await Commerce.findByPk(id);

    if (!CommerceItems) {
      return res.status(404).json({ message: 'Commerce not found' });
    }
    if (CommerceItems.imageUrl) {
      const imagePath = path.join('public', CommerceItems.imageUrl.replace('/images/', 'images/'));

      if (fs.existsSync(imagePath)) {
        fs.unlinkSync(imagePath);
      }
    }
    await CommerceItems.destroy();

    res.status(200).json({ message: 'Commerce and its image deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

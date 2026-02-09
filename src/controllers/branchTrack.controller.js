import { BranchTrack, Commerce } from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import { Op } from 'sequelize';
import path from 'path';
import fs from 'fs';

export const getAllBranchTracks = async (req, res) => {
  try {
    const { search, period, paginate = 'false', page = 1, pageSize = 20, commerceId } = req.query;

    if (!commerceId) {
      return res.status(409).json({
        message: 'CommerceId est obligatoire',
      });
    }

    const isPaginate = paginate === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

    const whereClause = {
      commerceId,
    };

    if (search) {
      whereClause[Op.and] = [
        {
          [Op.or]: [
            { branchTrackname: { [Op.like]: `%${search}%` } },
            { branchTrackemail: { [Op.like]: `%${search}%` } },
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
          model: Commerce,
          as: 'commerce',
        },
      ],
    };

    if (isPaginate) {
      const { rows, count } = await BranchTrack.findAndCountAll({
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

    const branchTracks = await BranchTrack.findAll(findOptions);

    return res.status(200).json({
      data: branchTracks,
      total: branchTracks.length,
      currentPage: 1,
      totalPages: 1,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Error retrieving BranchTracks',
      error: error.message,
    });
  }
};

export const getBranchTrackById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid BranchTrack ID' });
    }

    const BranchTrackItem = await BranchTrack.findByPk(parsedId,{
       include: [
        {
          model: Commerce,
          as: 'commerce',
        },
      ],
    });

    if (!BranchTrackItem) {
      return res.status(404).json({ message: 'BranchTrack not found' });
    }

    res.status(200).json({
      data: BranchTrackItem,
      message: 'BranchTrack retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving BranchTrack', error });
  }
};

export const createBranchTrack = async (req, res) => {
  try {
    const { branchTrackname, branchTrackemail, commerceId } = req.body;
    const imageUrl = req.file ? `/images/${req.file.filename}` : null;

    const BranchTrackItems = await BranchTrack.create({
      branchTrackname: branchTrackname,
       branchTrackemail : branchTrackemail,
      commerceId,
      imageUrl,
    });

    res.status(200).json({
      message: 'BranchTrack addded sucessfuly',
      data: BranchTrackItems,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const updateBranchTrack = async (req, res) => {
  try {
    const { id } = req.params;

    const BranchTrackItem = await BranchTrack.findByPk(id);
    if (!BranchTrackItem) {
      return res.status(404).json({ message: 'BranchTrack not found' });
    }

    let imageUrl = BranchTrackItem.imageUrl;

    if (req.file) {
      if (BranchTrackItem.imageUrl) {
        const oldImagePath = path.join(
          'public',
          BranchTrackItem.imageUrl.replace('/images/', 'images/')
        );

        if (fs.existsSync(oldImagePath)) {
          fs.unlinkSync(oldImagePath);
        }
      }

      imageUrl = `/images/${req.file.filename}`;
    }

    await BranchTrackItem.update({
      ...req.body,
      imageUrl,
    });

    res.status(200).json({
      message: 'BranchTrack updated successfully',
      data: BranchTrackItem,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteBranchTrack = async (req, res) => {
  try {
    const { id } = req.params;
    const BranchTrackItems = await BranchTrack.findByPk(id);

    if (!BranchTrackItems) {
      return res.status(404).json({ message: 'BranchTrack not found' });
    }
    if (BranchTrackItems.imageUrl) {
      const imagePath = path.join('public', BranchTrackItems.imageUrl.replace('/images/', 'images/'));

      if (fs.existsSync(imagePath)) {
        fs.unlinkSync(imagePath);
      }
    }
    await BranchTrackItems.destroy();

    res.status(200).json({ message: 'BranchTrack and its image deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

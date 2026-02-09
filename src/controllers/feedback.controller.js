import {  FeedBackTrack } from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import { Op } from 'sequelize';
import path from 'path';
import fs from 'fs';

export const getAllFeedBackTracks = async (req, res) => {
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

    const isPaginate = paginate.toLowerCase() === 'true';
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
                {  name: { [Op.like]: `%${search}%` } },
        { description: { [Op.like]: `%${search}%` } },
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
      order: [['createdAt', 'ASC']],
      // include: [
      //   { model: Currency, as: 'currency' },
      //   { model: Category, as: 'categories', through: { attributes: [] } },
      //   { model: FeedBackTrackSold, as: 'FeedBackTrackSold' },
      // ],
    };

    if (isPaginate) {
      const { rows, count } = await FeedBackTrack.findAndCountAll({
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

    const FeedBackTracks = await FeedBackTrack.findAll(findOptions);

    return res.status(200).json({
      data: FeedBackTracks,
      total: FeedBackTracks.length,
      currentPage: 1,
      totalPages: 1,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Erreur lors de la récupération des produits',
      error: error.message,
    });
  }
};

export const getFeedBackTrackById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid FeedBackTrack ID' });
    }

    const FeedBackTrackItem = await FeedBackTrack.findByPk(parsedId);

    if (!FeedBackTrackItem) {
      return res.status(404).json({ message: 'FeedBackTrack not found' });
    }

    res.status(200).json({
      data: FeedBackTrackItem,
      message: 'FeedBackTrack retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving FeedBackTrack', error });
  }
};

export const createFeedBackTrack = async (req, res) => {
  try {
    

    if (!req.body.email || !req.body.description || !req.body.commerceId || !req.body.name) {
      return res.status(400).json({
        message: 'Le nom, l\'email, la description  et le commerceId sont obligatoires',
      });
    }

    const imageUrl = req.file ? `/images/${req.file.filename}` : null;

    const FeedBackTrackItem = await FeedBackTrack.create({
      email : req.body.email,
      name : req.body.name,
      description : req.body.description,
      
      commerceId : req.body.commerceId,
      branchTrackId: req.body.branchTrackId || null,
      imageUrl,
    });

    res.status(201).json({
      message: 'Message créé avec succès',
      data: FeedBackTrackItem,
    });
  } catch (error) {
  

  return res.status(400).json({
    message: error.name,
    errors: error.errors?.map(err => ({
      field: err.path,
      message: err.message,
    })),
  });
}
};

export const updateFeedBackTrack = async (req, res) => {
  try {
    const { id } = req.params;

    const FeedBackTrackItem = await FeedBackTrack.findByPk(id);
    if (!FeedBackTrackItem) {
      return res.status(404).json({ message: 'FeedBackTrack not found' });
    }

    let imageUrl = FeedBackTrackItem.imageUrl;

    if (req.file) {
      if (FeedBackTrackItem.imageUrl) {
        const oldImagePath = path.join('public', FeedBackTrackItem.imageUrl.replace('/images/', 'images/'));
        if (fs.existsSync(oldImagePath)) {
          fs.unlinkSync(oldImagePath);
        }
      }

      imageUrl = `/images/${req.file.filename}`;
    }

    await FeedBackTrackItem.update({
      ...req.body,
      imageUrl,
    });

    res.status(200).json({
      message: 'FeedBackTrack updated successfully',
      data: FeedBackTrackItem,
    });
  } catch (error) {


  return res.status(400).json({
    message: error.name,
    errors: error.errors?.map(err => ({
      field: err.path,
      message: err.message,
    })),
  });
}
};

export const deleteFeedBackTrack = async (req, res) => {
  try {
    const { id } = req.params;
    const FeedBackTrackItem = await FeedBackTrack.findByPk(id);

    if (!FeedBackTrackItem) {
      return res.status(404).json({ message: 'FeedBackTrack not found' });
    }
    if (FeedBackTrackItem.imageUrl) {
      const imagePath = path.join('public', FeedBackTrackItem.imageUrl.replace('/images/', 'images/'));

      if (fs.existsSync(imagePath)) {
        fs.unlinkSync(imagePath);
      }
    }
    await FeedBackTrackItem.destroy();

    res.status(200).json({ message: 'FeedBackTrack and its image deleted successfully' });
  }catch (error) {
  console.error(error);

  return res.status(400).json({
    message: error.name,
    errors: error.errors?.map(err => ({
      field: err.path,
      message: err.message,
    })),
  });
}
};

import { ExpeTrack } from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import { Op } from 'sequelize';
import path from 'path';
import fs from 'fs';

export const getAllExpeTracks = async (req, res) => {
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
            { reference: { [Op.like]: `%${search}%` } },
        { carrierName: { [Op.like]: `%${search}%` } },
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

    const findOptions = { where: whereClause, order: [['createdAt', 'ASC']] };

    if (isPaginate) {
      const { rows, count } = await ExpeTrack.findAndCountAll({ ...findOptions, limit, offset });
      return res.status(200).json({
        data: rows,
        total: count,
        currentPage: parseInt(page, 10),
        totalPages: Math.ceil(count / limit),
      });
    }

    const expeTracks = await ExpeTrack.findAll(findOptions);
    res
      .status(200)
      .json({ data: expeTracks, total: expeTracks.length, currentPage: 1, totalPages: 1 });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving ExpeTracks', error: error.message });
  }
};

export const getExpeTrackById = async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (!id) return res.status(400).json({ message: 'Invalid ExpeTrack ID' });

    const expeTrack = await ExpeTrack.findByPk(id);
    if (!expeTrack) return res.status(404).json({ message: 'ExpeTrack not found' });

    res.status(200).json({ data: expeTrack, message: 'ExpeTrack retrieved successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving ExpeTrack', error });
  }
};

export const createExpeTrack = async (req, res) => {
  try {
    console.log("this is the ",req.body)
    const {commerceId} = req.body;
     if (!commerceId) {
      return res.status(409).json({
        message: 'CommerceId est obligatoire',
      });
    }

    const imageUrl = req.file ? `/images/${req.file.filename}` : null;
    const newExpeTrack = await ExpeTrack.create({ ...req.body, imageUrl });

    res.status(201).json({ message: 'ExpeTrack added successfully', data: newExpeTrack });
  } catch (error) {
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

export const updateExpeTrack = async (req, res) => {
  try {
    const id = Number(req.params.id);
    const expeTrackItems = await ExpeTrack.findByPk(id);
    if (!expeTrackItems) return res.status(404).json({ message: 'ExpeTrack not found' });

    let imageUrl = expeTrackItems.imageUrl;
    if (req.file) {
      const oldImagePath = path.join('public', expeTrackItems.imageUrl?.replace('/images/', 'images/'));
      fs.existsSync(oldImagePath) && fs.unlinkSync(oldImagePath);
      imageUrl = `/images/${req.file.filename}`;
    }

    await expeTrackItems.update({ ...req.body, imageUrl });
    res.status(200).json({ message: 'ExpeTrack updated successfully', data: expeTrackItems });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteExpeTrack = async (req, res) => {
  try {
    const id = Number(req.params.id);
    const expeTrackItems = await ExpeTrack.findByPk(id);
    if (!expeTrackItems) return res.status(404).json({ message: 'ExpeTrack not found' });

    if (expeTrackItems.imageUrl) {
      const imagePath = path.join('public', expeTrackItems.imageUrl.replace('/images/', 'images/'));
      fs.existsSync(imagePath) && fs.unlinkSync(imagePath);
    }

    await expeTrackItems.destroy();
    res.status(200).json({ message: 'ExpeTrack and its image deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

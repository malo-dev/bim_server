import { ClientTrack } from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import { Op } from 'sequelize';
import path from 'path';
import fs from 'fs';

export const getAllClientTracks = async (req, res) => {
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
            { name: { [Op.like]: `%${search}%` } },
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
    };

    if (isPaginate) {
      const { rows, count } = await ClientTrack.findAndCountAll({
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

    const ClientTracks = await ClientTrack.findAll(findOptions);

    return res.status(200).json({
      data: ClientTracks,
      total: ClientTracks.length,
      currentPage: 1,
      totalPages: 1,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Error retrieving ClientTracks',
      error: error.message,
    });
  }
};

export const getClientTrackById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid ClientTrack ID' });
    }

    const ClientTrackItem = await ClientTrack.findByPk(parsedId);

    if (!ClientTrackItem) {
      return res.status(404).json({ message: 'ClientTrack not found' });
    }

    res.status(200).json({
      data: ClientTrackItem,
      message: 'ClientTrack retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving ClientTrack', error });
  }
};

export const createClientTrack = async (req, res) => {
  try {
   
    const { name, description, commerceId, branchTrackId,email } = req.body;
    

    if (!commerceId) {
      return res.status(409).json({
        message: 'CommerceId est obligatoire',
      });
    }

    const imageUrl = req.file ? `/images/${req.file.filename}` : null;

    const whereClause = {
      name,
      commerceId,
      branchTrackId: branchTrackId || null,
      email
    };

    const clientTrackExist = await ClientTrack.findOne({
      where: whereClause,
    });

    if (clientTrackExist) {
      return res.status(409).json({
        message: 'Ce client existe déjà pour ce commerce',
      });
    }

    const clientTrackItem = await ClientTrack.create({
      name,
      description,
      commerceId,
      branchTrackId: branchTrackId || null,
      imageUrl,
      email
    });

    return res.status(201).json({
      message: 'ClientTrack ajouté avec succès',
      data: clientTrackItem,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Server error',
      error: error.message,
    });
  }
};

export const updateClientTrack = async (req, res) => {
  try {
    const { id } = req.params;

    const ClientTrackItems = await ClientTrack.findByPk(id);
    if (!ClientTrackItems) {
      return res.status(404).json({ message: 'ClientTrack not found' });
    }

    let imageUrl = ClientTrackItems.imageUrl;

    if (req.file) {
      if (ClientTrackItems.imageUrl) {
        const oldImagePath = path.join(
          'public',
          ClientTrackItems.imageUrl.replace('/images/', 'images/')
        );

        if (fs.existsSync(oldImagePath)) {
          fs.unlinkSync(oldImagePath);
        }
      }

      imageUrl = `/images/${req.file.filename}`;
    }

    await ClientTrackItems.update({
      ...req.body,
      imageUrl,
    });

    res.status(200).json({
      message: 'ClientTrack updated successfully',
      data: ClientTrackItems,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteClientTrack = async (req, res) => {
  try {
    const { id } = req.params;
    const ClientTrackItems = await ClientTrack.findByPk(id);

    if (!ClientTrackItems) {
      return res.status(404).json({ message: 'ClientTrack not found' });
    }
    if (ClientTrackItems.imageUrl) {
      const imagePath = path.join('public', ClientTrackItems.imageUrl.replace('/images/', 'images/'));

      if (fs.existsSync(imagePath)) {
        fs.unlinkSync(imagePath);
      }
    }
    await ClientTrackItems.destroy();

    res.status(200).json({ message: 'ClientTrack and its image deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

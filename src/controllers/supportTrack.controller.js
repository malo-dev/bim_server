import { SupportTrack, User } from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import nodemailer from 'nodemailer';
import { Op } from 'sequelize';
import path from 'path';
import fs from 'fs';
import { generateProjectReceivedEmailTemplateValue  } from '../utils/templateMails.util.js';


export const getAllSupportTracks = async (req, res) => {
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
                {  email: { [Op.like]: `%${search}%` } },
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
      order: [['createdAt', 'DESC']],
      include: [
        { model: User, as: 'user', attributes: ['id', 'username', 'email'] },
      ],
    };

    if (isPaginate) {
      const { rows, count } = await SupportTrack.findAndCountAll({
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

    const SupportTracks = await SupportTrack.findAll(findOptions);

    return res.status(200).json({
      data: SupportTracks,
      total: SupportTracks.length,
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

export const getSupportTrackById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid SupportTrack ID' });
    }

    const SupportTrackItem = await SupportTrack.findByPk(parsedId);

    if (!SupportTrackItem) {
      return res.status(404).json({ message: 'SupportTrack not found' });
    }

    res.status(200).json({
      data: SupportTrackItem,
      message: 'SupportTrack retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving SupportTrack', error });
  }
};

export const createSupportTrack = async (req, res) => {
  try {
    if (!req.body.email || !req.body.description || !req.body.id) {
      return res.status(400).json({
        message: 'Veuillez remplir tous les champs, ils sont obligatoires',
      });
    }

    const imageUrl = req.file ? `/images/${req.file.filename}` : null;

    const transporter = nodemailer.createTransport({
      host: 'mail.bimreseau.com',
      port: 465,
      secure: true,
      auth: {
        user: 'noreply@bimreseau.com',
        // eslint-disable-next-line no-undef
        pass: process.env.EMAIL_PASSWORD,
      },
    });




    try {
    await transporter.sendMail({
      from: 'noreply@bimreseau.com',
      to: req.body.email,
      subject: "Ticket support reçu - BIM NEXT",
      html: generateProjectReceivedEmailTemplateValue(
        req.body.sujet,
        req.body.description,
        new Date().toLocaleString()
      ),
    });
} catch (mailError) {
  console.error("Erreur envoi mail :", mailError.message);
  return res.status(400).json({
    message: `Impossible d'envoyer le mail à ${req.body.email}. Vérifiez l'adresse.`,
    error: mailError.message,
  });
}


    const support = await SupportTrack.create({
      sujet: req.body.sujet,
      email: req.body.email,
      description: req.body.description,
      id: Number(req.body.id),
      commerceId: req.body.commerceId ? Number(req.body.commerceId) : null,
      branchTrackId: req.body.branchTrackId ? Number(req.body.branchTrackId) : null,
      imageUrl,
    });

    res.status(201).json({
      message: 'Message créé avec succès',
      data: support,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: 'Erreur lors de la création',
      error: error.message,
    });
  }
};


export const updateSupportTrack = async (req, res) => {
  try {
    const { id } = req.params;

    const record = await SupportTrack.findByPk(id);
    if (!record) {
      return res.status(404).json({ message: 'Ticket introuvable' });
    }

    let imageUrl = record.imageUrl;

    if (req.file) {
      if (record.imageUrl) {
        const oldImagePath = path.join('public', record.imageUrl.replace('/images/', 'images/'));
        if (fs.existsSync(oldImagePath)) fs.unlinkSync(oldImagePath);
      }
      imageUrl = `/images/${req.file.filename}`;
    }

    await record.update({ ...req.body, imageUrl });

    res.status(200).json({ message: 'Ticket mis à jour', data: record });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteSupportTrack = async (req, res) => {
  try {
    const { id } = req.params;
    const record = await SupportTrack.findByPk(id);

    if (!record) {
      return res.status(404).json({ message: 'Ticket introuvable' });
    }
    if (record.imageUrl) {
      const imagePath = path.join('public', record.imageUrl.replace('/images/', 'images/'));
      if (fs.existsSync(imagePath)) fs.unlinkSync(imagePath);
    }
    await record.destroy();

    res.status(200).json({ message: 'Ticket supprimé avec succès' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

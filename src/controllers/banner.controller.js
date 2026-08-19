import { Banner } from '../models/index.js';
import path from 'path';
import fs from 'fs';

const emitBannersUpdated = async () => {
  try {
    const { getIO } = await import('../services/socket.service.js');
    getIO().emit('content:updated', { type: 'banners', at: new Date().toISOString() });
  } catch {}
};

export const getAllBanners = async (req, res) => {
  try {
    const { onlyActive } = req.query;
    const whereClause = {};
    if (onlyActive === 'true') whereClause.isActive = true;

    const banners = await Banner.findAll({
      where: whereClause,
      order: [['position', 'ASC'], ['createdAt', 'DESC']],
    });

    return res.status(200).json({ data: banners, total: banners.length });
  } catch (error) {
    return res.status(500).json({ message: 'Erreur lors de la récupération des bannières', error: error.message });
  }
};

export const getBannerById = async (req, res) => {
  try {
    const banner = await Banner.findByPk(req.params.id);
    if (!banner) return res.status(404).json({ message: 'Bannière introuvable' });
    return res.status(200).json({ data: banner });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

export const createBanner = async (req, res) => {
  try {
    const { title, tagline, linkUrl, position, isActive } = req.body;
    if (!title) return res.status(400).json({ message: 'Le titre est requis' });

    const imageUrl = req.file ? `/images/${req.file.filename}` : null;

    const banner = await Banner.create({
      title,
      tagline: tagline || null,
      linkUrl: linkUrl || null,
      position: position ? parseInt(position, 10) : 0,
      isActive: isActive === undefined ? true : isActive === 'true' || isActive === true,
      imageUrl,
    });

    await emitBannersUpdated();

    return res.status(201).json({ message: 'Bannière créée avec succès', data: banner });
  } catch (error) {
    return res.status(500).json({ message: 'Erreur lors de la création de la bannière', error: error.message });
  }
};

export const updateBanner = async (req, res) => {
  try {
    const banner = await Banner.findByPk(req.params.id);
    if (!banner) return res.status(404).json({ message: 'Bannière introuvable' });

    let imageUrl = banner.imageUrl;
    if (req.file) {
      if (banner.imageUrl) {
        const oldPath = path.join('public', banner.imageUrl.replace('/images/', 'images/'));
        if (fs.existsSync(oldPath)) fs.unlinkSync(oldPath);
      }
      imageUrl = `/images/${req.file.filename}`;
    }

    const body = { ...req.body };
    if (body.isActive !== undefined) body.isActive = body.isActive === 'true' || body.isActive === true;
    if (body.position !== undefined) body.position = parseInt(body.position, 10);

    await banner.update({ ...body, imageUrl });
    await emitBannersUpdated();

    return res.status(200).json({ message: 'Bannière mise à jour', data: banner });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

export const deleteBanner = async (req, res) => {
  try {
    const banner = await Banner.findByPk(req.params.id);
    if (!banner) return res.status(404).json({ message: 'Bannière introuvable' });

    if (banner.imageUrl) {
      const imagePath = path.join('public', banner.imageUrl.replace('/images/', 'images/'));
      if (fs.existsSync(imagePath)) fs.unlinkSync(imagePath);
    }
    await banner.destroy();
    await emitBannersUpdated();

    return res.status(200).json({ message: 'Bannière supprimée avec succès' });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

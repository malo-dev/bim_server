import { BusinessCategory,Company } from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import { Op } from 'sequelize';
import path from 'path';
import fs from 'fs';


// =============================
// GET ALL BUSINESS CATEGORIES
// =============================
export const getAllBusinessCategories = async (req, res) => {
  try {
    const {
      search,
      period,
      paginate = 'false',
      page = 1,
      pageSize = 10,
    } = req.query;

    const isPaginate = paginate.toLowerCase() === 'true';
    const size = parseInt(pageSize, 10);
    const offset = (page - 1) * size;

    const whereClause = {};

    // 🔎 SEARCH
    if (search) {
      whereClause[Op.or] = [
        { name: { [Op.like]: `%${search}%` } },
        { description: { [Op.like]: `%${search}%` } },
      ];
    }

    // 📅 PERIOD FILTER
    if (period) {
      const startDate = getDateRangeByPeriod(period);
      if (startDate) {
        whereClause.createdAt = { [Op.gte]: startDate };
      }
    }

    const findOptions = {
      where: whereClause,
      order: [['createdAt', 'ASC']],
       include: [
          { model: Company, as: 'companies' },
      ],
    };

    // 📄 PAGINATION
    if (isPaginate) {
      const { rows, count } = await BusinessCategory.findAndCountAll({
        ...findOptions,
        limit: size,
        offset,
      });

      return res.status(200).json({
        data: rows,
        total: count,
        currentPage: Number(page),
        totalPages: Math.ceil(count / size),
      });
    }

    const categories = await BusinessCategory.findAll(findOptions);

    return res.status(200).json({
      data: categories,
      total: categories.length,
      currentPage: 1,
      totalPages: 1,
    });

  } catch (error) {
    return res.status(500).json({
      message: 'Erreur lors de la récupération des catégories business',
      error: error.message,
    });
  }
};



// =============================
// GET BY ID
// =============================
export const getBusinessCategoryById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid business category ID' });
    }

    const category = await BusinessCategory.findByPk(parsedId);

    if (!category) {
      return res.status(404).json({ message: 'Business category not found' });
    }

    res.status(200).json({
      data: category,
      message: 'Business category retrieved successfully',
    });

  } catch (error) {
    res.status(500).json({
      message: 'Error retrieving business category',
      error: error.message,
    });
  }
};



// =============================
// CREATE
// =============================
export const createBusinessCategory = async (req, res) => {
  try {
    const categories = req.body;

    // Vérifier que c'est bien un tableau
    if (!Array.isArray(categories) || categories.length === 0) {
      return res.status(400).json({
        message: "Vous devez envoyer un tableau de catégories",
      });
    }

    // Vérifier que chaque élément contient au minimum un name
    for (const category of categories) {
      if (!category.name) {
        return res.status(400).json({
          message: "Chaque catégorie doit avoir un nom",
        });
      }
    }

    // Création multiple avec Sequelize
    const createdCategories = await BusinessCategory.bulkCreate(
      categories,
      { validate: true }
    );

    return res.status(201).json({
      message: "Catégories créées avec succès",
      count: createdCategories.length,
      data: createdCategories,
    });

  } catch (error) {
    return res.status(500).json({
      message: "Erreur lors de la création des catégories",
      error: error.message,
    });
  }
};




// =============================
// UPDATE
// =============================
export const updateBusinessCategory = async (req, res) => {
  try {
    const { id } = req.params;

    const category = await BusinessCategory.findByPk(id);

    if (!category) {
      return res.status(404).json({ message: 'Business category not found' });
    }

    let logo = category.logo;
    let imageUrl = category.imageUrl;

    // 🔁 LOGO UPDATE
    if (req.files?.logo) {
      if (category.logo) {
        const oldLogoPath = path.join(
          'public',
          category.logo.replace('/images/', 'images/')
        );

        if (fs.existsSync(oldLogoPath)) {
          fs.unlinkSync(oldLogoPath);
        }
      }

      logo = `/images/${req.files.logo[0].filename}`;
    }

    // 🔁 IMAGE UPDATE
    if (req.files?.image) {
      if (category.imageUrl) {
        const oldImagePath = path.join(
          'public',
          category.imageUrl.replace('/images/', 'images/')
        );

        if (fs.existsSync(oldImagePath)) {
          fs.unlinkSync(oldImagePath);
        }
      }

      imageUrl = `/images/${req.files.image[0].filename}`;
    }

    await category.update({
      ...req.body,
      logo,
      imageUrl,
    });

    res.status(200).json({
      message: 'Business category updated successfully',
      data: category,
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};



// =============================
// DELETE
// =============================
export const deleteBusinessCategory = async (req, res) => {
  try {
    const { id } = req.params;

    const category = await BusinessCategory.findByPk(id);

    if (!category) {
      return res.status(404).json({ message: 'Business category not found' });
    }

    // Delete logo
    if (category.logo) {
      const logoPath = path.join(
        'public',
        category.logo.replace('/images/', 'images/')
      );

      if (fs.existsSync(logoPath)) {
        fs.unlinkSync(logoPath);
      }
    }

    // Delete image
    if (category.imageUrl) {
      const imagePath = path.join(
        'public',
        category.imageUrl.replace('/images/', 'images/')
      );

      if (fs.existsSync(imagePath)) {
        fs.unlinkSync(imagePath);
      }
    }

    await category.destroy();

    res.status(200).json({
      message: 'Business category supprimée avec succès',
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

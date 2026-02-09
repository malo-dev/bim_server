import { Category } from '../models/index.js';
import { Op } from 'sequelize';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';

export const getAllCategorys = async (req, res) => {
  try {
    const {
      search,
      paginate = 'false',
      page = 1,
      pageSize = 20,
      commerceId,
      branchTrackId,
      period
    } = req.query;
        const isPaginate = paginate === 'true';
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
      const { rows, count } = await Category.findAndCountAll({
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

    const categories = await Category.findAll(queryOptions);

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

export const getCategoryById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid Category ID' });
    }

    const CategoryItem = await Category.findByPk(parsedId);

    if (!CategoryItem) {
      return res.status(404).json({ message: 'Category not found' });
    }

    res.status(200).json({
      data: CategoryItem,
      message: 'Category retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving Category', error });
  }
};

export const createCategory = async (req, res) => {
  try {
    const { name, description, commerceId, branchTrackId } = req.body;

    if (!commerceId) {
      return res.status(409).json({
        message: 'CommerceId est obligatoire',
      });
    }

    const whereClause = {
      name,
      commerceId,
    };

    if (branchTrackId) {
      whereClause.branchTrackId = branchTrackId;
    } else {
      whereClause.branchTrackId = null;
    }

    const categoryExist = await Category.findOne({
      where: whereClause,
    });

    if (categoryExist) {
      return res.status(409).json({
        message: 'Cette catégorie existe déjà pour ce commerce',
      });
    }

    const categoryItem = await Category.create({
      name,
      description,
      commerceId,
      branchTrackId: branchTrackId || null,
    });

    return res.status(201).json({
      message: 'Category added successfully',
      data: categoryItem,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Server error',
      error: error.message,
    });
  }
};

export const updateCategory = async (req, res) => {
  try {
    const { id } = req.params;

    const CategoryItem = await Category.findByPk(id);
    if (!CategoryItem) {
      return res.status(404).json({ message: 'Category not found' });
    }

    const response = await CategoryItem.update(req.body);

    res.status(200).json({
      message: 'Category updated successfully',
      data: response,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteCategory = async (req, res) => {
  try {
    const { id } = req.params;

    const CategoryItem = await Category.findByPk(id);
    if (!CategoryItem) {
      return res.status(404).json({ message: 'Category not found' });
    }

    await CategoryItem.destroy();

    res.status(200).json({
      message: 'Category deleted successfully',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

import { Category, Product, ProductCategory } from '../models/index.js';
import { Op } from 'sequelize';

export const getAllProductCategorys = async (req, res) => {
  try {
    const { search, paginate = 'false', page = 1, pageSize = 20 } = req.query;

    const isPaginate = paginate.toLowerCase() === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

    const whereClause = search
      ? {
          [Op.or]: [
            { productId: { [Op.iLike]: `%${search}%` } },
            { categoryId: { [Op.iLike]: `%${search}%` } },
          ],
        }
      : {};

    const findOptions = {
      where: whereClause,
    };

    if (isPaginate) {
      const { rows, count } = await ProductCategory.findAndCountAll({
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
    } else {
      const ProductCategorys = await ProductCategory.findAll(findOptions);

      return res.status(200).json({
        data: ProductCategorys,
        total: ProductCategorys.length,
        currentPage: 1,
        totalPages: 1,
      });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error retrievingProductCategorys', error });
  }
};

export const getProductCategoryById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid ProductCategory ID' });
    }

    const ProductCategoryItem = await ProductCategory.findByPk(parsedId);

    if (!ProductCategoryItem) {
      return res.status(404).json({ message: 'productCategory not found' });
    }

    res.status(200).json({
      data: ProductCategoryItem,
      message: 'productCategory retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrievingProductCategory', error });
  }
};

export const createproductCategorys = async (req, res) => {
  try {
    const { productId, categoryId } = req.body;

    const CategoryExist = await Category.findOne({
      where: { categoryId },
    });
    const ProductExist = await Product.findOne({
      where: { productId },
    });

    if (!CategoryExist || !ProductExist) {
      return res.status(409).json({
        message: 'This Item does nit exit sorry',
      });
    }

    const ProductCategoryItem = await ProductCategory.create({
      productId,
      categoryId,
    });

    res.status(201).json({
      message: 'productCategory added successfully',
      data: ProductCategoryItem,
    });
  } catch (error) {
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(409).json({
        message: 'productCategory already exists',
      });
    }

    res.status(500).json({ message: error.message });
  }
};

export const updateProductCategory = async (req, res) => {
  try {
    const { id } = req.params;

    const ProductCategoryItem = await ProductCategory.findOne({ where: { categoryId: id } });
    if (!ProductCategoryItem) {
      return res.status(404).json({ message: 'productCategory not found' });
    }

    const response = await ProductCategoryItem.update(req.body);

    res.status(200).json({
      message: 'productCategory updated successfully',
      data: response,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteproductCategory = async (req, res) => {
  try {
    const { id } = req.params;

   const ProductCategoryItem = await ProductCategory.findOne({ where: { categoryId: id } });
    if (!ProductCategoryItem) {
      return res.status(404).json({ message: 'productCategory not found' });
    }

    await ProductCategoryItem.destroy();

    res.status(200).json({
      message: 'productCategory deleted successfully',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Dissocier un produit d'une catégorie (par productId + categoryId dans le body)
export const unlinkProductCategory = async (req, res) => {
  try {
    const { productId, categoryId } = req.body;
    if (!productId || !categoryId) {
      return res.status(400).json({ message: 'productId et categoryId sont requis' });
    }
    const item = await ProductCategory.findOne({ where: { productId, categoryId } });
    if (!item) return res.status(404).json({ message: 'Association introuvable' });
    await item.destroy();
    res.status(200).json({ message: 'Association supprimée' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Lister les produits d'une catégorie
export const getProductsByCategoryId = async (req, res) => {
  try {
    const { id } = req.params;
    const links = await ProductCategory.findAll({ where: { categoryId: id } });
    res.status(200).json({ data: links.map(l => l.productId) });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

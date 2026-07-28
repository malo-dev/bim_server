import { Category, Currency, Product, ProductSold, Company, BusinessCategory } from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import { Op } from 'sequelize';
import path from 'path';
import fs from 'fs';


export const getAllProducts = async (req, res) => {
  try {
    const {
      search,
      period,
      paginate = 'false',
      page = 1,
      pageSize = 20,
      commerceId,
      branchTrackId,
      companyId,
      isRecommended,
      isUpselling,
    } = req.query;

    const isPaginate = paginate.toLowerCase() === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

     const whereClause = {};
    if (companyId) whereClause.companyId = companyId;
    if (isRecommended === 'true') whereClause.isRecommended = true;
    if (isUpselling === 'true') whereClause.isUpselling = true;
  
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
        { qty: { [Op.like]: `%${search}%` } },
        { Availability: { [Op.like]: `%${search}%` } },
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
      include: [
        { model: Currency, as: 'currency' },
        { model: Category, as: 'categories', through: { attributes: [] } },
        { model: ProductSold, as: 'productSold' },
        { model: Company, as: 'company', attributes: ['companyId', 'name', 'businessId'], include: [
          { model: BusinessCategory, as: 'category', attributes: ['businessId', 'name'] },
        ]},
      ],
    };

    if (isPaginate) {
      const { rows, count } = await Product.findAndCountAll({
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

    const products = await Product.findAll(findOptions);

    return res.status(200).json({
      data: products,
      total: products.length,
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

export const getProductById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid product ID' });
    }

    const productItem = await Product.findByPk(parsedId, {
      include: [
        {
          model: Currency,
          as: 'currency',
        },
        {
          model: Category,
          as: 'categories',
          through: { attributes: [] },
        },
      ],
    });

    if (!productItem) {
      return res.status(404).json({ message: 'Product not found' });
    }

    res.status(200).json({
      data: productItem,
      message: 'Product retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving product', error });
  }
};

export const createProduct = async (req, res) => {
  try {
    const products = req.body; 

    
    if (!Array.isArray(products) || products.length === 0) {
      return res.status(400).json({
        message: "Vous devez envoyer un tableau de produits",
      });
    }


    for (const product of products) {
      if (!product.name || !product.price || !product.companyId) {
        return res.status(400).json({
          message: "Chaque produit doit avoir un name, price et companyId",
        });
      }
    }

     const companyIds = [...new Set(products.map(p => p.companyId))];
    const existingCompanies = await Company.findAll({
      where: { companyId: companyIds },
      attributes: ["companyId"]
    });

    if (existingCompanies.length !== companyIds.length) {
      const existingIds = existingCompanies.map(c => c.companyId);
      const invalidIds = companyIds.filter(id => !existingIds.includes(id));
      return res.status(400).json({
        message: "Certains companyId n'existent pas",
        invalidIds
      });
    }


    // Optionnel : vérifier les doublons (ex: nom de produit unique par entreprise)
    const existingProducts = await Product.findAll({
      where: {
        name: products.map(p => p.name),
        companyId: products.map(p => p.companyId)
      },
      attributes: ["name", "companyId"],
    });

    if (existingProducts.length > 0) {
      return res.status(400).json({
        message: "Certains produits existent déjà",
        existingProducts
      });
    }

    // Création en bulk
    const createdProducts = await Product.bulkCreate(products, { validate: true });

    return res.status(201).json({
      message: "Produits créés avec succès",
      count: createdProducts.length,
      data: createdProducts,
    });

  } catch (error) {
    return res.status(500).json({
      message: "Erreur lors de la création des produits",
      error: error.message,
    });
  }
};


export const updateProduct = async (req, res) => {
  try {
    const { id } = req.params;

    const product = await Product.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    let imageUrl = product.imageUrl;

    if (req.file) {
      if (product.imageUrl) {
        const oldImagePath = path.join('public', product.imageUrl.replace('/images/', 'images/'));

        if (fs.existsSync(oldImagePath)) {
          fs.unlinkSync(oldImagePath);
        }
      }

      imageUrl = `/images/${req.file.filename}`;
    }

    await product.update({
      ...req.body,
      imageUrl,
    });

    res.status(200).json({
      message: 'Product updated successfully',
      data: product,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findByPk(id);

    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    if (product.imageUrl) {
      const imagePath = path.join('public', product.imageUrl.replace('/images/', 'images/'));

      if (fs.existsSync(imagePath)) {
        fs.unlinkSync(imagePath);
      }
    }
    await product.destroy();

    res.status(200).json({ message: 'Product and its image deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

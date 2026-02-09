import { Product, ProductSold,Currency } from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import { Op } from 'sequelize';

export const getAllProductSolds = async (req, res) => {
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
           { name: { [Op.iLike]: `%${search}%` } },
        { priceOfSelling: { [Op.iLike]: `%${search}%` } },
        { threehold: { [Op.iLike]: `%${search}%` } },
        { AvailabilityOfProduct: { [Op.iLike]: `%${search}%` } },
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
          model: Product,
          as: 'product',
        },
        { model: Currency, as: 'currency' },
      ],
    };

    if (isPaginate) {
      const { rows, count } = await ProductSold.findAndCountAll({
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

    const productSolds = await ProductSold.findAll(findOptions);

    return res.status(200).json({
      data: productSolds,
      total: productSolds.length,
      currentPage: 1,
      totalPages: 1,
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error retrieving ProductSolds',
      error: error.message,
    });
  }
};

export const getProductSoldById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid ProductSold ID' });
    }

    const ProductSoldItem = await ProductSold.findOne({
      where: {
        id,
      },
    });

    if (!ProductSoldItem) {
      return res.status(404).json({ message: 'ProductSold not found' });
    }

    res.status(200).json({
      data: ProductSoldItem,
      message: 'ProductSold retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrievingProductSold', error });
  }
};

export const createProductSolds = async (req, res) => {
  try {
    const { productId, priceOfSelling, qty, commerceId,branchTrackId } = req.body;

    if (!commerceId) {
      return res.status(409).json({
        message: 'CommerceId est obligatoire',
      });
    }

const whereClause = {
     
      commerceId,
    };

      if (branchTrackId) {
      whereClause.branchTrackId = branchTrackId;
    } else {
      whereClause.branchTrackId = null;
    }

        const productExist = await Product.findOne({ where: { productId } });
    if (!productExist) {
      return res.status(409).json({
        message: 'This product does not exist.',
      });
    }

    const getStockStatus = (stockQty, threshold) => {
      if (stockQty <= 0) return 'Out of stock';
      if (stockQty <= threshold / 2) return 'Critical stock';
      if (stockQty <= threshold) return 'Low stock';
      return 'In stock';
    };

    const pricePurchasing = Number(productExist.price);
    const qtyPurchasing = Number(productExist.qty);
    const requestedQty = Number(qty ?? 1);

    const remainingQty = qtyPurchasing - requestedQty;

    if (remainingQty < 0) {
      return res.status(409).json({
        message: 'Requested quantity exceeds available stock.',
      });
    }

    const name = productExist.name;
    const benefice = Number(priceOfSelling) - pricePurchasing;
    const priceAfterCredit = Math.abs(Number(priceOfSelling) - pricePurchasing);
    const AvailabilityOfProduct = getStockStatus(remainingQty, qtyPurchasing);

    const productSoldItem = await ProductSold.create({
      productId,
      name,
      threehold: remainingQty,
      priceOfSelling,
      qty: requestedQty,
      AvailabilityOfProduct,
      priceAfterCredit,
      benefice,
      commerceId,
       branchTrackId: branchTrackId || null,
    });

    await productExist.update({ qty: remainingQty });

    res.status(201).json({
      message: 'ProductSold added successfully',
      data: productSoldItem,
    });
  } catch (error) {
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(409).json({
        message: 'ProductSold already exists',
      });
    }

    res.status(500).json({ message: error.message });
  }
};

export const updateProductSold = async (req, res) => {
  try {
    const { id } = req.params;
    const { qty, priceOfSelling,currencyId} = req.body;

    const productSoldItem = await ProductSold.findOne({ where: { id } });

    if (!productSoldItem) {
      return res.status(404).json({ message: 'ProductSold not found' });
    }

    const product = await Product.findOne({ where: { productId: productSoldItem.productId } });

    if (!product) {
      return res.status(404).json({ message: 'Associated product not found' });
    }

    const qtyPurchasing = Number(product.qty) + Number(productSoldItem.qty);
    const requestedQty = Number(qty ?? productSoldItem.qty);

    const remainingQty = qtyPurchasing - requestedQty;

    if (remainingQty < 0) {
      return res.status(409).json({
        message: 'Requested quantity exceeds available stock.',
      });
    }

    const benefice =
      Number(priceOfSelling ?? productSoldItem.priceOfSelling) - Number(product.price);
    const priceAfterCredit = Math.abs(
      Number(priceOfSelling ?? productSoldItem.priceOfSelling) - Number(product.price)
    );
    const AvailabilityOfProduct =
      remainingQty <= 0 ? 'Out of stock' : remainingQty <= 10 ? 'Low stock' : 'In stock';

    const updatedItem = await productSoldItem.update({
      qty: requestedQty,
      priceOfSelling: priceOfSelling ?? productSoldItem.priceOfSelling,
      benefice,
      priceAfterCredit,
      threehold: remainingQty,
      AvailabilityOfProduct,
      currencyId 
    });

    await product.update({ qty: remainingQty});

    res.status(200).json({
      message: 'ProductSold updated successfully',
      data: updatedItem,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteProductSold = async (req, res) => {
  try {
    const { id } = req.params;

    const ProductSoldItem = await ProductSold.findOne({
      where: {
        id,
      },
    });
    if (!ProductSoldItem) {
      return res.status(404).json({ message: 'ProductSold not found' });
    }

    await ProductSoldItem.destroy();

    res.status(200).json({
      message: 'ProductSold deleted successfully',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

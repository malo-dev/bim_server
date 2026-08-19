import { ProductConsumption, User, Product, Company } from '../models/index.js';
import { Op } from 'sequelize';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';

export const getAllConsumptions = async (req, res) => {
  try {
    const {
      search,
      period,
      paginate = 'false',
      page = 1,
      pageSize = 20,
      userId,
      productId,
      companyId,
      isBonus,
    } = req.query;

    const isPaginate = paginate.toLowerCase() === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

    const whereClause = {};
    if (userId) whereClause.userId = userId;
    if (productId) whereClause.productId = productId;
    if (companyId) whereClause.companyId = companyId;
    if (isBonus === 'true') whereClause.isBonus = true;
    if (isBonus === 'false') whereClause.isBonus = false;
    if (search) whereClause.signatureName = { [Op.like]: `%${search}%` };

    if (period) {
      const startDate = getDateRangeByPeriod(period);
      if (startDate) whereClause.consumedAt = { [Op.gte]: startDate };
    }

    const findOptions = {
      where: whereClause,
      order: [['consumedAt', 'DESC']],
      include: [
        { model: User, as: 'user', attributes: ['id', 'username', 'imageUrl'] },
        { model: Product, as: 'product', attributes: ['productId', 'name', 'imageUrl', 'qty'] },
        { model: Company, as: 'company', attributes: ['companyId', 'name'] },
      ],
    };

    if (isPaginate) {
      const { rows, count } = await ProductConsumption.findAndCountAll({ ...findOptions, limit, offset });
      return res.status(200).json({
        data: rows,
        total: count,
        currentPage,
        totalPages: Math.ceil(count / limit),
      });
    }

    const rows = await ProductConsumption.findAll(findOptions);
    return res.status(200).json({ data: rows, total: rows.length, currentPage: 1, totalPages: 1 });
  } catch (error) {
    return res.status(500).json({ message: 'Erreur lors de la récupération des fiches de consommation', error: error.message });
  }
};

// Progression de fidélité d'un utilisateur sur un produit donné (X/10 avant le prochain offert).
export const getLoyaltyProgress = async (req, res) => {
  try {
    const { userId, productId } = req.query;
    if (!userId || !productId) {
      return res.status(400).json({ message: 'userId et productId requis' });
    }
    const count = await ProductConsumption.count({ where: { userId, productId, isBonus: false } });
    return res.status(200).json({ data: { count, progress: count % 10, remaining: 10 - (count % 10) } });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

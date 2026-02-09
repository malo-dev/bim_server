import { Currency } from '../models/index.js';
import { Op } from 'sequelize';

export const getAllCurrencys = async (req, res) => {
  try {
    const { search, paginate = 'false', page = 1, pageSize = 20 } = req.query;

    const isPaginate = paginate.toLowerCase() === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

    const whereClause = search
      ? {
          [Op.or]: [
            { name: { [Op.iLike]: `%${search}%` } },
            { description: { [Op.iLike]: `%${search}%` } },
            { code: { [Op.iLike]: `%${search}%` } },
            { symbole: { [Op.iLike]: `%${search}%` } },
          ],
        }
      : {};

    const findOptions = {
      where: whereClause,
      order: [['createdAt', 'ASC']],
    };

    if (isPaginate) {
      const { rows, count } = await Currency.findAndCountAll({
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
      const Currencys = await Currency.findAll(findOptions);

      return res.status(200).json({
        data: Currencys,
        total: Currencys.length,
        currentPage: 1,
        totalPages: 1,
      });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving Currencys', error });
  }
};

export const getCurrencyById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid Currency ID' });
    }

    const CurrencyItem = await Currency.findByPk(parsedId);

    if (!CurrencyItem) {
      return res.status(404).json({ message: 'Currency not found' });
    }

    res.status(200).json({
      data: CurrencyItem,
      message: 'Currency retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving Currency', error });
  }
};

export const createCurrency = async (req, res) => {
  try {
    const { name, code, description, symbol, rate } = req.body;

    const currencyExist = await Currency.findOne({
      where: { code },
    });

    if (currencyExist) {
      return res.status(409).json({
        message: 'This currency already exists',
      });
    }

    const currency = await Currency.create({
      code,
      description,
      name,
      symbol,
      rate,
    });

    res.status(201).json({
      message: 'Currency added successfully',
      data: currency,
    });
  } catch (error) {
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(409).json({
        message: 'Currency already exists',
      });
    }

    res.status(500).json({ message: error.message });
  }
};

export const updateCurrency = async (req, res) => {
  try {
    const { id } = req.params;

    const currencyItem = await Currency.findByPk(id);
    if (!currencyItem) {
      return res.status(404).json({ message: 'Currency not found' });
    }

    const response = await currencyItem.update(req.body);

    res.status(200).json({
      message: 'Currency updated successfully',
      data: response,
    });
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

export const deleteCurrency = async (req, res) => {
  try {
    const { id } = req.params;

    const currencyItem = await Currency.findByPk(id);
    if (!currencyItem) {
      return res.status(404).json({ message: 'Currency not found' });
    }

    await currencyItem.destroy();

    res.status(200).json({
      message: 'Currency deleted successfully',
    });
  }catch (error) {
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

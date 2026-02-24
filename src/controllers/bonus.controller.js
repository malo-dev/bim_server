import { Bonus } from "../models/index.js";
import { Op } from "sequelize";
import { getDateRangeByPeriod } from "../utils/getDateRangeByPeriod.util.js";

/**
 * GET ALL BONUS
 */
export const getAllBonus = async (req, res) => {
  try {
    const {
      search,
      paginate = "false",
      page = 1,
      pageSize = 20,
      userId,
      companyId,
      period,
    } = req.query;

    const isPaginate = paginate === "true";
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

    const whereClause = {};

    // Filtre user
    if (userId) {
      whereClause.userId = userId;
    }

    // Filtre company
    if (companyId) {
      whereClause.companyId = companyId;
    }

    // Search
    if (search) {
      whereClause[Op.and] = [
        {
          [Op.or]: [
            { bonusAccount: { [Op.like]: `%${search}%` } },
          ],
        },
      ];
    }

    // Filtre période
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
      order: [["createdAt", "DESC"]],
    };

    if (isPaginate) {
      const { rows, count } = await Bonus.findAndCountAll({
        ...queryOptions,
        limit,
        offset,
      });

      return res.status(200).json({
        message: "Requête passée avec succès",
        data: rows,
        total: count,
        page: currentPage,
        pageSize: limit,
        totalPages: Math.ceil(count / limit),
      });
    }

    const bonuses = await Bonus.findAll(queryOptions);

    return res.status(200).json({
      message: "Requête passée avec succès",
      data: bonuses,
      total: bonuses.length,
    });
  } catch (error) {
    return res.status(500).json({
      message: "Server error",
      error: error.message,
    });
  }
};

export const getBonusWithUserAndCompany = async (req, res) => {
  try {
    const bonuses = await Bonus.findAll({
      where: {
        userId: {
          [Op.ne]: null,
        },
        companyId: {
          [Op.ne]: null,
        },
      },
      order: [["createdAt", "DESC"]],
    });

    return res.status(200).json({
      message: "Bonus avec userId et companyId définis",
      data: bonuses,
      total: bonuses.length,
    });
  } catch (error) {
    return res.status(500).json({
      message: "Server error",
      error: error.message,
    });
  }
};



export const getBonusById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: "Invalid Bonus ID" });
    }

    const bonusItem = await Bonus.findByPk(parsedId);

    if (!bonusItem) {
      return res.status(404).json({ message: "Bonus not found" });
    }

    res.status(200).json({
      data: bonusItem,
      message: "Bonus retrieved successfully",
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};



export const createBonus = async (req, res) => {
  try {
    const { bonusAccount, userId, companyId } = req.body;

    if (!companyId) {
      return res.status(409).json({
        message: "companyId est obligatoire",
      });
    }

    const bonusItem = await Bonus.create({
      bonusAccount,
      userId: userId || null,
      companyId,
    });

    return res.status(201).json({
      message: "Bonus created successfully",
      data: bonusItem,
    });
  } catch (error) {
    return res.status(500).json({
      message: "Server error",
      error: error.message,
    });
  }
};


export const updateBonus = async (req, res) => {
  try {
    const { id } = req.params;

    const bonusItem = await Bonus.findByPk(id);
    if (!bonusItem) {
      return res.status(404).json({ message: "Bonus not found" });
    }

    const response = await bonusItem.update(req.body);

    res.status(200).json({
      message: "Bonus updated successfully",
      data: response,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};



export const deleteBonus = async (req, res) => {
  try {
    const { id } = req.params;

    const bonusItem = await Bonus.findByPk(id);
    if (!bonusItem) {
      return res.status(404).json({ message: "Bonus not found" });
    }

    await bonusItem.destroy();

    res.status(200).json({
      message: "Bonus deleted successfully",
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

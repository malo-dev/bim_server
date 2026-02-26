import { Company, BusinessCategory,Product} from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import { Op } from 'sequelize';
import path from 'path';
import fs from 'fs';



// =============================
// GET ALL COMPANIES
// =============================
export const getAllCompanies = async (req, res) => {
  try {
    const {
      search,
      period,
      paginate = 'false',
      page = 1,
      pageSize = 20,
    } = req.query;

    const isPaginate = paginate.toLowerCase() === 'true';
    const size = parseInt(pageSize, 10);
    const offset = (page - 1) * size;

    const whereClause = {};

    if (search) {
      whereClause[Op.or] = [
        { name: { [Op.like]: `%${search}%` } },
        { email: { [Op.like]: `%${search}%` } },
        { location: { [Op.like]: `%${search}%` } },
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
        { model: Product, as: 'products' }
       
      ],
    };

    // 📄 PAGINATION
    if (isPaginate) {
      const { rows, count } = await Company.findAndCountAll({
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

    const companies = await Company.findAll(findOptions);

    return res.status(200).json({
      data: companies,
      total: companies.length,
      currentPage: 1,
      totalPages: 1,
    });

  } catch (error) {
    return res.status(500).json({
      message: 'Erreur lors de la récupération des entreprises',
      error: error.message,
    });
  }
};



// =============================
// GET BY ID
// =============================
export const getCompanyById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid company ID' });
    }

    const company = await Company.findByPk(parsedId, {
      include: [
        { model: Product, as: 'products' }
       
      ],
    });

    if (!company) {
      return res.status(404).json({ message: 'Company not found' });
    }

    res.status(200).json({
      data: company,
      message: 'Company retrieved successfully',
    });

  } catch (error) {
    res.status(500).json({
      message: 'Error retrieving company',
      error: error.message,
    });
  }
};



// =============================
// CREATE
// =============================
export const createCompany = async (req, res) => {
  try {
    const companies = req.body;


    if (!Array.isArray(companies) || companies.length === 0) {
      return res.status(400).json({
        message: "Vous devez envoyer un tableau d'entreprises",
      });
    }


    for (const company of companies) {
      if (!company.name || !company.email) {
        return res.status(400).json({
          message: "Chaque entreprise doit avoir un nom et un email",
        });
      }
    }

    const emails = companies.map(c => c.email);
const duplicates = emails.filter((email, i) => emails.indexOf(email) !== i);
if (duplicates.length > 0) {
  return res.status(400).json({
    message: "Certains emails sont en doublon dans la requête",
    duplicates
  });
}

      
      const businessIds = [...new Set(companies.map(c => c.businessId))];
const existingBusinesses = await BusinessCategory.findAll({
  where: { businessId: businessIds },
  attributes: ['businessId']
});
if (existingBusinesses.length !== businessIds.length) {
  return res.status(400).json({
    message: "Certains businessId n'existent pas"
  });
}


    const existingCompanies = await Company.findAll({
      where: {
        email: emails,
      },
      attributes: ["email"],
    });

    if (existingCompanies.length > 0) {
      const existingEmails = existingCompanies.map((c) => c.email);

      return res.status(400).json({
        message: "Certains emails sont déjà utilisés",
        existingEmails,
      });
    }

    const createdCompanies = await Company.bulkCreate(companies, {
      validate: true,
    });

    return res.status(201).json({
      message: "Entreprises créées avec succès",
      count: createdCompanies.length,
      data: createdCompanies,
    });

  } catch (error) {
    return res.status(500).json({
      message: "Erreur lors de la création des entreprises",
      error: error.message,
    });
  }
};



// =============================
// UPDATE
// =============================
export const updateCompany = async (req, res) => {
  try {
    const { id } = req.params;

    const company = await Company.findByPk(id);

    if (!company) {
      return res.status(404).json({ message: 'Company not found' });
    }

    
    let imageUrl = company.imageUrl;

    // 🔁 UPDATE LOGO
    if (req.files?.logo) {
      if (company.logo) {
        const oldPath = path.join(
          'public',
          company.logo.replace('/images/', 'images/')
        );

        if (fs.existsSync(oldPath)) {
          fs.unlinkSync(oldPath);
        }
      }

     
    }

    // 🔁 UPDATE IMAGE
    if (req.files?.image) {
      if (company.imageUrl) {
        const oldImagePath = path.join(
          'public',
          company.imageUrl.replace('/images/', 'images/')
        );

        if (fs.existsSync(oldImagePath)) {
          fs.unlinkSync(oldImagePath);
        }
      }

      imageUrl = `/images/${req.files.image[0].filename}`;
    }

    await company.update({
      ...req.body,
      imageUrl,
    });

    res.status(200).json({
      message: 'Company updated successfully',
      data: company,
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};



// =============================
// DELETE
// =============================
export const deleteCompany = async (req, res) => {
  try {
    const { id } = req.params;

    const company = await Company.findByPk(id);

    if (!company) {
      return res.status(404).json({ message: 'Company not found' });
    }

    // Delete logo
    if (company.logo) {
      const logoPath = path.join(
        'public',
        company.logo.replace('/images/', 'images/')
      );

      if (fs.existsSync(logoPath)) {
        fs.unlinkSync(logoPath);
      }
    }

    // Delete image
    if (company.imageUrl) {
      const imagePath = path.join(
        'public',
        company.imageUrl.replace('/images/', 'images/')
      );

      if (fs.existsSync(imagePath)) {
        fs.unlinkSync(imagePath);
      }
    }

    await company.destroy();

    res.status(200).json({
      message: 'Entreprise supprimée avec succès',
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

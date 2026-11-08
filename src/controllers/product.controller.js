import { Category, Currency, Product, ProductSold, Company, BusinessCategory } from '../models/index.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import { Op } from 'sequelize';
import path from 'path';
import fs from 'fs';
import { compressImageFile } from '../utils/compressImage.util.js';

// Notifie l'app mobile (temps réel) qu'un "produit aléatoire" (sans entreprise)
// vient d'être ajouté / modifié / supprimé depuis admin-bimnext.
const emitStandaloneProductsUpdated = async () => {
  try {
    const { getIO } = await import('../services/socket.service.js');
    getIO().emit('content:updated', { type: 'products', at: new Date().toISOString() });
  } catch {}
};


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
      standalone,
      businessId,
    } = req.query;

    const isPaginate = paginate.toLowerCase() === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

     const whereClause = {};
    if (companyId) whereClause.companyId = companyId;
    // "Produits aléatoires" : produits non rattachés à une entreprise (companyId = null),
    // affichés dans une section dédiée sur l'accueil de l'app.
    if (standalone === 'true') whereClause.companyId = null;
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
        {
          model: Company, as: 'company', attributes: ['companyId', 'name', 'businessId'],
          // Filtre par secteur (grille "Tous nos produits" de l'accueil) : INNER JOIN
          // uniquement quand businessId est fourni, pour ne pas casser les appels
          // existants (produits standalone sans company, etc.) quand il est absent.
          where: businessId ? { businessId } : undefined,
          required: !!businessId,
          include: [
            { model: BusinessCategory, as: 'category', attributes: ['businessId', 'name'] },
          ],
        },
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
      // companyId est optionnel : un produit sans companyId est un "produit
      // aléatoire", affiché dans sa propre section sans être rattaché à une entreprise.
      // price est optionnel si priceOnRequest est activé ("Prix à discuter").
      const isPriceOnRequest = product.priceOnRequest === true || product.priceOnRequest === 'true';
      if (!product.name || (!product.price && !isPriceOnRequest)) {
        return res.status(400).json({
          message: "Chaque produit doit avoir un name et un price (ou être marqué « Prix à discuter »)",
        });
      }
    }

     const companyIds = [...new Set(products.map(p => p.companyId).filter(Boolean))];
    const existingCompanies = companyIds.length
      ? await Company.findAll({
          where: { companyId: companyIds },
          attributes: ["companyId"]
        })
      : [];

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

    // Sanitize decimal fields: empty strings → null (avoid "Incorrect decimal value")
    const DECIMAL_FIELDS = ['TVA', 'price', 'qty', 'reduction', 'threshold', 'warning'];
    const sanitized = products.map((p) => {
      const s = { ...p };
      for (const field of DECIMAL_FIELDS) {
        if (s[field] === '' || s[field] === undefined) s[field] = null;
      }
      // La colonne `qty` est NOT NULL en base (produits "aléatoires" sans stock suivi) : 0 par défaut.
      if (s.qty === null) s.qty = 0;
      // "Prix à discuter" : la colonne price reste NOT NULL, on stocke 0 et l'app affiche le tag à la place.
      if (s.priceOnRequest === true || s.priceOnRequest === 'true') s.price = s.price || 0;
      return s;
    });

    // Creation en bulk
    const createdProducts = await Product.bulkCreate(sanitized, { validate: true });

    if (createdProducts.some((p) => !p.companyId)) {
      await emitStandaloneProductsUpdated();
    }

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

      await compressImageFile(req.file.path);
      imageUrl = `/images/${req.file.filename}`;
    }

    // Sanitize body: convert empty strings to null for decimal/numeric columns
    // so MySQL doesn't throw "Incorrect decimal value for column 'TVA'"
    const DECIMAL_FIELDS = ['TVA', 'price', 'qty', 'reduction', 'threshold', 'warning'];
    const sanitizedBody = { ...req.body };
    for (const field of DECIMAL_FIELDS) {
      if (sanitizedBody[field] === '' || sanitizedBody[field] === undefined) {
        sanitizedBody[field] = null;
      }
    }
    // Les colonnes `qty` et `price` sont NOT NULL en base : ne jamais envoyer null.
    if (sanitizedBody.qty === null) delete sanitizedBody.qty;
    if (sanitizedBody.price === null) {
      sanitizedBody.priceOnRequest === true || sanitizedBody.priceOnRequest === 'true'
        ? (sanitizedBody.price = 0)
        : delete sanitizedBody.price;
    }

    await product.update({
      ...sanitizedBody,
      imageUrl,
    });

    if (!product.companyId) {
      await emitStandaloneProductsUpdated();
    }

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
    const wasStandalone = !product.companyId;
    try {
      await product.destroy();
    } catch (destroyError) {
      if (destroyError.name === 'SequelizeForeignKeyConstraintError') {
        return res.status(409).json({
          message: "Ce produit a déjà des commandes associées et ne peut pas être supprimé. Vous pouvez le modifier pour le retirer du catalogue.",
        });
      }
      throw destroyError;
    }
    if (wasStandalone) {
      await emitStandaloneProductsUpdated();
    }

    res.status(200).json({ message: 'Product and its image deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ── Galerie d'images (en plus de l'image de couverture) ─────────────────────

export const addProductImages = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findByPk(id);
    if (!product) return res.status(404).json({ message: 'Product not found' });

    const files = req.files || [];
    if (files.length === 0) {
      return res.status(400).json({ message: 'Aucune image envoyée' });
    }

    await Promise.all(files.map((f) => compressImageFile(f.path)));
    const newUrls = files.map((f) => `/images/${f.filename}`);

    const existing = Array.isArray(product.images) ? product.images : [];
    const images = [...existing, ...newUrls];
    await product.update({ images });

    if (!product.companyId) await emitStandaloneProductsUpdated();

    return res.status(200).json({ message: 'Images ajoutées', data: product });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

export const removeProductImage = async (req, res) => {
  try {
    const { id } = req.params;
    const { url } = req.body;
    const product = await Product.findByPk(id);
    if (!product) return res.status(404).json({ message: 'Product not found' });

    const existing = Array.isArray(product.images) ? product.images : [];
    const images = existing.filter((u) => u !== url);
    await product.update({ images });

    if (url) {
      const imagePath = path.join('public', url.replace('/images/', 'images/'));
      if (fs.existsSync(imagePath)) fs.unlinkSync(imagePath);
    }

    if (!product.companyId) await emitStandaloneProductsUpdated();

    return res.status(200).json({ message: 'Image retirée', data: product });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};


/* ────────────────────────────────────────────────────────────────────────
 * Catalogue BIM NEXT — uniquement EAU, GAZ et CARBURANT
 * GET /product/bim-catalogue?type=eau|gaz|carburant&search=
 *
 * Un produit appartient à un type si :
 *   - le secteur (BusinessCategory) de son entreprise contient le mot-clé, ou
 *   - une de ses catégories produit contient le mot-clé, ou
 *   - (eau uniquement) son nom contient « eau », « bonbonne » ou « sachet ».
 * Chaque produit revient avec `sub` (sous-catégorie affichée en puce),
 * `effectivePrice` (prix après réduction) et `type`.
 * ──────────────────────────────────────────────────────────────────────── */
const BIM_TYPES = {
  eau:       { sector: ['eau'],                 category: ['eau', 'bonbonne', 'sachet'], name: ['eau', 'bonbonne', 'sachet'] },
  gaz:       { sector: ['gaz'],                 category: ['gaz', 'bouteille', 'détendeur', 'detendeur'], name: [] },
  carburant: { sector: ['carburant', 'essence'], category: ['carburant', 'essence', 'gasoil', 'diesel', 'bidon'], name: [] },
};

const norm = (v) => String(v || '').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
const hasAny = (text, words) => { const t = norm(text); return words.some((w) => t.includes(norm(w))); };

export const classifyBimProduct = (p) => {
  const sectorName = p.company?.category?.name || '';
  const cats = (p.categories || []).map((c) => c.name);
  for (const [type, rule] of Object.entries(BIM_TYPES)) {
    if (hasAny(sectorName, rule.sector)) return type;
  }
  for (const [type, rule] of Object.entries(BIM_TYPES)) {
    if (cats.some((c) => hasAny(c, rule.category))) return type;
  }
  for (const [type, rule] of Object.entries(BIM_TYPES)) {
    if (rule.name.length && hasAny(p.name, rule.name)) return type;
  }
  return null;
};

export const getBimCatalogue = async (req, res) => {
  try {
    const type = norm(req.query.type || '');
    const search = String(req.query.search || '').trim();
    if (type && !BIM_TYPES[type]) {
      return res.status(400).json({ message: 'Type inconnu. Utilisez eau, gaz ou carburant.' });
    }

    const where = {};
    if (search) {
      where[Op.or] = [
        { name: { [Op.like]: `%${search}%` } },
        { description: { [Op.like]: `%${search}%` } },
      ];
    }

    const rows = await Product.findAll({
      where,
      order: [['price', 'ASC']],
      include: [
        { model: Currency, as: 'currency' },
        { model: Category, as: 'categories', through: { attributes: [] } },
        {
          model: Company, as: 'company', attributes: ['companyId', 'name', 'businessId', 'logo'], required: false,
          include: [{ model: BusinessCategory, as: 'category', attributes: ['businessId', 'name'] }],
        },
      ],
    });

    const items = [];
    for (const row of rows) {
      const p = row.toJSON();
      const t = classifyBimProduct(p);
      if (!t || (type && t !== type)) continue;
      if (String(p.availability || '').toLowerCase() === 'indisponible') continue;
      const price = parseFloat(p.price || 0);
      const pct = parseFloat(p.reduction || 0);
      const effectivePrice = pct > 0 && pct <= 100 ? +(price * (1 - pct / 100)).toFixed(2) : price;
      const sectorWords = (BIM_TYPES[t].sector || []);
      // Sous-catégorie : première catégorie produit qui n'est pas juste le nom du type.
      const sub = (p.categories || []).map((c) => c.name).find((n) => !sectorWords.some((w) => norm(n) === norm(w))) || null;
      items.push({ ...p, type: t, sub, effectivePrice });
    }

    const subs = [...new Set(items.map((i) => i.sub).filter(Boolean))];

    return res.status(200).json({ data: items, total: items.length, subs, type: type || null });
  } catch (error) {
    return res.status(500).json({ message: 'Erreur lors de la récupération du catalogue', error: error.message });
  }
};

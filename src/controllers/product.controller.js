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

// Type du catalogue : eau / gaz / carburant, ou null (= « autres produits »).
export const classifyBimProduct = (p) => {
  // Catégorie choisie explicitement dans l'admin : prioritaire.
  if (p.bimType === 'autres') return null;
  if (p.bimType && BIM_TYPES[p.bimType]) return p.bimType;
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
    if (type && !BIM_TYPES[type] && type !== 'autres') {
      return res.status(400).json({ message: 'Type inconnu. Utilisez eau, gaz, carburant ou autres.' });
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
      // « autres » : tout produit qui n'est ni eau, ni gaz, ni carburant.
      const t = classifyBimProduct(p) || 'autres';
      if (type ? t !== type : t === 'autres') continue; // sans type : eau/gaz/carburant comme avant
      if (String(p.availability || '').toLowerCase() === 'indisponible') continue;
      const effectivePrice = effectivePriceOf(p);
      // Commandable seulement avec un vrai prix (pas de « prix à discuter »).
      if (p.priceOnRequest || !(effectivePrice > 0)) continue;

      let sub;
      if (t === 'autres') {
        // Catégorie affichée : saisie admin, sinon catégorie produit, sinon
        // secteur de l'entreprise (sans le préfixe « BIM »), sinon « Divers ».
        const sector = String(p.company?.category?.name || '').replace(/^bim\s+/i, '').trim();
        sub = (p.bimSub && String(p.bimSub).trim()) || p.categories?.[0]?.name || sector || 'Divers';
      } else {
        const sectorWords = (BIM_TYPES[t].sector || []);
        // Sous-catégorie : celle saisie dans l'admin, sinon la première catégorie
        // produit qui n'est pas juste le nom du type.
        sub = (p.bimSub && String(p.bimSub).trim())
          || (p.categories || []).map((c) => c.name).find((n) => !sectorWords.some((w) => norm(n) === norm(w)))
          || null;
      }
      items.push({ ...p, type: t, sub, effectivePrice });
    }

    const subs = [...new Set(items.map((i) => i.sub).filter(Boolean))];

    return res.status(200).json({ data: items, total: items.length, subs, type: type || null });
  } catch (error) {
    return res.status(500).json({ message: 'Erreur lors de la récupération du catalogue', error: error.message });
  }
};

/** Prix payé par le client : prix catalogue moins la réduction (%), arrondi au centime. */
export function effectivePriceOf(p) {
  const price = parseFloat(p?.price || 0);
  const pct = parseFloat(p?.reduction || 0);
  return pct > 0 && pct <= 100 ? +(price * (1 - pct / 100)).toFixed(2) : +price.toFixed(2);
}

/* ────────────────────────────────────────────────────────────────────────
 * Administration du catalogue BIM NEXT (admin-bim, rôle BIM uniquement)
 *   GET    /product/bim-admin?type=&search=   → produits eau/gaz/carburant (même indisponibles)
 *   POST   /product/bim-admin                 → créer (multipart : champs + image)
 *   PUT    /product/bim-admin/:id             → modifier (multipart : champs + image facultative)
 *   DELETE /product/delete/:id                → supprimer (route existante)
 * Un produit sans entreprise est vendu par BIM NEXT : le paiement en EC va au
 * compte BIM (voir prepayOrder), et la commande est visible par les livreurs BIM.
 * ──────────────────────────────────────────────────────────────────────── */
const AVAILABLE = 'disponible';
const UNAVAILABLE = 'indisponible';

const removeUploaded = (file) => {
  if (file?.path && fs.existsSync(file.path)) { try { fs.unlinkSync(file.path); } catch { /* ignore */ } }
};

// Lit et valide les champs du formulaire admin (multipart → chaînes).
// `partial` : en modification, seuls les champs présents sont changés.
const readBimFields = async (body, { partial }) => {
  const out = {};
  const has = (k) => body[k] !== undefined;
  const str = (k) => String(body[k] ?? '').trim();

  if (!partial || has('name')) {
    if (!str('name')) return { error: 'Le titre du produit est obligatoire.' };
    out.name = str('name').slice(0, 200);
  }
  if (!partial || has('bimType')) {
    const t = norm(body.bimType);
    if (!BIM_TYPES[t] && t !== 'autres') return { error: 'Catégorie invalide : choisissez eau, gaz, carburant ou autres.' };
    out.bimType = t;
  }
  if (!partial || has('price')) {
    const price = Number(String(body.price ?? '').replace(',', '.'));
    if (!Number.isFinite(price) || price <= 0) return { error: 'Le prix doit être un nombre supérieur à 0.' };
    out.price = +price.toFixed(2);
  }
  if (has('reduction')) {
    if (str('reduction') === '') out.reduction = null;
    else {
      const r = Number(body.reduction);
      if (!Number.isInteger(r) || r < 0 || r > 100) return { error: 'La réduction doit être un entier entre 0 et 100.' };
      out.reduction = r;
    }
  }
  if (has('description')) out.description = str('description') || null;
  if (has('bimSub')) out.bimSub = str('bimSub').slice(0, 100) || null;
  if (has('unityMesure')) out.unityMesure = str('unityMesure') || null;
  if (has('warning')) out.Warning = str('warning').slice(0, 400) || null;
  if (has('available')) out.availability = (body.available === true || body.available === 'true') ? AVAILABLE : UNAVAILABLE;
  if (has('currencyId')) {
    out.currencyId = str('currencyId') ? Number(body.currencyId) : null;
    if (out.currencyId !== null) {
      if (!Number.isInteger(out.currencyId)) return { error: 'Devise invalide.' };
      if (!(await Currency.findByPk(out.currencyId))) return { error: "Cette devise n'existe pas." };
    }
  }
  if (has('companyId')) {
    out.companyId = str('companyId') ? Number(body.companyId) : null;
    if (out.companyId !== null) {
      if (!Number.isInteger(out.companyId)) return { error: 'Entreprise invalide.' };
      if (!(await Company.findByPk(out.companyId))) return { error: "Cette entreprise n'existe pas." };
    }
  }
  return { fields: out };
};

const BIM_INCLUDE = [
  { model: Currency, as: 'currency' },
  { model: Category, as: 'categories', through: { attributes: [] } },
  {
    model: Company, as: 'company', attributes: ['companyId', 'name', 'businessId', 'logo'], required: false,
    include: [{ model: BusinessCategory, as: 'category', attributes: ['businessId', 'name'] }],
  },
];

const toBimItem = (row) => {
  const p = row.toJSON ? row.toJSON() : row;
  return {
    ...p,
    type: p.bimType === 'autres' ? 'autres' : classifyBimProduct(p),
    sub: p.bimSub || null,
    effectivePrice: effectivePriceOf(p),
    available: String(p.availability || '').toLowerCase() !== UNAVAILABLE,
  };
};

export const getBimAdminProducts = async (req, res) => {
  try {
    const type = norm(req.query.type || '');
    if (type && !BIM_TYPES[type] && type !== 'autres') return res.status(400).json({ message: 'Type inconnu. Utilisez eau, gaz, carburant ou autres.' });
    const search = String(req.query.search || '').trim();
    const where = search ? { [Op.or]: [{ name: { [Op.like]: `%${search}%` } }, { description: { [Op.like]: `%${search}%` } }] } : {};
    const rows = await Product.findAll({ where, include: BIM_INCLUDE, order: [['createdAt', 'DESC']] });
    const all = rows.map(toBimItem).filter((p) => p.type);
    const counts = { eau: 0, gaz: 0, carburant: 0, autres: 0 };
    all.forEach((p) => { counts[p.type] += 1; });
    const items = type ? all.filter((p) => p.type === type) : all;
    return res.status(200).json({ data: items, total: items.length, counts });
  } catch (error) {
    return res.status(500).json({ message: 'Erreur lors de la récupération du catalogue', error: error.message });
  }
};

export const createBimProduct = async (req, res) => {
  try {
    const { error, fields } = await readBimFields(req.body, { partial: false });
    if (error) { removeUploaded(req.file); return res.status(400).json({ message: error }); }

    const duplicate = await Product.findOne({ where: { name: fields.name, bimType: fields.bimType, companyId: fields.companyId ?? null } });
    if (duplicate) { removeUploaded(req.file); return res.status(409).json({ message: 'Un produit avec ce titre existe déjà dans cette catégorie.' }); }

    let imageUrl = null;
    if (req.file) {
      await compressImageFile(req.file.path);
      imageUrl = `/images/${req.file.filename}`;
    }

    const product = await Product.create({ availability: AVAILABLE, qty: 0, ...fields, imageUrl });

    await emitStandaloneProductsUpdated();
    const full = await Product.findByPk(product.productId, { include: BIM_INCLUDE });
    return res.status(201).json({ message: 'Produit créé', data: toBimItem(full) });
  } catch (error) {
    removeUploaded(req.file);
    return res.status(500).json({ message: 'Erreur lors de la création du produit', error: error.message });
  }
};

export const updateBimProduct = async (req, res) => {
  try {
    const product = await Product.findByPk(req.params.id);
    if (!product) { removeUploaded(req.file); return res.status(404).json({ message: 'Produit introuvable' }); }

    const { error, fields } = await readBimFields(req.body, { partial: true });
    if (error) { removeUploaded(req.file); return res.status(400).json({ message: error }); }

    if (req.file) {
      await compressImageFile(req.file.path);
      if (product.imageUrl && product.imageUrl.startsWith('/images/')) {
        const old = path.join('public', product.imageUrl.replace('/images/', 'images/'));
        if (fs.existsSync(old)) { try { fs.unlinkSync(old); } catch { /* ignore */ } }
      }
      fields.imageUrl = `/images/${req.file.filename}`;
    }

    await product.update(fields);
    await emitStandaloneProductsUpdated();
    const full = await Product.findByPk(product.productId, { include: BIM_INCLUDE });
    return res.status(200).json({ message: 'Produit modifié', data: toBimItem(full) });
  } catch (error) {
    removeUploaded(req.file);
    return res.status(500).json({ message: 'Erreur lors de la modification du produit', error: error.message });
  }
};

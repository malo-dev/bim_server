import { Favorite, Product, Company, BusinessCategory } from "../models/index.js";

// GET /favorite — list user's favorites
export const getUserFavorites = async (req, res) => {
  try {
    const userId = req.user?.id || req.user?.userId;
    const rows = await Favorite.findAll({
      where: { userId },
      include: [{
        model: Product, as: "product",
        include: [{ model: Company, as: "company", attributes: ["companyId","name","businessId"],
          include: [{ model: BusinessCategory, as: "category", attributes: ["businessId","name"] }]
        }]
      }],
      order: [["createdAt", "DESC"]],
    });
    return res.json({ data: rows.map(r => r.product), total: rows.length });
  } catch (e) { return res.status(500).json({ message: e.message }); }
};

// POST /favorite/toggle — add or remove (returns { favorited: true/false })
export const toggleFavorite = async (req, res) => {
  try {
    const userId    = req.user?.id || req.user?.userId;
    const { productId } = req.body;
    if (!productId) return res.status(400).json({ message: "productId required" });
    const existing = await Favorite.findOne({ where: { userId, productId } });
    if (existing) {
      await existing.destroy();
      return res.json({ favorited: false });
    }
    await Favorite.create({ userId, productId });
    return res.json({ favorited: true });
  } catch (e) { return res.status(500).json({ message: e.message }); }
};

// GET /favorite/ids — returns array of productIds the user has favorited
export const getFavoriteIds = async (req, res) => {
  try {
    const userId = req.user?.id || req.user?.userId;
    const rows = await Favorite.findAll({ where: { userId }, attributes: ["productId"] });
    return res.json({ data: rows.map(r => r.productId) });
  } catch (e) { return res.status(500).json({ message: e.message }); }
};

import { Product, ProductConsumption, Notification, User } from '../models/index.js';
import { emitToUser } from './socket.service.js';

const LOYALTY_THRESHOLD = 10; // 10 achats payants d'un même produit → le 11ème est offert

/**
 * Enregistre la "fiche de consommation" d'un achat (ligne de commande non-bonus),
 * puis déclenche automatiquement un produit offert dès que l'utilisateur atteint
 * un multiple de 10 achats de ce même produit.
 */
export async function recordConsumptionAndMaybeGrantBonus(order) {
  const { userId, productId, companyId, quantity, unitPrice, orderId } = order;

  const [user, product] = await Promise.all([
    User.findByPk(userId, { attributes: ['id', 'username', 'expoPushToken'] }),
    Product.findByPk(productId),
  ]);

  await ProductConsumption.create({
    userId,
    productId,
    orderId,
    companyId: companyId || product?.companyId || null,
    quantity,
    unityMesure: product?.unityMesure || null,
    unitPrice,
    totalPaid: parseFloat((Number(quantity) * Number(unitPrice)).toFixed(2)),
    signatureName: user?.username || null,
    isBonus: false,
  });

  const count = await ProductConsumption.count({ where: { userId, productId, isBonus: false } });

  if (count > 0 && count % LOYALTY_THRESHOLD === 0) {
    await grantLoyaltyBonus({ user, product, userId, productId, companyId: companyId || product?.companyId || null });
  }
}

async function grantLoyaltyBonus({ user, product, userId, productId, companyId }) {
  // Import différé pour éviter une dépendance circulaire avec order.controller.js
  const { Order } = await import('../models/index.js');

  const bonusOrderNumber = `BONUS-${Date.now()}-${userId}`;
  const bonusOrder = await Order.create({
    orderNumber: bonusOrderNumber,
    userId,
    companyId,
    productId,
    quantity: 1,
    unitPrice: 0,
    totalAmount: 0,
    status: 'pending',
    paymentMethod: 'bonus',
    notes: `Bonus fidélité : "${product?.name ?? 'produit'}" offert après ${LOYALTY_THRESHOLD} achats.`,
  });

  await ProductConsumption.create({
    userId,
    productId,
    orderId: bonusOrder.orderId,
    companyId,
    quantity: 1,
    unityMesure: product?.unityMesure || null,
    unitPrice: 0,
    totalPaid: 0,
    signatureName: user?.username || null,
    isBonus: true,
  });

  // Le produit offert est prélevé du stock, comme un article normal.
  if (product && product.qty !== null && product.qty !== undefined) {
    const newQty = Math.max(0, parseFloat(product.qty) - 1);
    await product.update({ qty: newQty });
  }

  const productName = product?.name ?? 'un produit';

  try {
    await Notification.create({
      title: '🎁 Produit offert !',
      message: `Bravo ! Après ${LOYALTY_THRESHOLD} achats de "${productName}", celui-ci vous est offert. Ouvrez l'app pour confirmer votre adresse de livraison.`,
      type: 'SUCCESS',
      userId,
    });
  } catch {}

  try {
    if (user?.expoPushToken) {
      const { sendPushNotification } = await import('./pushNotification.service.js');
      await sendPushNotification(
        user.expoPushToken,
        '🎁 Bonus fidélité',
        `Vous avez reçu "${productName}" gratuitement ! Confirmez votre livraison dans « Mes commandes ».`
      );
    }
  } catch {}

  try {
    emitToUser(userId, 'loyalty:bonus_granted', {
      productId,
      productName,
      orderNumber: bonusOrderNumber,
    });
  } catch {}

  return bonusOrder;
}

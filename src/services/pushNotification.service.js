import { Expo } from 'expo-server-sdk';
import { Op } from 'sequelize';
import { User } from '../models/index.js';

const expo = new Expo();

/**
 * Envoie une notification push à un appareil.
 *
 * - `channelId: 'default'` : canal Android créé par l'app (sans lui, certains
 *   Android rangent la notification sans bannière ni son).
 * - `priority: 'high'` : livraison immédiate même si le téléphone est en veille.
 * - Les erreurs renvoyées par Expo (tickets) sont journalisées ; un jeton
 *   « DeviceNotRegistered » (app désinstallée) est retiré de la base.
 *
 * @param {string} expoPushToken
 * @param {string} title
 * @param {string} message
 * @param {object} [data]
 */
export const sendPushNotification = async (expoPushToken, title, message, data = {}) => {
  if (!Expo.isExpoPushToken(expoPushToken)) {
    console.error(`[push] Token invalide: ${expoPushToken}`);
    return;
  }

  const messages = [{
    to: expoPushToken,
    sound: 'default',
    title,
    body: message,
    data,
    channelId: 'default',
    priority: 'high',
  }];

  for (const chunk of expo.chunkPushNotifications(messages)) {
    try {
      const tickets = await expo.sendPushNotificationsAsync(chunk);
      tickets.forEach((t) => {
        if (t.status !== 'error') return;
        console.error(`[push] Échec pour ${expoPushToken}: ${t.message} (${t.details?.error ?? 'inconnu'})`);
        if (t.details?.error === 'DeviceNotRegistered') {
          User.update({ expoPushToken: null }, { where: { expoPushToken } }).catch(() => {});
        }
      });
    } catch (error) {
      console.error('[push] Erreur d\'envoi Expo:', error.message);
    }
  }
};

/** Push vers un compte (cherche son jeton). Ne lève jamais d'erreur. */
export const pushToUser = async (userId, title, message, data = {}) => {
  try {
    if (!userId) return;
    const user = await User.findByPk(userId, { attributes: ['id', 'expoPushToken'] });
    if (user?.expoPushToken) await sendPushNotification(user.expoPushToken, title, message, data);
  } catch (error) {
    console.error('[push] pushToUser:', error.message);
  }
};

/** Un jeton = un téléphone : on le retire des autres comptes connectés avant sur ce même téléphone. */
export const claimPushToken = async (userId, expoPushToken) => {
  await User.update(
    { expoPushToken: null },
    { where: { expoPushToken, id: { [Op.ne]: userId } } }
  );
};

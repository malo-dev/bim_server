import { Expo } from 'expo-server-sdk';

// Crée une instance de Expo
let expo = new Expo();

/**
 * Envoie une notification push à un utilisateur
 * @param {string} expoPushToken - Le token Expo Push du device
 * @param {string} title - Le titre de la notification
 * @param {string} message - Le contenu de la notification
 */
export const sendPushNotification = async (expoPushToken, title, message) => {
  const messages = [];

  if (!Expo.isExpoPushToken(expoPushToken)) {
    console.error(`Token invalide: ${expoPushToken}`);
    return;
  }

  messages.push({
    to: expoPushToken,
    sound: 'default',
    title,
    body: message,
    data: { withSome: 'data' },
  });

  const chunks = expo.chunkPushNotifications(messages);
  for (let chunk of chunks) {
    try {
      await expo.sendPushNotificationsAsync(chunk);
    } catch (error) {
      console.error(error);
    }
  }
};

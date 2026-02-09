import {History,Notification} from '../models/index.js'

export const logHistory = async ({ type, description, userId, action }) => {
  try {
    await History.create({
      type,
      description,
      id:userId,
      action,
    });
  } catch (err) {
    console.error("History log failed:", err.message);
  }
};

export const pushNotification = async ({ title, message, type, userId }) => {
  try {
    await Notification.create({
      title,
      message,
      type,
      id:userId,
    });
  } catch (err) {
    console.error("Notification failed:", err.message);
  }
};

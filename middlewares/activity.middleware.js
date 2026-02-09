import {History,Notification} from '../src/models/index.js'

const getActionFromMethod = (method) => {
  switch (method) {
    case "POST":
      return "Création";
    case "GET":
      return "Consultation";
    case "PUT":
    case "PATCH":
      return "Mise à jour";
    case "DELETE":
      return "Suppression";
    default:
      return "Action";
  }
};

const getResourceFromUrl = (url) => {
  const parts = url.split("/").filter(Boolean);
  return parts[parts.length - 1];
};

const activityMiddleware = async (req, res, next) => {

  res.on("finish", async () => {

    if (!req.user) return;

    const status = res.statusCode;
    const isSuccess = status >= 200 && status < 300;

    const action = getActionFromMethod(req.method);
    const resource = getResourceFromUrl(req.originalUrl);

    const finalAction = `${action} ${resource}`;

    const historyData = {
      type: resource,
      description: isSuccess
        ? `${finalAction} effectuée avec succès.`
        : `Échec lors de ${finalAction.toLowerCase()}.`,
      userId: req.user.id,
      action: isSuccess ? `${finalAction} ✅` : `${finalAction} ❌`,
    };

    const notificationData = {
      title: isSuccess ? "Opération réussie" : "Erreur",
      message: historyData.description,
      type: isSuccess ? "SUCCESS" : "ERREUR",
      userId: req.user.id,
    };

    try {
      await History.create(historyData);
      await Notification.create(notificationData);
    } catch (err) {
      console.error("Activity middleware error:", err.message);
    }

  });

  next();
};

export default activityMiddleware;

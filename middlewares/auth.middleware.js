import jwt from "jsonwebtoken";
import User from "../src/models/User.model.js";
import dotenv from "dotenv";
import {History,Notification} from '../src/models/index.js'
dotenv.config();

const getActionFromMethod = (method) => {
  switch (method) {
    case "POST":
      return "Création";
    case "GET":
      return "Consultation";
    case "PUT":
      return "Mise à jour";
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

const authMiddleware = async (req, res, next) => {

  // 👇 Écoute la réponse finale
  res.on("finish", async () => {

    if (!req.user) return;

    const status = res.statusCode;
    const isSuccess = status >= 200 && status < 300;

    const action = getActionFromMethod(req.method);
    const resource = getResourceFromUrl(req.originalUrl);

    const label = `${action} ${resource}`;

    try {
      await History.create({
        type: resource,
        description: isSuccess
          ? `${label} effectuée avec succès.`
          : `Échec lors de ${label.toLowerCase()}.`,
        id: req.user.id,
        action: isSuccess ? `${label} ✅` : `${label} ❌`,
      });

      await Notification.create({
        title: isSuccess ? "Opération réussie" : "Erreur",
        message: isSuccess
          ? `${label} effectuée avec succès.`
          : `Une erreur est survenue lors de ${label.toLowerCase()}.`,
        type: isSuccess ? "SUCCESS" : "ERREUR",
        id: req.user.id,
      });

    } catch (err) {
      console.error("Log error:", err.message);
    }
  });

  // -----------------------
  // AUTHENTIFICATION
  // -----------------------

  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ message: "Unauthorized: No token provided" });
  }

  const token = authHeader.split(" ")[1];

  try {
    // eslint-disable-next-line no-undef
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    const user = await User.findByPk(decoded.userId);
    if (!user) {
      return res.status(401).json({ message: "Unauthorized: User not found" });
    }

    if (!user.isActive) {
      return res.status(409).json({
        message: "This process cannot be completed because your account is not yet activated.",
      });
    }

    req.user = user;
    next();

  } catch (error) {

    if (error.name === "TokenExpiredError") {
      return res.status(401).json({ message: "BEARER_TOKEN_EXPIRED" });
    }

    return res.status(401).json({ message: "Unauthorized: Invalid token" });
  }
};

export default authMiddleware;

/* eslint-disable no-undef */
import jwt       from 'jsonwebtoken';
import axios     from 'axios';
import { Op }    from 'sequelize';
import { User, Notification, Transaction, History, TransactionRecharge } from '../models/index.js';
import { generateSupportReceivedEmailTemplateRecharge } from '../utils/templateMails.util.js';
import { generateReferenceRecharge } from '../utils/generateReferenceSecond.js';
import nodemailer from 'nodemailer';
import sequelize  from '../config/database.js';

/* ─── CONFIG ────────────────────────────────────────────────────────── */
const FRAIS_ABONNEMENT = 1;
const OWNER_EMAIL      = 'bimbank@bimreseau.com';

const PAY_TYPE_MAP = {
  AirtelMoney: 1,
  "M-Pesa":    2,
  OrangeMoney: 3,
  AfriMoney:   52,
};

/* ─── Helper token ──────────────────────────────────────────────────── */
const isTokenValid = (token) => {
  if (!token) return false;
  try {
    jwt.verify(token, process.env.JWT_SECRET);
    return true;
  } catch {
    return false;
  }
};


export const recharge = async (req, res) => {
  let amount          = 0;
  let ownerItem       = null;
  let userItem        = null;
  let rechargeRecord  = null;

  try {
    const { amount: bodyAmount, userId, telephone, PayTypeValue } = req.body;
    amount = Number(bodyAmount);

    /* ── 1. Validation ── */
    if (!userId) {
      return res.status(400).json({ message: "userId est obligatoire" });
    }
    if (!telephone) {
      return res.status(400).json({ message: "telephone est obligatoire" });
    }
    if (!bodyAmount || isNaN(amount) || amount <= 0) {
      return res.status(400).json({ message: "Montant invalide" });
    }

    const payType = PAY_TYPE_MAP[String(PayTypeValue)];
    if (!payType) {
      return res.status(400).json({ message: "Type de paiement invalide" });
    }

    /* ── 2. Récupérer l'utilisateur ── */
    userItem = await User.findByPk(userId);
    if (!userItem) {
      return res.status(404).json({ message: "Utilisateur introuvable" });
    }

    /* ── 3. Limite recharges par jour ── */
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);

    const rechargeCountToday = await TransactionRecharge.count({
      where: { id: userId, createdAt: { [Op.gte]: startOfDay } },
    });

    if (rechargeCountToday >= userItem.maxRechargeParJour) {
      return res.status(400).json({
        message: `Vous avez atteint le nombre maximum de recharges aujourd'hui (${userItem.maxRechargeParJour}). Réessayez demain.`,
      });
    }

    /* ── 4. Calcul montant MaxiCash ── */
    const rechargeAmount = Math.round(amount * 10);
    const reference      = generateReferenceRecharge();

    /* ── 5. Créer TransactionRecharge en attente ── */
    rechargeRecord = await TransactionRecharge.create({
      amount:    rechargeAmount,
      telephone,
      reference,
      id:        userId,
      status:    "pending",
    });

    /* ── 6. Appel MaxiCash ── */
    const payload = {
      RequestData: {
        Amount:    rechargeAmount * 10,
        Reference: String(reference),
        Telephone: String(telephone),
      },
      MerchantID:       process.env.MAXICASH_MERCHANT_ID,
      MerchantPassword: process.env.MAXICASH_MERCHANT_PASSWORD,
      PayType:          payType,
      CurrencyCode:     "USD",
    };

    console.log("[recharge] Payload MaxiCash 👉", payload);

    const maxiResponse = await axios.post(
      "https://webapi.maxicashapp.com/Integration/PayNowSync",
      payload,
      { headers: { "Content-Type": "application/json" } }
    );

    const maxiData = maxiResponse.data;
    console.log("[recharge] Réponse MaxiCash 👉", maxiData);

    /* ── 7. Vérifier succès MaxiCash ── */
    if (maxiData?.ResponseCode !== "00" && maxiData?.ResponseStatus !== "Success") {
      await rechargeRecord.update({ status: "failed" });
      return res.status(400).json({
        message: "Paiement MaxiCash échoué",
        details: maxiData?.ResponseMessage || maxiData?.Status || "Erreur inconnue",
        status:  "failed",
      });
    }

    await rechargeRecord.update({ status: "success" });

    /* ════════════════════════════════════════════════════════════════
       MaxiCash OK → on crédite le compte BIM dans une transaction SQL
       ════════════════════════════════════════════════════════════════ */
    const t = await sequelize.transaction();

    try {
      /* ── 8. Verrouiller l'utilisateur ── */
      userItem = await User.findOne({
        where:       { id: userId },
        transaction: t,
        lock:        t.LOCK.UPDATE,
      });

      /* ── 9. Vérifier abonnement ── */
      const previousRecharge = Number(userItem.nRecharge) || 0;
      const aDejaAbonnement  = previousRecharge > 0 && isTokenValid(userItem.TokenAbonemment);

      /* ── 10. Calcul montant crédité ── */
      let fraisAbonnement = 0;
      let montantCredite  = amount;

      if (!aDejaAbonnement) {
        if (amount <= FRAIS_ABONNEMENT) {
          await t.rollback();
          return res.status(400).json({
            message: `Le montant minimum est de ${FRAIS_ABONNEMENT + 0.01} EC (dont ${FRAIS_ABONNEMENT} EC d'abonnement annuel)`,
          });
        }

        fraisAbonnement = FRAIS_ABONNEMENT;
        montantCredite  = amount - fraisAbonnement;

        ownerItem = await User.findOne({
          where:       { email: OWNER_EMAIL },
          transaction: t,
          lock:        t.LOCK.UPDATE,
        });
        if (ownerItem) {
          await ownerItem.update(
            { soldNumber: (Number(ownerItem.soldNumber) || 0) + fraisAbonnement },
            { transaction: t }
          );
        }

        userItem.TokenAbonemment = jwt.sign(
          { userId: userItem.id, type: "ABONNEMENT" },
          process.env.JWT_SECRET,
          { expiresIn: "1y" }
        );
      }

      /* ── 11. Créditer solde ── */
      const ancienSolde   = Number(userItem.soldNumber) || 0;
      userItem.soldNumber  = ancienSolde + montantCredite;
      userItem.nRecharge   = previousRecharge + 1;

      await userItem.save({ transaction: t });

      /* ── 12. Transaction générique ── */
      await Transaction.create(
        {
          amount:          montantCredite,
          status:          "réussi",
          description:     aDejaAbonnement
            ? `Recharge de ${montantCredite} EC — aucun frais`
            : `Recharge de ${montantCredite} EC — abonnement activé (-${fraisAbonnement} EC)`,
          transactionType: "recharge",
          id:              userItem.id,
        },
        { transaction: t }
      );

      /* ── 13. Notification ── */
      await Notification.create(
        {
          title:   "Recharge réussie ✅",
          message: aDejaAbonnement
            ? `Votre compte a été crédité de ${montantCredite} EC. Aucun frais prélevé.`
            : `Votre compte a été crédité de ${montantCredite} EC — abonnement annuel activé (-${fraisAbonnement} EC).`,
          type:    "SUCCESS",
          userId:  userItem.id,
        },
        { transaction: t }
      );

      /* ── 14. Historique ── */
      await History.create(
        {
          type:        "Recharge",
          amount:      montantCredite,
          status:      "réussi",
          description: aDejaAbonnement
            ? `Recharge de ${montantCredite} EC`
            : `Recharge de ${montantCredite} EC + activation abonnement`,
          action:      "Recharge EC ✅",
          userId:      userItem.id,
        },
        { transaction: t }
      );

      /* ── 15. COMMIT ── */
      await t.commit();

      /* ── 16. Réponse ── */
      res.status(200).json({
        message: "Recharge effectuée avec succès",
        data: {
          solde:           userItem.soldNumber,
          nRecharge:       userItem.nRecharge,
          fraisAbonnement,
          montantCredite,
          abonnementActif: true,
          reference,
        },
      });

      /* ── 17. Email fire & forget ── */
      try {
        const htmlSuccess = generateSupportReceivedEmailTemplateRecharge({
          username: userItem.username,
          subject:  "Confirmation : recharge de votre compte BIM NEXT",
          amount:   montantCredite,
        });

        const transporter = nodemailer.createTransport({
          host:           "mail.bimreseau.com",
          port:           465,
          secure:         true,
          auth:           { user: "noreply@bimreseau.com", pass: process.env.EMAIL_PASSWORD },
          pool:           true,
          maxConnections: 3,
        });

        const recipients = [userItem.email, ownerItem?.email].filter(Boolean).join(", ");

        await transporter.sendMail({
          from:    "noreply@bimreseau.com",
          to:      recipients,
          subject: `Recharge de ${amount} EC effectuée le ${new Date().toLocaleDateString()} à ${new Date().toLocaleTimeString()}`,
          html:    htmlSuccess,
        });
      } catch (emailError) {
        console.error("[recharge] Erreur email (non critique) :", emailError.message);
      }

    } catch (error) {
      try { await t.rollback(); } catch (e) { void e; /* déjà commitée */ }

      console.error("[recharge] Erreur crédit BIM :", error);

      if (userItem) {
        try {
          await Transaction.create({
            amount:          amount || 0,
            status:          "échoué",
            description:     "Recharge échouée (paiement reçu, crédit BIM impossible)",
            transactionType: "recharge",
            id:              userItem.id,
          });
        } catch (e) { console.error("[recharge] Erreur transaction échec :", e.message); }

        try {
          await Notification.create({
            title:   "Échec de la recharge ❌",
            message: `Votre paiement de ${amount} EC a été reçu mais le crédit n'a pas pu être appliqué. Contactez le support.`,
            type:    "ERREUR",
            userId:  userItem.id,
          });
        } catch (e) { console.error("[recharge] Erreur notification échec :", e.message); }

        try {
          await History.create({
            type:        "Recharge",
            amount:      amount || 0,
            status:      "échoué",
            description: "Recharge échouée après paiement MaxiCash",
            action:      "Recharge EC ❌",
            userId:      userItem.id,
          });
        } catch (e) { console.error("[recharge] Erreur history échec :", e.message); }
      }

      if (!res.headersSent) {
        return res.status(500).json({ message: "Erreur serveur lors du crédit", error: error.message });
      }
    }

  } catch (error) {
    console.error("[recharge] Erreur :", error);

    if (rechargeRecord) {
      try { await rechargeRecord.update({ status: "failed" }); } catch (e) { console.error("[recharge] Erreur update rechargeRecord :", e.message); }
    }

    if (userItem) {
      try {
        await Notification.create({
          title:   "Échec de la recharge ❌",
          message: `Votre tentative de recharge de ${amount} EC n'a pas abouti. Veuillez réessayer.`,
          type:    "ERREUR",
          userId:  userItem.id,
        });
      } catch (e) { console.error("[recharge] Erreur notification échec :", e.message); }

      try {
        await History.create({
          type:        "Recharge",
          amount:      amount || 0,
          status:      "échoué",
          description: "Recharge échouée",
          action:      "Recharge EC ❌",
          userId:      userItem.id,
        });
      } catch (e) { console.error("[recharge] Erreur history échec :", e.message); }
    }

    if (!res.headersSent) {
      return res.status(500).json({ message: "Erreur serveur", error: error.message });
    }
  }
};

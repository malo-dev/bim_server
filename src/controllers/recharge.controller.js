/* eslint-disable no-undef */
import jwt       from 'jsonwebtoken';
import axios     from 'axios';
import { Op }    from 'sequelize';
import { User, Notification, Transaction, History, TransactionRecharge } from '../models/index.js';
import { generateSupportReceivedEmailTemplateRecharge } from '../utils/templateMails.util.js';
import { generateReferenceRecharge } from '../utils/generateReferenceSecond.js';
import { emitToUser } from '../services/socket.service.js';
import nodemailer from 'nodemailer';
import sequelize  from '../config/database.js';

/* ─── CONFIG ────────────────────────────────────────────────────────── */
const FRAIS_ABONNEMENT       = 1;
const OWNER_EMAIL            = 'bimbank@bimreseau.com';
const MOBILE_MONEY_PROVIDERS = new Set(['AirtelMoney', 'M-Pesa', 'OrangeMoney', 'AfriMoney']);

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

/* ─── FlexPay : Mobile Money ────────────────────────────────────────── */
const callFlexPayMobile = (phone, reference, amount, currency) =>
  axios.post(
    `${process.env.FLEXPAY_BASE_URL}/api/rest/v1/paymentService`,
    {
      merchant:    process.env.FLEXPAY_MERCHANT,
      type:        "1",
      phone:       String(phone),
      reference:   String(reference),
      amount:      String(amount),
      currency,
      callbackUrl: process.env.FLEXPAY_CALLBACK_URL,
    },
    {
      headers: {
        "Content-Type":  "application/json",
        "Authorization": `Bearer ${process.env.FLEXPAY_TOKEN}`,
      },
    }
  ).then(r => r.data);

/* ─── FlexPay : Vérification transaction ────────────────────────────── */
const checkFlexPayTransaction = async (orderNumber) => {
  const res = await axios.get(
    `${process.env.FLEXPAY_CHECK_URL}/${orderNumber}`,
    {
      headers: { "Authorization": `Bearer ${process.env.FLEXPAY_TOKEN}` },
    }
  );
  return res.data;
};

/* ─── FlexPay : Carte bancaire (v1.1) ───────────────────────────────── */
const callFlexPayCard = async (reference, amount, currency) => {
  const base = process.env.FLEXPAY_CALLBACK_URL.replace("/callback", "");
  return axios.post(
    process.env.FLEXPAY_CARD_URL,
    {
      authorization: `Bearer ${process.env.FLEXPAY_TOKEN}`,
      merchant:      process.env.FLEXPAY_MERCHANT,
      reference:     String(reference),
      amount:        String(amount),
      currency,
      description:   "Recharge compte BIM",
      callback_url:  process.env.FLEXPAY_CALLBACK_URL,
      approve_url:   `${base}/approved/${reference}`,
      cancel_url:    `${base}/cancel/${reference}`,
      decline_url:   `${base}/decline/${reference}`,
    },
    { headers: { "Content-Type": "application/json" } }
  ).then(r => r.data);
};

/* ─── Logique commune de crédit BIM ─────────────────────────────────── */
const creditBim = async (userId, amount, ownerEmailRef) => {
  const t = await sequelize.transaction();
  let ownerItem = null;

  try {
    const userItem = await User.findOne({
      where: { id: userId }, transaction: t, lock: t.LOCK.UPDATE,
    });

    const previousRecharge = Number(userItem.nRecharge) || 0;
    const aDejaAbonnement  = previousRecharge > 0 && isTokenValid(userItem.TokenAbonemment);

    let fraisAbonnement = 0;
    let montantCredite  = amount;

    if (!aDejaAbonnement) {
      if (amount <= FRAIS_ABONNEMENT) {
        await t.rollback();
        return { ok: false, reason: "montant_trop_faible", userItem };
      }

      fraisAbonnement = FRAIS_ABONNEMENT;
      montantCredite  = amount - fraisAbonnement;

      ownerItem = await User.findOne({
        where: { email: ownerEmailRef }, transaction: t, lock: t.LOCK.UPDATE,
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

    const ancienSolde   = Number(userItem.soldNumber) || 0;
    userItem.soldNumber  = ancienSolde + montantCredite;
    userItem.nRecharge   = previousRecharge + 1;
    await userItem.save({ transaction: t });

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

    await t.commit();
    return { ok: true, userItem, ownerItem, montantCredite, fraisAbonnement, aDejaAbonnement };

  } catch (error) {
    try { await t.rollback(); } catch (e) { void e; }
    throw error;
  }
};

/* ─── Envoi email confirmation ──────────────────────────────────────── */
const sendConfirmationEmail = async (userItem, ownerItem, amount, montantCredite) => {
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
};

/* ════════════════════════════════════════════════════════════════════════
   RECHARGE — route principale
   Body : { userId, telephone, amount, PayTypeValue, CurrencyValue }
   PayTypeValue : "AirtelMoney" | "M-Pesa" | "OrangeMoney" | "AfriMoney" | "Card"
   CurrencyValue : "USD" | "CDF"  (défaut USD)
   ════════════════════════════════════════════════════════════════════════ */
export const recharge = async (req, res) => {
  let amount         = 0;
  let userItem       = null;
  let rechargeRecord = null;

  try {
    const { amount: bodyAmount, userId, telephone, PayTypeValue, CurrencyValue } = req.body;
    amount = Number(bodyAmount);

    /* ── 1. Validation ── */
    if (!userId)    return res.status(400).json({ message: "userId est obligatoire" });
    if (!telephone) return res.status(400).json({ message: "telephone est obligatoire" });
    if (!bodyAmount || isNaN(amount) || amount <= 0)
      return res.status(400).json({ message: "Montant invalide" });

    const currency = ["USD", "CDF"].includes(String(CurrencyValue).toUpperCase())
      ? String(CurrencyValue).toUpperCase()
      : "USD";

    const isMobile = MOBILE_MONEY_PROVIDERS.has(String(PayTypeValue));
    const isCard   = String(PayTypeValue) === "Card";

    if (!isMobile && !isCard)
      return res.status(400).json({ message: "Type de paiement invalide (AirtelMoney, M-Pesa, OrangeMoney, AfriMoney, Card)" });

    /* ── 2. Utilisateur ── */
    userItem = await User.findByPk(userId);
    if (!userItem) return res.status(404).json({ message: "Utilisateur introuvable" });

    /* ── 3. Limite quotidienne ── */
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

    const rechargeAmount = Math.round(amount * 10);
    const reference      = generateReferenceRecharge();

    /* ── 4. Enregistrement en attente ── */
    rechargeRecord = await TransactionRecharge.create({
      amount:    rechargeAmount,
      telephone,
      reference,
      id:        userId,
      status:    "pending",
    });

    /* ════════════════════════════════════════════════════════════════
       CARTE BANCAIRE → FlexPay Card V2
       Retourne une URL de redirection ; le crédit se fait via callback
       ════════════════════════════════════════════════════════════════ */
    if (isCard) {
      const cardData = await callFlexPayCard(reference, amount, currency);
      console.log("[recharge] FlexPay Card 👉", cardData);

      if (String(cardData?.code) !== "0") {
        await rechargeRecord.update({ status: "failed" });
        return res.status(400).json({
          message: "Initialisation du paiement carte échouée",
          details: cardData?.message || "Erreur inconnue",
          status:  "failed",
        });
      }

      return res.status(200).json({
        message:     "Redirection vers la page de paiement",
        redirectUrl: cardData.url,
        orderNumber: cardData.orderNumber,
        reference,
      });
    }

    /* ════════════════════════════════════════════════════════════════
       MOBILE MONEY → FlexPay Payment Service
       code=0 = requête envoyée, on attend le callback pour créditer
       ════════════════════════════════════════════════════════════════ */
    const mobileData = await callFlexPayMobile(telephone, reference, amount, currency);
    console.log("[recharge] FlexPay Mobile 👉", mobileData);

    if (String(mobileData?.code) !== "0") {
      await rechargeRecord.update({ status: "failed" });
      return res.status(400).json({
        message: "Paiement FlexPay échoué",
        details: mobileData?.message || "Erreur inconnue",
        status:  "failed",
        data :mobileData
      });
    }

    /* Sauvegarder l'orderNumber pour vérification dans le callback */
    await rechargeRecord.update({ orderNumber: mobileData.orderNumber });

    return res.status(200).json({
      message: "Demande de paiement envoyée — validez le push sur votre téléphone",
      orderNumber: mobileData.orderNumber,
      reference,
      status: "pending",
    });

  } catch (error) {
    console.error("[recharge] Erreur :", error);

    if (rechargeRecord) {
      try { await rechargeRecord.update({ status: "failed" }); } catch (e) { console.error(e.message); }
    }

    if (userItem) {
      try {
        await Notification.create({
          title: "Échec de la recharge ❌",
          message: `Votre tentative de recharge de ${amount} EC n'a pas abouti. Veuillez réessayer.`,
          type: "ERREUR", userId: userItem.id,
        });
      } catch (e) { console.error(e.message); }

      try {
        await History.create({
          type: "Recharge", amount: amount || 0, status: "échoué",
          description: "Recharge échouée", action: "Recharge EC ❌", userId: userItem.id,
        });
      } catch (e) { console.error(e.message); }
    }

    if (!res.headersSent)
      return res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

/* ════════════════════════════════════════════════════════════════════════
   CALLBACK FlexPay — utilisé pour les paiements carte (et confirmation MM)
   FlexPay POST : { code, reference, provider_reference, orderNumber }
   Route suggérée : POST /api/recharge/callback
   ════════════════════════════════════════════════════════════════════════ */
export const flexpayCallback = async (req, res) => {
  try {
    const { code, reference } = req.body;

    console.log("📩 [flexpayCallback] Body reçu :", JSON.stringify(req.body, null, 2));

    const rechargeRecord = await TransactionRecharge.findOne({
      where: { reference, status: "pending" },
    });

    if (!rechargeRecord) {
      console.log("⚠️  [flexpayCallback] Transaction non trouvée ou déjà traitée — ref:", reference);
      return res.status(200).json({ message: "Transaction non trouvée ou déjà traitée" });
    }

    /* ── Callback dit annulation/échec (user a appuyé Annuler sur son tel) ── */
    if (String(code) !== "0") {
      console.log(`❌ [flexpayCallback] Annulé/Échec — code: ${code} — ref: ${reference}`);
      await rechargeRecord.update({ status: "failed" });
      try {
        await Notification.create({
          title: "Recharge annulée ❌",
          message: "Vous avez annulé la recharge. Aucun montant n'a été débité.",
          type: "ERREUR", userId: rechargeRecord.id,
        });
      } catch (e) { console.error(e.message); }
      try {
        await History.create({
          type: "Recharge", amount: rechargeRecord.amount || 0, status: "échoué",
          description: "Recharge annulée par l'utilisateur",
          action: "Recharge EC ❌", userId: rechargeRecord.id,
        });
      } catch (e) { console.error(e.message); }
      emitToUser(rechargeRecord.id, "recharge:cancelled", { reference });
      console.log(`📤 [flexpayCallback] Socket "recharge:cancelled" émis → userId: ${rechargeRecord.id}`);
      return res.status(200).json({ message: "Callback reçu — recharge annulée" });
    }

    /* ── Callback code=0 → FlexPay confirme le paiement → on crédite directement ── */
    console.log(`✅ [flexpayCallback] Succès confirmé — code: ${code} — ref: ${reference}`);
    await rechargeRecord.update({ status: "success" });

    const rawAmount = Math.round(rechargeRecord.amount / 10);

    let creditResult;
    try {
      creditResult = await creditBim(rechargeRecord.id, rawAmount, OWNER_EMAIL);
    } catch (error) {
      console.error("[flexpayCallback] Erreur crédit BIM :", error);
      emitToUser(rechargeRecord.id, "recharge:failed", { reference });
      return res.status(200).json({ message: "Callback reçu — erreur interne crédit" });
    }

    if (creditResult.ok) {
      const { userItem, ownerItem, montantCredite } = creditResult;
      const payload = { montantCredite, solde: userItem.soldNumber, reference };
      console.log(`💰 [flexpayCallback] Compte crédité — userId: ${rechargeRecord.id} — montant: ${montantCredite} EC — nouveau solde: ${userItem.soldNumber}`);
      emitToUser(rechargeRecord.id, "recharge:success", payload);
      console.log(`📤 [flexpayCallback] Socket "recharge:success" émis →`, JSON.stringify(payload, null, 2));
      sendConfirmationEmail(userItem, ownerItem, rawAmount, montantCredite);
    }

    return res.status(200).json({ message: "Callback traité — compte crédité" });

  } catch (error) {
    console.error("[flexpayCallback] Erreur :", error);
    return res.status(200).json({ message: "Erreur serveur callback" });
  }
};

/* ════════════════════════════════════════════════════════════════════════
   APPROVE / CANCEL / DECLINE — redirections FlexPay carte (WebView mobile)
   FlexPay redirige le navigateur vers ces URLs après paiement carte.
   Le serveur émet un event socket à l'app mobile puis ferme la WebView.
   Routes :
     GET /api/transactions/recharge/approved/:reference
     GET /api/transactions/recharge/cancel/:reference
     GET /api/transactions/recharge/decline/:reference
   ════════════════════════════════════════════════════════════════════════ */

const webviewClosePage = (title, message, color) => `
<!DOCTYPE html><html><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<style>body{margin:0;display:flex;align-items:center;justify-content:center;
min-height:100vh;background:#f5f5f5;font-family:sans-serif}
.box{text-align:center;padding:32px;background:#fff;border-radius:16px;
box-shadow:0 2px 12px rgba(0,0,0,.1);max-width:320px}
h2{color:${color};margin-bottom:8px}p{color:#555;font-size:14px}</style>
</head><body><div class="box"><h2>${title}</h2><p>${message}</p>
<p style="font-size:12px;color:#aaa;margin-top:16px">Vous pouvez fermer cette fenêtre.</p>
</div><script>setTimeout(()=>window.close(),2000)</script></body></html>`;

export const flexpayApproved = async (req, res) => {
  const { reference } = req.params;
  try {
    const record = await TransactionRecharge.findOne({ where: { reference } });
    if (record) emitToUser(record.id, "recharge:approved", { reference });
  } catch (e) { console.error("[flexpayApproved]", e.message); }
  res.send(webviewClosePage("Paiement reçu ✅", "Votre paiement a été accepté.", "#4caf50"));
};

export const flexpayCancel = async (req, res) => {
  const { reference } = req.params;
  try {
    const record = await TransactionRecharge.findOne({ where: { reference } });
    if (record) {
      await record.update({ status: "failed" });
      emitToUser(record.id, "recharge:cancelled", { reference });
    }
  } catch (e) { console.error("[flexpayCancel]", e.message); }
  res.send(webviewClosePage("Paiement annulé", "Vous avez annulé le paiement.", "#ff9800"));
};

export const flexpayDecline = async (req, res) => {
  const { reference } = req.params;
  try {
    const record = await TransactionRecharge.findOne({ where: { reference } });
    if (record) {
      await record.update({ status: "failed" });
      emitToUser(record.id, "recharge:declined", { reference });
      await Notification.create({
        title:   "Paiement refusé ❌",
        message: "Votre paiement par carte a été refusé. Veuillez réessayer.",
        type:    "ERREUR",
        userId:  record.id,
      }).catch(() => {});
    }
  } catch (e) { console.error("[flexpayDecline]", e.message); }
  res.send(webviewClosePage("Paiement refusé ❌", "Votre paiement a été refusé.", "#f44336"));
};

/* ════════════════════════════════════════════════════════════════════════
   VERIFY PAYMENT — appelé par le client après timeout d'attente
   Permet de vérifier manuellement si le paiement a été confirmé par FlexPay
   et de créditer le compte si c'est le cas.
   Body : { reference }
   ════════════════════════════════════════════════════════════════════════ */
export const verifyPayment = async (req, res) => {
  try {
    const { reference } = req.body;
    if (!reference) return res.status(400).json({ message: "reference est obligatoire" });

    const rechargeRecord = await TransactionRecharge.findOne({ where: { reference } });

    if (!rechargeRecord) {
      return res.status(404).json({ message: "Transaction introuvable", status: "not_found" });
    }

    if (rechargeRecord.status === "success") {
      return res.status(200).json({ message: "Transaction déjà créditée", status: "already_done" });
    }

    if (rechargeRecord.status === "failed") {
      emitToUser(rechargeRecord.id, "recharge:cancelled", { reference });
      return res.status(200).json({ message: "Transaction annulée", status: "cancelled" });
    }

    const orderRef = rechargeRecord.orderNumber;
    if (!orderRef) {
      return res.status(200).json({ message: "orderNumber manquant, vérification impossible", status: "pending" });
    }

    let checkData;
    try {
      checkData = await checkFlexPayTransaction(orderRef);
      console.log("[verifyPayment] FlexPay check 👉", JSON.stringify(checkData));
    } catch (e) {
      console.error("[verifyPayment] Erreur check FlexPay :", e.message);
      return res.status(500).json({ message: "Impossible de contacter FlexPay", status: "error" });
    }

    const txStatus  = String(checkData?.transaction?.status ?? "");
    const outerCode = String(checkData?.code ?? "");

    console.log("[verifyPayment] outerCode =", outerCode, "| txStatus =", txStatus);

    /* FlexPay signale une erreur au niveau de l'appel (transaction introuvable, annulée côté opérateur, etc.) */
    if (outerCode !== "0") {
      await rechargeRecord.update({ status: "failed" });
      emitToUser(rechargeRecord.id, "recharge:cancelled", { reference });
      return res.status(200).json({ message: "Paiement annulé ou refusé", status: "cancelled", data: checkData });
    }

    /* txStatus = "0" → succès ; "1" → encore en attente ; "2" / autre → annulé/refusé */
    if (txStatus !== "0" && txStatus !== "1" && txStatus !== "") {
      await rechargeRecord.update({ status: "failed" });
      emitToUser(rechargeRecord.id, "recharge:cancelled", { reference });
      return res.status(200).json({ message: "Paiement annulé ou refusé par l'opérateur", status: "cancelled", data: checkData });
    }

    /* Paiement encore en attente chez l'opérateur — on expire après 10 min */
    if (txStatus !== "0") {
      const ageMs = Date.now() - new Date(rechargeRecord.createdAt).getTime();
      if (ageMs > 10 * 60 * 1000) {
        await rechargeRecord.update({ status: "failed" });
        emitToUser(rechargeRecord.id, "recharge:cancelled", { reference });
        return res.status(200).json({ message: "Transaction expirée (10 min)", status: "cancelled", data: checkData });
      }
      return res.status(200).json({ message: "Paiement pas encore confirmé", status: "pending", data: checkData });
    }

    /* Paiement confirmé → on crédite */
    await rechargeRecord.update({ status: "success" });
    const rawAmount = Math.round(rechargeRecord.amount / 10);

    let creditResult;
    try {
      creditResult = await creditBim(rechargeRecord.id, rawAmount, OWNER_EMAIL);
    } catch (error) {
      console.error("[verifyPayment] Erreur crédit BIM :", error);
      return res.status(500).json({ message: "Erreur lors du crédit du compte", status: "error" });
    }

    if (creditResult.ok) {
      const { userItem, ownerItem, montantCredite } = creditResult;
      emitToUser(rechargeRecord.id, "recharge:success", {
        montantCredite,
        solde: userItem.soldNumber,
        reference,
      });
      sendConfirmationEmail(userItem, ownerItem, rawAmount, montantCredite);
      return res.status(200).json({ message: "Compte crédité avec succès", status: "success", montantCredite, data: checkData });
    }

    return res.status(200).json({ message: "Erreur lors du crédit", status: "error", data: checkData });

  } catch (error) {
    console.error("[verifyPayment] Erreur :", error);
    return res.status(500).json({ message: "Erreur serveur", status: "error" });
  }
};

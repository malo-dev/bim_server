/* eslint-disable no-undef */
import { Transaction,TransactionRetrait,User,TransactionTransfert, TransactionRecharge,History,Notification,TransactionPaiement,Order,Company, Product} from '../models/index.js';
import { Op } from 'sequelize';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import axios from "axios";
import dotenv from 'dotenv';
import { generateSupportReceivedEmailTemplate, generateSupportReceivedEmailTemplatePaiement,generateSupportReceivedEmailTemplateTransfert } from '../utils/templateMails.util.js';
import sequelize from '../config/database.js';
import nodemailer from 'nodemailer';
import jwt from "jsonwebtoken";
import { generateReferenceRecharge } from '../utils/generateReferenceSecond.js';
import { sendPushNotification } from '../services/pushNotification.service.js';
import { emitToUser } from '../services/socket.service.js';
/* ================= CONFIG RETRAIT ================= */

const RETRAIT_CONFIG = {
  FRAIS_PERCENT: 3,     // 3% total
  FRAIS_AGENT: 0.5,     // 0.5% pour agent
};
dotenv.config();

export const getAllTransactions = async (req, res) => {
  try {
    const {
      search,
      paginate = 'false',
      page = 1,
      pageSize = 20,
      commerceId,
      branchTrackId,
      period,
      status,
      amount,
      transactionType,
      id,


    } = req.query;
        const isPaginate = paginate === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

     const whereClause = {};

         if (commerceId) {
      whereClause.commerceId = commerceId;
    }

          if (status) {
      whereClause.status = status;
    }

          if (amount) {
      whereClause.amount = amount;
    }

         if (transactionType) {
      whereClause.transactionType = transactionType;
    }

        if (id) {
         
      whereClause.id = id;
    }



       if (commerceId && branchTrackId) {
      whereClause[Op.and] = [
        {
          [Op.or]: [
            { branchTrackId },
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
          ],
        },
      ];
    }

    if (period) {
      const startDate = getDateRangeByPeriod(period);
      if (startDate) {
        whereClause.createdAt = {
          [Op.gte]: startDate,
        };
      }
    }

    const queryOptions = {
      where: whereClause,
    
      order: [['createdAt', 'DESC']],
        include: [
    {
      model: User,
      as: "user",
      attributes: ["id", "username", "email","fullname","createdAt"] // champs que tu veux
    }
  ],
    };

    if (isPaginate) {
      const { rows, count } = await Transaction.findAndCountAll({
        ...queryOptions,
        limit,
        offset,
      });

      return res.status(200).json({
        message: 'Requête passée avec succès',
        data: rows,
          total: count,
          page: currentPage,
          pageSize: limit,
          totalPages: Math.ceil(count / limit),
      });
    }

    const categories = await Transaction.findAll(queryOptions);
try {
  
    History.create({
  type: "transaction",
  description: "La liste de vos transactions a été consultée avec succès.",
  userId: id,
  action: "Consultation des transactions 📄",
});

 return res.status(200).json({
      message: 'Requête passée avec succès',
      data: categories,
      total: categories.length,
    });
} catch (
  error
) {
  return res.status(500).json({
      message: 'Server error',
      error: error.message,
    });
}


   
  } catch (error) {
    return res.status(500).json({
      message: 'Server error',
      error: error.message,
    });
  }
};



export const getTransactionById = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid Transaction ID' });
    }

    const TransactionItem = await Transaction.findByPk(parsedId);

    if (!TransactionItem) {
      return res.status(404).json({ message: 'Transaction not found' });
    }

    res.status(200).json({
      data: TransactionItem,
      message: 'Transaction retrieved successfully',
    });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving Transaction', error });
  }
};






/* ================= CONTROLLER ================= */
export const createRetrait = async (req, res) => {
  const t = await sequelize.transaction();
  let mainTransaction = null;

  try {
    const { amount, accountNumber, id } = req.body;
    const retraitAmount = Number(amount);

    if (!id || !amount || !accountNumber) {
      return res.status(400).json({ message: "Tous les champs sont obligatoires" });
    }

    if (retraitAmount <= 0) {
      return res.status(400).json({ message: "Montant invalide" });
    }

    const userSender = await User.findByPk(Number(id));
    const userAgent = await User.findOne({ where: { accountNumber } });
    const bimBank = await User.findOne({ where: { email: "bimbank@bimreseau.com" } });

    if (!userSender || !userAgent || !bimBank) {
      return res.status(404).json({ message: "Utilisateur introuvable" });
    }

     if (!userAgent.isAgent) {
      return res.status(404).json({ message: "Il s'agit pas d'un agent" });
    }


  
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);

    const retraitCountToday = await TransactionRetrait.count({
      where: { id: userSender.id, createdAt: { [Op.gte]: startOfDay } },
    });

    if (retraitCountToday >= userSender.maxRetraitParJour) {
      return res.status(400).json({
        message: "Nombre maximum de retraits atteint aujourd'hui.",
      });
    }

    // ── Calcul frais ──
    const fraisTotal = (retraitAmount * RETRAIT_CONFIG.FRAIS_PERCENT) / 100;
    const fraisAgent = fraisTotal * (RETRAIT_CONFIG.FRAIS_AGENT / 100);
    const fraisOwner = fraisTotal - fraisAgent;
    const totalDebit = retraitAmount + fraisTotal;

    const senderSold = Number(userSender.soldNumber || 0);

    if (totalDebit > senderSold) {
      return res.status(400).json({ message: `Solde insuffisant. Total requis: ${totalDebit}$` });
    }

    // ── Créer transaction principale ──
    mainTransaction = await Transaction.create(
      {
        amount: retraitAmount,
        status: "en attente",
        description: "Retrait en traitement",
        transactionType: "retrait",
        id: userSender.id,
      },
      { transaction: t }
    );

    // ── Mettre à jour soldes ──
    await userSender.update({ soldNumber: senderSold - totalDebit }, { transaction: t });
    await bimBank.update({ soldNumber: Number(bimBank.soldNumber || 0) + fraisOwner }, { transaction: t });
    await userAgent.update({ soldNumber: (Number(userAgent.soldNumber) || 0) + retraitAmount + fraisAgent }, { transaction: t });

    // ── Créer transaction retrait ──
     await TransactionRetrait.create(
      {
        amount: retraitAmount,
        fraisTransaction: fraisTotal,
        fraisAgent,
        id: userSender.id,
        targetId: userAgent.id,
        status: "réussi",
      },
      { transaction: t }
    );

    // ── Mettre à jour transaction principale ──
    await mainTransaction.update({ status: "réussi", description: "Retrait effectué avec succès" }, { transaction: t });

    // ── Historique ──
    await History.bulkCreate(
      [
        { type: "Retrait", amount: retraitAmount, status: "réussi", description: "Retrait effectué", userId: userSender.id },
        { type: "Retrait", amount: retraitAmount, status: "réussi", description: "Retrait client reçu", userId: userAgent.id },
        { type: "Retrait", amount: fraisOwner, status: "réussi", description: "Frais retrait reçu", userId: bimBank.id },
      ],
      { transaction: t }
    );

    // ── Notifications ──
    await Notification.bulkCreate(
      [
        {
          title: "Retrait réussi ✅",
          message: `Votre retrait de ${retraitAmount}$ a été effectué. Frais: ${fraisTotal}$ (total débité: ${totalDebit}$).`,
          type: "SUCCESS",
          userId: userSender.id,
        },
        {
          title: "Nouveau retrait 💰",
          message: `Vous avez reçu un retrait de ${retraitAmount}$ + frais agent ${fraisAgent}$.`,
          type: "INFO",
          userId: userAgent.id,
        },
        {
          title: "Frais retrait reçu 💰",
          message: `Frais de ${fraisOwner}$ crédité sur le compte BIM Bank.`,
          type: "INFO",
          userId: bimBank.id,
        },
      ],
      { transaction: t }
    );

    // ── Email ──
    const htmlSuccess = generateSupportReceivedEmailTemplate(
      userSender.username || "Utilisateur",
      `Retrait de ${retraitAmount}$ effectué avec succès (Frais: ${fraisTotal}$).`
    );

    const transporter = nodemailer.createTransport({
      host: "mail.bimreseau.com",
      port: 465,
      secure: true,
      auth: { user: "noreply@bimreseau.com", pass: process.env.EMAIL_PASSWORD },
    });

    await transporter.sendMail({
      from: "noreply@bimreseau.com",
      to: `${userSender.email}, ${userAgent.email}`,
      subject: `Un retrait de ${retraitAmount}$ a été effectué avec succès le ${new Date().toLocaleDateString()} à ${new Date().toLocaleTimeString()}.`,
      html: htmlSuccess,
    });

    await t.commit();

    // ── Push notifications + Socket temps réel ──
    const pushPayloadSender = {
      title: "Retrait réussi ✅",
      message: `Votre retrait de ${retraitAmount}$ a été effectué. Total débité: ${totalDebit}$.`,
    };
    const pushPayloadAgent = {
      title: "Nouveau retrait 💰",
      message: `Retrait de ${retraitAmount}$ + frais agent ${fraisAgent}$ crédités.`,
    };

    emitToUser(userSender.id, "notification", { ...pushPayloadSender, type: "SUCCESS" });
    emitToUser(userAgent.id, "notification", { ...pushPayloadAgent, type: "INFO" });

    if (userSender.expoPushToken) {
      sendPushNotification(userSender.expoPushToken, pushPayloadSender.title, pushPayloadSender.message).catch(() => {});
    }
    if (userAgent.expoPushToken) {
      sendPushNotification(userAgent.expoPushToken, pushPayloadAgent.title, pushPayloadAgent.message).catch(() => {});
    }

    return res.status(201).json({
      message: "Retrait effectué avec succès",
      transaction: mainTransaction,
      totalDebit,
      fraisTotal,
      fraisAgent,
      fraisOwner,
    });
  } catch (error) {
    await t.rollback();
    console.error(error);

    if (mainTransaction) {
      await mainTransaction.update({ status: "échoué", description: "Erreur serveur" });
    }

     if (req?.user?.id) {
      await Notification.create({
        title: "Échec du retrait ❌",
        message: `Votre tentative de recharge de ${Number(
          amount || 0
        )}$ n’a pas abouti. Veuillez réessayer ou contacter le support.`,
        type: "ERREUR",
        userId: req.user.id,
      });
    }


    return res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};



export const createTransfert = async (req, res) => {
  const t = await sequelize.transaction();

  let sender   = null;
  let receiver = null;

  try {
    const { amount, targetId, id } = req.body;
    const transferAmount = Number(amount);

    /* ── 1. Validation rapide ── */
    if (
      !id ||
      !targetId ||
      isNaN(transferAmount) ||
      transferAmount <= 0 ||
      Number(id) === Number(targetId)
    ) {
      await t.rollback();
      return res.status(400).json({
        message:
          Number(id) === Number(targetId)
            ? "Vous ne pouvez pas vous transférer de l'argent"
            : "Champs invalides",
      });
    }

    /* ── 2. Récupérer les deux utilisateurs en une seule requête ── */
    const users = await User.findAll({
      where: { id: [Number(id), Number(targetId)] },
      transaction: t,
      lock: t.LOCK.UPDATE,
    });

    sender   = users.find((u) => u.id === Number(id));
    receiver = users.find((u) => u.id === Number(targetId));

    if (!sender || !receiver) {
      await t.rollback();
      return res.status(404).json({ message: "Utilisateur introuvable" });
    }

    /* ── 3. Vérification abonnement sender ── */
    if (!sender.TokenAbonemment) {
      await t.rollback();
      return res.status(403).json({ message: "Rechargez pour activer votre abonnement" });
    }
    try {
      jwt.verify(sender.TokenAbonemment, process.env.JWT_SECRET);
    } catch {
      await t.rollback();
      return res.status(403).json({ message: "Votre abonnement est expiré. Veuillez recharger." });
    }

    /* ── 4. Limite de transferts par jour ── */
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);

    const transfertCountToday = await TransactionTransfert.count({
      where: { id: sender.id, createdAt: { [Op.gte]: startOfDay } },
      transaction: t,
    });

    if (transfertCountToday >= sender.maxTransfertParJour) {
      await t.rollback();
      return res.status(400).json({
        message: `Nombre maximum de transferts atteint aujourd'hui (${sender.maxTransfertParJour})`,
      });
    }

    /* ── 5. Vérification solde ── */
    const senderSold = Number(sender.soldNumber || 0);
    if (transferAmount > senderSold) {
      await t.rollback();
      return res.status(400).json({ message: "Solde insuffisant" });
    }

    /* ── 6. Calcul abonnement destinataire ── */
    let receiverTokenExpired = false;
    if (!receiver.TokenAbonemment) {
      receiverTokenExpired = true;
    } else {
      try {
        jwt.verify(receiver.TokenAbonemment, process.env.JWT_SECRET);
      } catch {
        receiverTokenExpired = true;
      }
    }

    let finalReceiverAmount = transferAmount;
    let fraisAbonnement     = 0;

    const needsSubscription = receiver.nRecharge === 0 || receiverTokenExpired;
    if (needsSubscription) {
      if (transferAmount <= 1) {
        await t.rollback();
        return res.status(400).json({
          message: "Montant doit être > 1 EC pour activer l'abonnement du destinataire",
        });
      }
      finalReceiverAmount -= 1;
      fraisAbonnement      = 1;
    }

    /* ── 7. Mise à jour soldes ── */
    await sender.update(
      { soldNumber: senderSold - transferAmount },
      { transaction: t }
    );

    const receiverNewSold = (Number(receiver.soldNumber) || 0) + finalReceiverAmount;
    const receiverUpdates = { soldNumber: receiverNewSold };

    if (needsSubscription) {
      receiverUpdates.TokenAbonemment = jwt.sign(
        { userId: receiver.id, type: "ABONNEMENT" },
        process.env.JWT_SECRET,
        { expiresIn: "1y" }
      );
      receiverUpdates.nRecharge = (receiver.nRecharge || 0) + 1;
    }

    await receiver.update(receiverUpdates, { transaction: t });

    /* ── 8. TransactionTransfert (table spécifique) ── */
    const transactionItem = await TransactionTransfert.create(
      {
        amount:           transferAmount,
        fraisTransaction: 0,
        fraisAbonnement,
        id:               sender.id,
        targetId:         receiver.id,
        status:           "réussi",
      },
      { transaction: t }
    );

    /* ── 9. Transactions génériques SUCCESS
            sender  → débit  (montant total envoyé)
            receiver→ crédit (montant reçu après frais éventuels) ── */
    await Transaction.bulkCreate(
      [
        {
          amount:          transferAmount,
          status:          "réussi",
          description:     `Transfert envoyé à ${receiver.username}`,
          transactionType: "transfert",
          id:              sender.id,
        },
        {
          amount:          finalReceiverAmount,
          status:          "réussi",
          description:     `Transfert reçu de ${sender.username}`,
          transactionType: "transfert",
          id:              receiver.id,
        },
      ],
      { transaction: t }
    );

    /* ── 10. Notifications
            ENUM Notification.type autorisés :
            "INFO" | "SUCCESS" | "ERREUR" | "EXPEDITION" | "RECEPTION" | "ALERTE" | "LITIGE"
            ⚠️  Ne jamais mettre "ERROR" (sans accent) ── */
    const notificationsToCreate = [
      {
        title:   "Transfert envoyé ✅",
        message: `Vous avez transféré ${transferAmount} EC à ${receiver.username}.`,
        type:    "SUCCESS",   // ✅
        userId:  sender.id,
      },
      {
        title:   "Fonds reçus 💰",
        message: `Vous avez reçu ${finalReceiverAmount} EC de ${sender.username}.`,
        type:    "SUCCESS",   // ✅
        userId:  receiver.id,
      },
    ];

    if (fraisAbonnement === 1) {
      notificationsToCreate.push({
        title:   "Abonnement activé 🎉",
        message: "1 EC a été déduit pour activer votre abonnement.",
        type:    "INFO",      // ✅
        userId:  receiver.id,
      });
    }

    await Notification.bulkCreate(notificationsToCreate, { transaction: t });

    /* ── 11. Historique sender ── */
    await History.create(
      {
        type:        "Transfert",
        amount:      transferAmount,
        status:      "réussi",
        description: `Transfert envoyé à ${receiver.username}`,
        action:      "Transfert EC ✅",
        userId:      sender.id,
      },
      { transaction: t }
    );

    /* ── 12. COMMIT ── */
    await t.commit();

    /* ── 13. Réponse immédiate ── */
    res.status(201).json({
      message:          "Transfert effectué avec succès",
      data:             transactionItem,
      fraisTransaction: 0,
      fraisAbonnement,
      senderNewSold:    senderSold - transferAmount,
      receiverNewSold,
    });

    /* ── Push notifications + Socket temps réel ── */
    const pushSender = {
      title: "Transfert envoyé ✅",
      message: `Vous avez transféré ${transferAmount} EC à ${receiver.username}.`,
    };
    const pushReceiver = {
      title: "Fonds reçus 💰",
      message: `Vous avez reçu ${finalReceiverAmount} EC de ${sender.username}.`,
    };

    emitToUser(sender.id, "notification", { ...pushSender, type: "SUCCESS" });
    emitToUser(receiver.id, "notification", { ...pushReceiver, type: "SUCCESS" });

    if (sender.expoPushToken) {
      sendPushNotification(sender.expoPushToken, pushSender.title, pushSender.message).catch(() => {});
    }
    if (receiver.expoPushToken) {
      sendPushNotification(receiver.expoPushToken, pushReceiver.title, pushReceiver.message).catch(() => {});
    }

    /* ── 14. Emails fire & forget (après commit + réponse) ── */
    try {
      const transporter = nodemailer.createTransport({
        host:           "mail.bimreseau.com",
        port:           465,
        secure:         true,
        auth:           { user: "noreply@bimreseau.com", pass: process.env.EMAIL_PASSWORD },
        pool:           true,
        maxConnections: 3,
      });

      const htmlSender = generateSupportReceivedEmailTemplateTransfert({
        username:     sender.username   || "Utilisateur",
        subject:      `Vous avez transféré ${transferAmount} EC à ${receiver.username}`,
        senderName:   sender.username,
        receiverName: receiver.username,
        amount:       transferAmount,
      });

      const htmlReceiver = generateSupportReceivedEmailTemplateTransfert({
        username:     receiver.username || "Utilisateur",
        subject:      `Vous avez reçu ${finalReceiverAmount} EC de ${sender.username}`,
        senderName:   sender.username,
        receiverName: receiver.username,
        amount:       finalReceiverAmount,
      });

      await Promise.all([
        transporter.sendMail({
          from: "noreply@bimreseau.com", to: sender.email,
          subject: "Transfert envoyé", html: htmlSender,
        }),
        transporter.sendMail({
          from: "noreply@bimreseau.com", to: receiver.email,
          subject: "Fonds reçus", html: htmlReceiver,
        }),
      ]);
    } catch (emailError) {
      console.error("[createTransfert] Erreur email (non critique) :", emailError.message);
    }

  } catch (error) {
    /* ── Rollback ── */
    try { await t.rollback(); } catch { /* déjà commitée — ignorer */ }

    console.error("[createTransfert] Erreur :", error);

    /* ── Transactions ÉCHEC hors transaction (connexion séparée) ── */
    if (sender) {
      try {
        const failRecords = [
          {
            amount:          Number(req.body?.amount) || 0,
            status:          "échoué",
            description:     `Transfert échoué${receiver ? ` vers ${receiver.username}` : ""}`,
            transactionType: "transfert",
            id:              sender.id,
          },
        ];
        // Trace aussi côté receiver si on le connaît
        if (receiver) {
          failRecords.push({
            amount:          Number(req.body?.amount) || 0,
            status:          "échoué",
            description:     `Transfert échoué depuis ${sender.username}`,
            transactionType: "transfert",
            id:              receiver.id,
          });
        }
        await Transaction.bulkCreate(failRecords);
      } catch (trxError) {
        console.error("[createTransfert] Erreur transaction échec :", trxError.message);
      }

      /* Notification échec sender
         ⚠️  "ERREUR" avec accent — seule valeur ENUM valide pour les erreurs ── */
      try {
        await Notification.create({
          title:   "Échec du transfert ❌",
          message: `Votre tentative d'envoi de ${req.body?.amount} EC a échoué.`,
          type:    "ERREUR",  // ✅ accent obligatoire
          userId:  sender.id,
        });
      } catch (notifError) {
        console.error("[createTransfert] Erreur notification échec :", notifError.message);
      }

      /* Historique échec sender */
      try {
        await History.create({
          type:        "Transfert",
          amount:      Number(req.body?.amount) || 0,
          status:      "échoué",
          description: `Transfert échoué${receiver ? ` vers ${receiver.username}` : ""}`,
          action:      "Transfert EC ❌",
          userId:      sender.id,
        });
      } catch (histError) {
        console.error("[createTransfert] Erreur history échec :", histError.message);
      }
    }

    if (!res.headersSent) {
      return res.status(500).json({ message: "Erreur serveur lors du transfert" });
    }
  }
};


export const createRecharge = async (req, res) => {
  let transaction;

  try {
    const { amount, telephone, id, PayTypeValue } = req.body;

    /* ================= VALIDATION ================= */
    if (!id || !amount || !telephone) {
      return res.status(400).json({ message: "Données manquantes" });
    }

    const rechargeAmount = Math.round(Number(amount) * 10);

    if (isNaN(rechargeAmount) || rechargeAmount <= 0) {
      return res.status(400).json({ message: "Montant invalide" });
    }

    /* ================= USER ================= */
    const user = await User.findByPk(id);

    if (!user) {
      return res.status(404).json({ message: "Utilisateur introuvable" });
    }

    /* ================= LIMITE PAR JOUR ================= */
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);

    const rechargeCountToday = await TransactionRecharge.count({
      where: {
        id: user.id,
        createdAt: { [Op.gte]: startOfDay },
      },
    });

    if (rechargeCountToday >= user.maxRechargeParJour) {
      return res.status(400).json({
        message: `Vous avez atteint le nombre maximum de recharges aujourd'hui (${user.maxRechargeParJour}). Réessayez demain.`,
      });
    }

    /* ================= VERIFICATION TOKEN ================= */
    const previousRecharge = user.nRecharge || 0;

    let tokenExpired = false;

    if (!user.TokenAbonemment) {
      tokenExpired = true;
    } else {
      try {
        jwt.verify(user.TokenAbonemment, process.env.JWT_SECRET);
      } catch (err) {
        console.log(err)
        tokenExpired = true;
      }
    }

    /* ================= REFERENCE ================= */
    const reference = generateReferenceRecharge();

    /* ================= CREER TRANSACTION ================= */
    if (previousRecharge === 0 || tokenExpired) {
      if (rechargeAmount <= 1) {
        return res.status(400).json({
          message:
            "Le montant doit être supérieur à 1$ pour activer ou renouveler l’abonnement",
        });
      }
    }

    transaction = await TransactionRecharge.create({
      amount: rechargeAmount,
      telephone,
      reference,
      id,
      status: "pending",
    });

    console.log("Transaction créée ✔️", transaction.transactionRechargeId);

    /* ================= PAYTYPE ================= */
    const payTypeData = {
      AirtelMoney: 1,
      "M-Pesa": 2,
      OrangeMoney: 3,
      AfriMoney: 52,
    };

    const payType = payTypeData[String(PayTypeValue)];

    if (!payType) {
      await transaction.update({ status: "failed" });

      return res.status(400).json({
        message: "Type de paiement invalide",
      });
    }

    /* ================= PAYLOAD MAXICASH ================= */
    const payload = {
      RequestData: {
        Amount: rechargeAmount * 10,
        Reference: String(reference),
        Telephone: String(telephone),
      },
      MerchantID: process.env.MAXICASH_MERCHANT_ID,
      MerchantPassword: process.env.MAXICASH_MERCHANT_PASSWORD,
      PayType: payType,
      CurrencyCode: "USD",
    };

    // https://webapi-test.maxicashapp.com/Integration/PayNowSync

    // https://webapi.maxicashapp.com/Integration/PayNowSync

    console.log("Payload envoyé 👉", payload);

    /* ================= APPEL API ================= */
    const response = await axios.post(
      "https://webapi.maxicashapp.com/Integration/PayNowSync",
      payload,
      {
        headers: { "Content-Type": "application/json" }
      }
    );

    console.log("Réponse MaxiCash 👉", response.data);

    const data = response.data;

    /* ================= RESULTAT ================= */
    if (data?.ResponseCode === "00" || data?.ResponseStatus === "Success") {
      await transaction.update({ status: "success" });

      return res.status(201).json({
        message: "Recharge réussie",
        Reference: reference,
        status: "success",
      });
    } else {
      await transaction.update({ status: "failed" });

      return res.status(400).json({
        message: "Recharge échouée",
        details:
          data?.ResponseMessage ||
          data?.Status ||
          "Erreur inconnue",
        status: "failed",
      });
    }
  } catch (error) {
    console.error("ERREUR RECHARGE ❌", error.message);

    if (transaction) {
      await transaction.update({ status: "failed" });
    }

    return res.status(500).json({
      message: "Erreur serveur",
      error: error.message,
    });
  }
};


export const checkRechargeStatus = async (req, res) => {
  try {
    const { PaymentID } = req.body;

    if (!PaymentID) {
      return res.status(400).json({ message: "PaymentID requis" });
    }

    const payload = {
      PmtID: PaymentID,
      PType: "MaxiCash",
      MerchantID: process.env.MAXICASH_MERCHANT_ID,
      MerchantPassword: process.env.MAXICASH_MERCHANT_PASSWORD,
      Language: "en",
    };

    const response = await axios.post(
      "https://api-testbed.maxicashapp.com/Merchant/api.asmx/CompletePayLater",
      { strData: JSON.stringify(payload) },
      { headers: { "Content-Type": "application/json; charset=utf-8" } }
    );

    const data = response.data.d ? JSON.parse(response.data.d) : response.data;

    return res.json({ data });
  } catch (error) {
    return res.status(500).json({ message: "Server error", error: error.message });
  }
};


export const createPaiement = async (req, res) => {
  const t = await sequelize.transaction();

  let sender, ownerItem, company, product;

  console.log(req.body);

  try {
    const {
      amount,
      id,
      companyId,
      productId,
      shippingAddress,
      notes,
      paymentMethod,
    } = req.body;

    const paiementAmount = Number(amount);

    /* ── 1. Validation ── */
    if (!id || !paiementAmount || !companyId || !productId) {
      await t.rollback();
      return res.status(400).json({ message: "Tous les champs obligatoires sont requis" });
    }
    if (paiementAmount <= 0) {
      await t.rollback();
      return res.status(400).json({ message: "Montant invalide" });
    }

    /* ── 2. Récupérer entités ── */
    sender    = await User.findByPk(Number(id),                    { transaction: t, lock: t.LOCK.UPDATE });
    ownerItem = await User.findOne({ where: { email: "bimbank@bimreseau.com" }, transaction: t, lock: t.LOCK.UPDATE });
    company   = await Company.findByPk(companyId,                  { transaction: t });
    product   = await Product.findByPk(productId,                  { transaction: t });

    if (!sender || !ownerItem || !company) {
      await t.rollback();
      return res.status(404).json({ message: "Utilisateur ou entreprise introuvable" });
    }

    /* ── 3. Abonnement sender ── */
    if (!sender.TokenAbonemment) {
      await t.rollback();
      return res.status(403).json({ message: "Veuillez recharger pour activer votre abonnement" });
    }
    try {
      jwt.verify(sender.TokenAbonemment, process.env.JWT_SECRET);
    } catch {
      await t.rollback();
      return res.status(403).json({ message: "Votre abonnement est expiré. Veuillez recharger." });
    }

    /* ── 4. Vérification solde ── */
    const senderSold  = Number(sender.soldNumber  || 0);
    const ownerSold   = Number(ownerItem.soldNumber || 0);

    if (paiementAmount > senderSold) {
      await t.rollback();
      return res.status(400).json({ message: "Solde insuffisant" });
    }

    const newSenderSold = senderSold  - paiementAmount;
    const newOwnerSold  = ownerSold   + paiementAmount;

    await sender.update(   { soldNumber: newSenderSold }, { transaction: t });
    await ownerItem.update({ soldNumber: newOwnerSold  }, { transaction: t });

    /* ── 5. Commande ── */
    const orderNumber = `ORD-${Date.now()}`;

    const order = await Order.create(
      {
        orderNumber,
        userId:          sender.id,
        companyId,
        productId,
        totalAmount:     paiementAmount,
        status:          "paid",
        paymentMethod,
        shippingAddress,
        notes,
      },
      { transaction: t }
    );

    /* ── 6. TransactionPaiement (table spécifique) ── */
    const transactionPaiement = await TransactionPaiement.create(
      {
        amount:      paiementAmount,
        description: `Paiement commande ${orderNumber}`,
        targetId:    ownerItem.id,
        companyId,
        productId,
        userId:      sender.id,
      },
      { transaction: t }
    );

    /* ── 7. Transaction générique (table Transaction)
            sender → débit paiement
            ownerItem → crédit réception ── */
    await Transaction.bulkCreate(
      [
        {
          amount:          paiementAmount,
          status:          "réussi",
          description:     `Paiement commande ${orderNumber} — ${product?.name || ""}`,
          transactionType: "paiement",
          id:              sender.id,
        },
        {
          amount:          paiementAmount,
          status:          "réussi",
          description:     `Réception paiement commande ${orderNumber}`,
          transactionType: "paiement",
          id:              ownerItem.id,
        },
      ],
      { transaction: t }
    );

    /* ── 8. Notifications
            ENUM autorisés : "INFO" | "SUCCESS" | "ERREUR" | "EXPEDITION"
                             | "RECEPTION" | "ALERTE" | "LITIGE" ── */
    await Notification.bulkCreate(
      [
        {
          title:   "Paiement réussi ✅",
          message: `Votre paiement de ${paiementAmount} EC pour la commande ${orderNumber} a été effectué.`,
          type:    "SUCCESS",   // ✅
          userId:  sender.id,
        },
        {
          title:   "Commande payée 🛒",
          message: `Une nouvelle commande ${orderNumber} a été payée.`,
          type:    "INFO",      // ✅
          userId:  ownerItem.id,
        },
      ],
      { transaction: t }
    );

    /* ── 9. Historique ── */
    await History.bulkCreate(
      [
        {
          type:        "Paiement",
          amount:      paiementAmount,
          status:      "réussi",
          description: `Paiement commande ${orderNumber}`,
          action:      "Paiement EC ✅",
          userId:      sender.id,
        },
        {
          type:        "Paiement",
          amount:      paiementAmount,
          status:      "réussi",
          description: `Réception paiement commande ${orderNumber}`,
          action:      "Réception paiement ✅",
          userId:      ownerItem.id,
        },
      ],
      { transaction: t }
    );

    /* ── 10. COMMIT ── */
    await t.commit();

    /* ── 11. Réponse immédiate (avant l'email) ── */
    res.status(201).json({
      message:          "Paiement effectué avec succès",
      order,
      transactionPaiement,
      senderNewSold:    newSenderSold,
    });

    /* ── Push notifications + Socket temps réel ── */
    const pushPaiementSender = {
      title: "Paiement réussi ✅",
      message: `Votre paiement de ${paiementAmount} EC pour la commande ${orderNumber} a été effectué.`,
    };
    const pushPaiementOwner = {
      title: "Nouvelle commande payée 🛒",
      message: `Commande ${orderNumber} — ${paiementAmount} EC reçus.`,
    };

    emitToUser(sender.id, "notification", { ...pushPaiementSender, type: "SUCCESS" });
    emitToUser(ownerItem.id, "notification", { ...pushPaiementOwner, type: "INFO" });

    if (sender.expoPushToken) {
      sendPushNotification(sender.expoPushToken, pushPaiementSender.title, pushPaiementSender.message).catch(() => {});
    }
    if (ownerItem.expoPushToken) {
      sendPushNotification(ownerItem.expoPushToken, pushPaiementOwner.title, pushPaiementOwner.message).catch(() => {});
    }

    /* ── 12. Email fire & forget (après commit + réponse)
            Une lenteur SMTP ne bloque plus jamais le client ── */
    try {
      const htmlSuccess = generateSupportReceivedEmailTemplatePaiement({
        username:      sender.fullname  || "Cher utilisateur",
        subject:       `Votre paiement de ${paiementAmount} EC pour la commande ${orderNumber} a été effectué.`,
        amount:        `${paiementAmount} Ecoins`,
        paymentDate:   transactionPaiement.createdAt,
        transactionId: orderNumber,
        payerName:     sender.fullname,
        companyName:   company.name,
        productName:   product?.name || "",
      });

      const transporter = nodemailer.createTransport({
        host:           "mail.bimreseau.com",
        port:           465,
        secure:         true,
        auth:           { user: "noreply@bimreseau.com", pass: process.env.EMAIL_PASSWORD },
        pool:           true,
        maxConnections: 3,
      });

      await transporter.sendMail({
        from:    "noreply@bimreseau.com",
        to:      `${sender.email}, ${ownerItem.email}, ${company.email}`,
        subject: "Paiement réussi - BIM",
        html:    htmlSuccess,
      });
    } catch (emailError) {
      console.error("[createPaiement] Erreur email (non critique) :", emailError.message);
    }

  } catch (error) {
    /* ── Rollback ── */
    try { await t.rollback(); } catch { /* déjà commitée — ignorer */ }

    console.error("[createPaiement] Erreur :", error);

    /* ── Transaction ÉCHEC hors transaction ── */
    if (sender) {
      try {
        await Transaction.create({
          amount:          Number(req.body?.amount) || 0,
          status:          "échoué",
          description:     "Paiement échoué",
          transactionType: "paiement",
          id:              sender.id,
        });
      } catch (trxError) {
        console.error("[createPaiement] Erreur transaction échec :", trxError.message);
      }

      /* Notification échec
         ⚠️  "ERREUR" avec accent — jamais "ERROR" ── */
      try {
        await Notification.create({
          title:   "Échec du paiement ❌",
          message: `Votre tentative de paiement de ${req.body?.amount} EC n'a pas abouti.`,
          type:    "ERREUR",  // ✅ accent obligatoire
          userId:  sender.id,
        });
      } catch (notifError) {
        console.error("[createPaiement] Erreur notification échec :", notifError.message);
      }

      /* Historique échec */
      try {
        await History.create({
          type:        "Paiement",
          amount:      Number(req.body?.amount) || 0,
          status:      "échoué",
          description: "Paiement échoué",
          action:      "Paiement EC ❌",
          userId:      sender.id,
        });
      } catch (histError) {
        console.error("[createPaiement] Erreur history échec :", histError.message);
      }
    }

    if (!res.headersSent) {
      return res.status(500).json({ message: "Erreur serveur" });
    }
  }
};

export const createTransaction = async (req, res) => {
  try {
    const {  amount, status, description,transactionType,id, commerceId, branchTrackId } = req.body;

    if (!id) {
      return res.status(409).json({
        message: 'Id est obligatoire',
      });
    }

    const TransactionItem = await Transaction.create({
      amount,
      status,
      transactionType,
      description,
      commerceId,
      branchTrackId: branchTrackId || null,
    });

    return res.status(201).json({
      message: 'Transaction added successfully',
      data: TransactionItem,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Server error',
      error: error.message,
    });
  }
};

export const updateTransaction = async (req, res) => {
  try {
    const { id } = req.params;

    const TransactionItem = await Transaction.findByPk(id);
    if (!TransactionItem) {
      return res.status(404).json({ message: 'Transaction not found' });
    }

    const response = await TransactionItem.update(req.body);

    res.status(200).json({
      message: 'Transaction updated successfully',
      data: response,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteTransaction = async (req, res) => {
  try {
    const { id } = req.params;

    const TransactionItem = await Transaction.findByPk(id);
    if (!TransactionItem) {
      return res.status(404).json({ message: 'Transaction not found' });
    }

    await TransactionItem.destroy();

    res.status(200).json({
      message: 'Transaction deleted successfully',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};



// PAIEMENT 

export const getTransactionsPaiement = async (req, res) => {
  try {
    const {
      companyId,
      productId,
      userId,
      startDate,
      endDate,
      search,
    } = req.query;

    let where = {};

    if (companyId) where.companyId = companyId;
    if (productId) where.productId = productId;
    if (userId) where.userId = userId;

    if (startDate && endDate) {
      where.createdAt = {
        [Op.between]: [new Date(startDate), new Date(endDate)],
      };
    }

    if (search) {
      where.description = {
        [Op.like]: `%${search}%`,
      };
    }

    const transactions = await TransactionPaiement.findAll({
      where,
      order: [["createdAt", "DESC"]],
    });

    res.json(transactions);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

export const getTransactionPaiementById = async (req, res) => {
  try {
    const transaction = await TransactionPaiement.findByPk(req.params.id);

    if (!transaction) {
      return res.status(404).json({
        message: "Transaction introuvable",
      });
    }

    res.json(transaction);
  } catch (error) {
     console.error(error);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

export const updateTransactionPaiement = async (req, res) => {
  try {
    const transaction = await TransactionPaiement.findByPk(req.params.id);

    if (!transaction) {
      return res.status(404).json({
        message: "Transaction introuvable",
      });
    }

    await transaction.update(req.body);

    res.json({
      message: "Transaction mise à jour",
      transaction,
    });
  } catch (error) {
     console.error(error);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

export const deleteTransactionPaiement = async (req, res) => {
  try {
    const transaction = await TransactionPaiement.findByPk(req.params.id);

    if (!transaction) {
      return res.status(404).json({
        message: "Transaction introuvable",
      });
    }

    await transaction.destroy();

    res.json({
      message: "Transaction supprimée",
    });
  } catch (error) {
     console.error(error);
    res.status(500).json({ message: "Erreur serveur" });
  }
};



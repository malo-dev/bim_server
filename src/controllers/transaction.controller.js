/* eslint-disable no-undef */
import { Transaction,TransactionRetrait,User,TransactionTransfert, TransactionRecharge,History,Notification} from '../models/index.js';
import { Op } from 'sequelize';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
import axios from "axios";
import dotenv from 'dotenv';
// import { calculFrais } from '../utils/calculFrais.util.js';


import jwt from "jsonwebtoken";
import { generateReferenceRecharge } from '../utils/generateReferenceSecond.js';

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

export const createRetrait = async (req, res) => {
  let userSender, userReceiver, ownerItem;

  try {
    const { amount, accountNumber, id } = req.body;
    const retraitAmount = Number(amount);

    /* ================= VALIDATION ================= */
    if (!id || !amount || !accountNumber) {
      return res.status(400).json({ message: "Tous les champs sont obligatoires" });
    }

    if (retraitAmount <= 0) {
      return res.status(400).json({ message: "Montant invalide" });
    }

    /* ================= USERS ================= */
    userSender = await User.findByPk(Number(id));
    userReceiver = await User.findOne({ where: { accountNumber } });
    ownerItem = await User.findOne({ where: { email: "bimbank@bimreseau.com" } });

    if (!userSender || !userReceiver) {
      return res.status(404).json({ message: "Utilisateur introuvable" });
    }

    if (!userReceiver.isAgent) {
      return res.status(403).json({ message: "Ce numéro n’est pas associé à un compte agent." });
    }

    /* ================= ABONNEMENT SENDER ================= */
    if (!userSender.TokenAbonemment) {
      return res.status(403).json({ message: "Veuillez d'abord recharger pour activer votre abonnement" });
    }

    try {
      jwt.verify(userSender.TokenAbonemment, process.env.JWT_SECRET);
    } catch {
      return res.status(403).json({ message: "Votre abonnement est expiré. Veuillez recharger." });
    }

    /* ================= FRAIS RETRAIT ================= */
    const percentFee = retraitAmount * 0.01;
    const flatFee = 0.5;
    const fraisTransaction = Math.max(percentFee, flatFee);

    const totalToDebit = retraitAmount + fraisTransaction;

    /* ================= SOLDES SENDER ================= */
    const senderSold = Number(userSender.soldNumber || 0);
    if (totalToDebit > senderSold) {
      return res.status(400).json({ message: `Solde insuffisant. Total requis: ${totalToDebit}$` });
    }

    /* ================= RECEIVER ABONNEMENT ================= */
    let receiverTokenExpired = false;

    if (!userReceiver.TokenAbonemment) receiverTokenExpired = true;
    else {
      try {
        jwt.verify(userReceiver.TokenAbonemment, process.env.JWT_SECRET);
      } catch {
        receiverTokenExpired = true;
      }
    }

    let finalReceiverAmount = retraitAmount;
    let fraisAbonnement = 0;

    if (userReceiver.nRecharge === 0 || receiverTokenExpired) {
      if (retraitAmount <= 1) {
        return res.status(400).json({
          message: "Le montant doit être supérieur à 1$ pour activer l’abonnement du bénéficiaire",
        });
      }

      finalReceiverAmount -= 1;
      fraisAbonnement = 1;

      userReceiver.TokenAbonemment = jwt.sign(
        { userId: userReceiver.id, type: "ABONNEMENT" },
        process.env.JWT_SECRET,
        { expiresIn: "1y" }
      );

      userReceiver.nRecharge = (userReceiver.nRecharge || 0) + 1;
    }

    /* ================= UPDATE SOLDES ================= */
    const newSenderSold = senderSold - totalToDebit;
    const newReceiverSold = Number(userReceiver.soldNumber || 0) + finalReceiverAmount;

    await userSender.update({ soldNumber: newSenderSold });
    await userReceiver.update({ soldNumber: newReceiverSold });

    if (ownerItem) {
      const ownerGain = fraisTransaction + fraisAbonnement;
      await ownerItem.update({ soldNumber: Number(ownerItem.soldNumber || 0) + ownerGain });
    }

    /* ================= TRANSACTION ================= */
    const transactionItem = await TransactionRetrait.create({
      amount: retraitAmount,
      fraisTransaction,
      fraisAbonnement,
      id: id,
      targetId: userReceiver.id,
      status: "réussi",
    });

    /* ================= NOTIFICATIONS ================= */
    await Notification.create({
      title: "Retrait réussi ✅",
      message: `Vous avez retiré ${retraitAmount}$ via ${userReceiver.username} (frais: ${fraisTransaction}$).`,
      type: "SUCCESS",
      id: userSender.id,
    });

    await Notification.create({
      title: "Retrait reçu ✅",
      message: `Vous avez reçu ${finalReceiverAmount}$ de ${userSender.username}.`,
      type: "SUCCESS",
      id: userReceiver.id,
    });

    if (fraisAbonnement === 1) {
      await Notification.create({
        title: "Abonnement activé 🎉",
        message: "1$ a été déduit pour activer votre abonnement.",
        type: "INFO",
        id: userReceiver.id,
      });
    }

    /* ================= HISTORY ================= */
    await History.create({
      type: "Retrait",
      amount: retraitAmount,
      status: "réussi",
      description: "Retrait avec frais",
      id: userSender.id,
    });

    return res.status(201).json({
      message: "Retrait effectué avec succès",
      data: transactionItem,
      fraisTransaction,
      fraisAbonnement,
      senderNewSold: newSenderSold,
      receiverNewSold: newReceiverSold,
    });
  } catch (error) {
    console.error(error);

    if (userSender) {
      await Notification.create({
        title: "Échec du retrait ❌",
        message: `Votre tentative de retrait de ${req.body.amount}$ a échoué.`,
        type: "ERROR",
        id: userSender.id,
      });
    }

    if (userReceiver) {
      await Notification.create({
        title: "Échec du retrait ❌",
        message: "Une tentative de retrait a échoué.",
        type: "ERROR",
        id: userReceiver.id,
      });
    }

    return res.status(500).json({ message: "Erreur serveur" });
  }
};



export const createTransfert = async (req, res) => {
  let sender, receiver;

  try {
    const { amount, targetId, id } = req.body;
    const transferAmount = Number(amount);

    /* ================= VALIDATION ================= */
    if (!id || !targetId || !transferAmount) {
      return res.status(400).json({
        message: "Tous les champs sont obligatoires",
      });
    }

    if (transferAmount <= 0) {
      return res.status(400).json({
        message: "Montant invalide",
      });
    }

    /* ================= USERS ================= */
    sender = await User.findByPk(Number(id));
    receiver = await User.findByPk(Number(targetId));

    if (!sender || !receiver) {
      return res.status(404).json({
        message: "Utilisateur introuvable",
      });
    }

    /* ================= OWNER ================= */
    const ownerItem = await User.findOne({
      where: { email: "bimbank@bimreseau.com" },
    });

    /* ================= ABONNEMENT SENDER ================= */
    if (!sender.TokenAbonemment) {
      return res.status(403).json({
        message: "Veuillez d'abord recharger pour activer votre abonnement",
      });
    }

    try {
      jwt.verify(sender.TokenAbonemment, process.env.JWT_SECRET);
    } catch {
      return res.status(403).json({
        message: "Votre abonnement est expiré. Veuillez recharger.",
      });
    }

    /* ================= FRAIS TRANSACTION ================= */
    const percentFee = transferAmount * 0.01;
    const flatFee = 0.5;
    const fraisTransaction = Math.max(percentFee, flatFee);

    const totalToDebit = transferAmount + fraisTransaction;

    /* ================= SOLDE SENDER ================= */
    const senderSold = Number(sender.soldNumber || 0);

    if (totalToDebit > senderSold) {
      return res.status(400).json({
        message: `Solde insuffisant. Total requis: ${totalToDebit}$`,
      });
    }

    /* ================= RECEIVER ABONNEMENT ================= */
    let receiverTokenExpired = false;

    if (!receiver.TokenAbonemment) receiverTokenExpired = true;
    else {
      try {
        jwt.verify(receiver.TokenAbonemment, process.env.JWT_SECRET);
      } catch {
        receiverTokenExpired = true;
      }
    }

    let finalReceiverAmount = transferAmount;
    let fraisAbonnement = 0;

    if (receiver.nRecharge === 0 || receiverTokenExpired) {
      if (transferAmount <= 1) {
        return res.status(400).json({
          message:
            "Le montant doit être supérieur à 1$ pour activer l’abonnement du bénéficiaire",
        });
      }

      finalReceiverAmount -= 1;
      fraisAbonnement = 1;

      receiver.TokenAbonemment = jwt.sign(
        { userId: receiver.id, type: "ABONNEMENT" },
        process.env.JWT_SECRET,
        { expiresIn: "1y" }
      );

      receiver.nRecharge = (receiver.nRecharge || 0) + 1;
    }

    /* ================= UPDATE SOLDES ================= */
    const newSenderSold = senderSold - totalToDebit;
    const newReceiverSold =
      Number(receiver.soldNumber || 0) + finalReceiverAmount;

    await sender.update({ soldNumber: newSenderSold });
    await receiver.update({ soldNumber: newReceiverSold });

    if (ownerItem) {
      const ownerGain = fraisTransaction + fraisAbonnement;
      await ownerItem.update({
        soldNumber: Number(ownerItem.soldNumber || 0) + ownerGain,
      });
    }

    /* ================= TRANSACTION ================= */
    const transactionItem = await TransactionTransfert.create({
      amount: transferAmount,
      fraisTransaction,
      fraisAbonnement,
      id: id,
      targetId: targetId,
      status: "réussi",
    });

    /* ================= NOTIFICATIONS ================= */
    await Notification.create({
      title: "Transfert réussi ✅",
      message: `Vous avez envoyé ${transferAmount}$ (frais: ${fraisTransaction}$).`,
      type: "SUCCESS",
      id: sender.id,
    });

    await Notification.create({
      title: "Fonds reçus ✅",
      message: `Vous avez reçu ${finalReceiverAmount}$ de ${sender.username}.`,
      type: "SUCCESS",
      id: receiver.id,
    });

    if (fraisAbonnement === 1) {
      await Notification.create({
        title: "Abonnement activé 🎉",
        message: "1$ a été déduit pour activer votre abonnement.",
        type: "INFO",
        id: receiver.id,
      });
    }

    /* ================= HISTORY ================= */
    await History.create({
      type: "Transfert",
      amount: transferAmount,
      status: "réussi",
      description: "Transfert avec frais",
      id: sender.id,
    });

    return res.status(201).json({
      message: "Transfert effectué avec succès",
      data: transactionItem,
      fraisTransaction,
      fraisAbonnement,
      senderNewSold: newSenderSold,
      receiverNewSold: newReceiverSold,
    });

  } catch (error) {
    console.error(error);

    if (sender) {
      await Notification.create({
        title: "Échec du transfert ❌",
        message: `Votre tentative d’envoi de ${req.body.amount}$ a échoué.`,
        type: "ERROR",
        id: sender.id,
      });
    }

    return res.status(500).json({
      message: "Erreur serveur",
    });
  }
};


export const recharge = async (req, res) => {
  try {

    const { amount, userId } = req.body;

    if (!userId || !amount) {
      return res.status(400).json({
        message: "Tous les champs obligatoires ne sont pas remplis",
      });
    }

    if (Number(amount) <= 0) {
      return res.status(400).json({
        message: "Montant invalide",
      });
    }

    const userItem = await User.findByPk(userId);
    const ownerItem = await User.findOne({
      where : {
        email : 'bimbank@bimreseau.com'
      }
    })

    if (!userItem) {
      return res.status(404).json({
        message: "Utilisateur introuvable",
      });
    }

    const rechargeAmount = Number(amount);
    const previousRecharge = userItem.nRecharge || 0;

    let finalAmount = rechargeAmount;
    let fraisAbonnement = 0;

    /* ================= VÉRIFIER TOKEN ================= */
    let tokenExpired = false;

    if (!userItem.TokenAbonemment) {
      tokenExpired = true;
    } else {
      try {
        jwt.verify(userItem.TokenAbonemment, process.env.JWT_SECRET);
      } catch (err) {
        console.log(err)
        tokenExpired = true;
      }
    }

    /* ================= FRAIS ================= */
    if (previousRecharge === 0 || tokenExpired) {
      if (rechargeAmount <= 1) {
        return res.status(400).json({
          message: "Le montant doit être supérieur à 1$ pour activer ou renouveler l’abonnement",
        });
      }

      finalAmount = rechargeAmount - 1;
      fraisAbonnement = 1;

      ownerItem.update({
        soldNumber : fraisAbonnement
      })
    }

    /* ================= SOLDE ================= */
    userItem.soldNumber = (userItem.soldNumber || 0) + finalAmount;
    userItem.nRecharge = previousRecharge + 1;

    /* ================= GÉNÉRER TOKEN ================= */
    if (previousRecharge === 0 || tokenExpired) {
      const tokenAbonnement = jwt.sign(
        {
          userId: userItem.id,
          type: "ABONNEMENT",
        },
        process.env.JWT_SECRET,
        { expiresIn: "1y" }
      );

      userItem.TokenAbonemment = tokenAbonnement;
    }

    await userItem.save();
    await Notification.create({
  title: "Recharge réussie ✅",
  message: `Votre compte a été crédité de ${Number(amount)} avec succès. Merci d’avoir utilisé notre service.`,
  type: "SUCCESS",
  id: req.user.id,
});


    return res.status(200).json({
      message: "Recharge effectuée avec succès",
      data: {
        solde: userItem.soldNumber,
        nRecharge: userItem.nRecharge,
        tokenAbonnement: userItem.TokenAbonemment,
        fraisAbonnement,
      },
    });

  } catch (error) {
    await Notification.create({
  title: "Échec de la recharge ❌",
  message: `Votre tentative de recharge de ${Number(amount)} n’a pas abouti. Veuillez réessayer ou contacter le support si le problème persiste.`,
  type: "ERROR",
  id: req.user.id,
});


    console.error("Erreur recharge :", error);

    return res.status(500).json({
      message: "Erreur serveur",
    });
  }
};
export const createRecharge = async (req, res) => {
  try {
    console.log("BODY REÇU 👉", req.body);

    const { amount, telephone, id,PayTypeValue } = req.body;

    if (!id || !amount || !telephone) {
      return res.status(400).json({
        message: "Données manquantes",
      });
    }

    const reference = generateReferenceRecharge();

  
    const transaction = await TransactionRecharge.create({
      amount: Number(amount),
      telephone,
      reference,
      id, 
      status: "pending",
    });

    console.log("Transaction créée ✔️", transaction.transactionRechargeId);

    const payTypeData = {
      'AirtelMoney' : 1,
      'M-Pesa' :  2 ,
       'OrangeMoney' : 3,
        'AfriMoney' : 52
    }

    // ✅ Payload pour MaxiCash PayNowSync

    const payload = {
      "RequestData": {
        "Amount": Number(amount) * 10,
        "Reference": String(reference),
        "Telephone": String(telephone),
      },
      "MerchantID": process.env.MAXICASH_MERCHANT_ID,
      "MerchantPassword": process.env.MAXICASH_MERCHANT_PASSWORD,
      "PayType": payTypeData[String(PayTypeValue)],           // Mobile Money / MaxiCash
      "CurrencyCode": "USD",
    };

    console.log("Payload envoyé 👉", payload);

    const response = await axios.post(
      "https://webapi-test.maxicashapp.com/Integration/PayNowSync",
      payload,
      {
        headers: { "Content-Type": "application/json" },
        timeout: 15000,
      }
    );

    console.log("Réponse MaxiCash 👉", response.data);

    // ✅ Vérification du statut
    const data = response.data;

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
        details: data?.ResponseMessage || data?.Status || "Erreur inconnue",
        status: "failed",
      });
    }
  } catch (error) {
    console.error("ERREUR RECHARGE ❌", error);

    return res.status(500).json({
      message: "Server error",
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
  let sender, receiver, ownerItem;

  try {
    const { amount, targetId, id } = req.body;
    const paiementAmount = Number(amount);

    /* ================= VALIDATION ================= */
    if (!id || !targetId || !paiementAmount) {
      return res.status(400).json({ message: "Tous les champs sont obligatoires" });
    }

    if (paiementAmount <= 0) {
      return res.status(400).json({ message: "Montant invalide" });
    }

    /* ================= USERS ================= */
    sender = await User.findByPk(Number(id));
    receiver = await User.findByPk(Number(targetId));
    ownerItem = await User.findOne({ where: { email: "bimbank@bimreseau.com" } });

    if (!sender || !receiver) {
      return res.status(404).json({ message: "Utilisateur introuvable" });
    }

    /* ================= ABONNEMENT SENDER ================= */
    if (!sender.TokenAbonemment) {
      return res.status(403).json({ message: "Veuillez d'abord recharger pour activer votre abonnement" });
    }

    try {
      jwt.verify(sender.TokenAbonemment, process.env.JWT_SECRET);
    } catch {
      return res.status(403).json({ message: "Votre abonnement est expiré. Veuillez recharger." });
    }

    /* ================= FRAIS ================= */
    const percentFee = paiementAmount * 0.01;
    const flatFee = 0.5;
    const fraisTransaction = Math.max(percentFee, flatFee);
    let totalToDebit = paiementAmount + fraisTransaction;

    /* ================= SOLDES SENDER ================= */
    const senderSold = Number(sender.soldNumber || 0);
    if (totalToDebit > senderSold) {
      return res.status(400).json({ message: `Solde insuffisant. Total requis: ${totalToDebit}$` });
    }

    /* ================= RECEIVER ABONNEMENT ================= */
    let receiverTokenExpired = false;
    if (!receiver.TokenAbonemment) receiverTokenExpired = true;
    else {
      try {
        jwt.verify(receiver.TokenAbonemment, process.env.JWT_SECRET);
      } catch {
        receiverTokenExpired = true;
      }
    }

    let finalReceiverAmount = paiementAmount;
    let fraisAbonnement = 0;

    if (receiver.nRecharge === 0 || receiverTokenExpired) {
      if (paiementAmount <= 1) {
        return res.status(400).json({
          message: "Montant doit être supérieur à 1$ pour activer abonnement",
        });
      }

      finalReceiverAmount -= 1;
      fraisAbonnement = 1;

      const newToken = jwt.sign(
        { userId: receiver.id, type: "ABONNEMENT" },
        process.env.JWT_SECRET,
        { expiresIn: "1y" }
      );

      receiver.TokenAbonemment = newToken;
      receiver.nRecharge = (receiver.nRecharge || 0) + 1;
    }

    /* ================= UPDATE SOLDES ================= */
    const newSenderSold = senderSold - totalToDebit;
    const newReceiverSold = Number(receiver.soldNumber || 0) + finalReceiverAmount;

    await sender.update({ soldNumber: newSenderSold });
    await receiver.update({
      soldNumber: newReceiverSold,
      TokenAbonemment: receiver.TokenAbonemment,
      nRecharge: receiver.nRecharge,
    });

    if (ownerItem) {
      const ownerGain = fraisTransaction + fraisAbonnement;
      await ownerItem.update({ soldNumber: Number(ownerItem.soldNumber || 0) + ownerGain });
    }

    /* ================= TRANSACTION ================= */
    const transactionItem = await TransactionTransfert.create({
      amount: paiementAmount,
      fraisTransaction,
      fraisAbonnement,
      senderId: id,
      receiverId: targetId,
      status: "réussi",
    });

    /* ================= NOTIFICATIONS ================= */
    await Notification.create({
      title: "Paiement réussi ✅",
      message: `Vous avez envoyé ${paiementAmount}$ à ${receiver.username} (frais: ${fraisTransaction}$)`,
      type: "SUCCESS",
      id: sender.id,
    });

    await Notification.create({
      title: "Fonds reçus ✅",
      message: `Vous avez reçu ${finalReceiverAmount}$ de ${sender.username}.`,
      type: "SUCCESS",
      id: receiver.id,
    });

    if (fraisAbonnement === 1) {
      await Notification.create({
        title: "Abonnement activé 🎉",
        message: "1$ a été déduit pour activer votre abonnement.",
        type: "INFO",
        id: receiver.id,
      });
    }

    /* ================= HISTORY ================= */
    await History.create({
      type: "Paiement",
      amount: paiementAmount,
      status: "réussi",
      description: "Paiement avec frais",
      id: sender.id,
    });

    return res.status(201).json({
      message: "Paiement effectué avec succès",
      data: transactionItem,
      fraisTransaction,
      fraisAbonnement,
      senderNewSold: newSenderSold,
      receiverNewSold: newReceiverSold,
    });
  } catch (error) {
    console.error(error);

    if (sender) {
      await Notification.create({
        title: "Échec du paiement ❌",
        message: `Votre tentative de paiement de ${req.body.amount}$ a échoué.`,
        type: "ERROR",
        id: sender.id,
      });
    }

    if (receiver) {
      await Notification.create({
        title: "Échec du paiement ❌",
        message: "Une tentative de paiement a échoué.",
        type: "ERROR",
        id: receiver.id,
      });
    }

    return res.status(500).json({ message: "Erreur serveur" });
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

/* eslint-disable no-undef */
import jwt from 'jsonwebtoken';
import { User, Notification } from '../models/index.js';
import { generateSupportReceivedEmailTemplateRecharge } from '../utils/templateMails.util.js';
import nodemailer from 'nodemailer';
import sequelize from '../config/database.js';
/* ─── CONFIG ────────────────────────────────────────────────────────── */
const FRAIS_ABONNEMENT = 1;
const OWNER_EMAIL      = 'bimbank@bimreseau.com';

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
  const t = await sequelize.transaction();

  let amount    = 0;
  let ownerItem = null;
  let userItem  = null;

  try {
    const { amount: bodyAmount, userId } = req.body;
    amount = Number(bodyAmount);

    /* ── 1. Validation ── */
    if (!userId) {
      await t.rollback();
      return res.status(400).json({ message: "userId est obligatoire" });
    }
    if (!bodyAmount || isNaN(amount) || amount <= 0) {
      await t.rollback();
      return res.status(400).json({ message: "Montant invalide" });
    }

    /* ── 2. Récupérer l'utilisateur ── */
    userItem = await User.findOne({
      where:       { id: userId },
      transaction: t,
      lock:        t.LOCK.UPDATE,
    });
    if (!userItem) {
      await t.rollback();
      return res.status(404).json({ message: "Utilisateur introuvable" });
    }

    /* ── 3. Vérifier abonnement ── */
    const previousRecharge = Number(userItem.nRecharge) || 0;
    const aDejaAbonnement  = previousRecharge > 0 && isTokenValid(userItem.TokenAbonemment);

    /* ── 4. Calcul du montant crédité ── */
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

      // Créditer le owner BIM des frais
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

      // Générer token abonnement 1 an
      userItem.TokenAbonemment = jwt.sign(
        { userId: userItem.id, type: "ABONNEMENT" },
        process.env.JWT_SECRET,
        { expiresIn: "1y" }
      );
    }

    /* ── 5. Créditer solde ── */
    const ancienSolde   = Number(userItem.soldNumber) || 0;
    userItem.soldNumber  = ancienSolde + montantCredite;
    userItem.nRecharge   = previousRecharge + 1;

    await userItem.save({ transaction: t });

    /* ── 6. Transaction générique (table Transaction) ── */
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

    /* ── 7. Notification ── */
    await Notification.create(
      {
        title:   "Recharge réussie ✅",
        message: aDejaAbonnement
          ? `Votre compte a été crédité de ${montantCredite} EC. Aucun frais prélevé.`
          : `Votre compte a été crédité de ${montantCredite} EC — abonnement annuel activé (-${fraisAbonnement} EC).`,
        type:    "SUCCESS",   // ✅ ENUM correct
        userId:  userItem.id, // ✅ userId avec I majuscule
      },
      { transaction: t }
    );

    /* ── 8. Historique ── */
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

    /* ── 9. COMMIT ── */
    await t.commit();

    /* ── 10. Réponse immédiate ── */
    res.status(200).json({
      message: "Recharge effectuée avec succès",
      data: {
        solde:           userItem.soldNumber,
        nRecharge:       userItem.nRecharge,
        fraisAbonnement,
        montantCredite,
        abonnementActif: true,
      },
    });

    /* ── 11. Email fire & forget (après commit + réponse)
            L'email ne bloque jamais le client ── */
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
    /* ── Rollback ── */
    try { await t.rollback(); } catch { /* déjà commitée — ignorer */ }

    console.error("[recharge] Erreur :", error);

    /* ── Transaction ÉCHEC hors transaction ── */
    if (userItem) {
      try {
        await Transaction.create({
          amount:          amount || 0,
          status:          "échoué",
          description:     "Recharge échouée",
          transactionType: "recharge",
          id:              userItem.id,
        });
      } catch (trxError) {
        console.error("[recharge] Erreur transaction échec :", trxError.message);
      }

      /* ⚠️  "ERREUR" avec accent (jamais "ERROR")
         ⚠️  "userId" avec I majuscule (jamais "userid") ── */
      try {
        await Notification.create({
          title:   "Échec de la recharge ❌",
          message: `Votre tentative de recharge de ${amount} EC n'a pas abouti. Veuillez réessayer.`,
          type:    "ERREUR",    // ✅
          userId:  userItem.id, // ✅
        });
      } catch (notifError) {
        console.error("[recharge] Erreur notification échec :", notifError.message);
      }

      /* Historique échec */
      try {
        await History.create({
          type:        "Recharge",
          amount:      amount || 0,
          status:      "échoué",
          description: "Recharge échouée",
          action:      "Recharge EC ❌",
          userId:      userItem.id,
        });
      } catch (histError) {
        console.error("[recharge] Erreur history échec :", histError.message);
      }
    }

    if (!res.headersSent) {
      return res.status(500).json({ message: "Erreur serveur", error: error.message });
    }
  }
};
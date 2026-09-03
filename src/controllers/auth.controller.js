/* eslint-disable no-undef */
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { User, Role, BranchTrack, Commerce, Company, BusinessCategory, Order, Transaction, UserSOS } from '../models/index.js';
import sequelize from '../config/database.js';
import { Op } from 'sequelize';
import crypto from 'crypto';
import { mailer, sendEmail } from '../utils/sendEmail.utils.js';
import { emitSOSAlert } from '../services/socket.service.js';
import path from 'path';
import fs from 'fs';
import { generateNewLoginAlertEmailTemplate,generateTransactionPasswordEmailTemplate, generateOtpEmailTemplate, generateOtpEmailTemplateActivated } from '../utils/templateMails.util.js';
import { generateAccountNumber,generateAccountNumberAgent} from '../utils/generateAccountNumber.util.js';
import { generatePassword6Digits,getFormattedDateTime} from '../utils/calculFrais.util.js';
import { getDateRangeByPeriod } from '../utils/getDateRangeByPeriod.util.js';
const generateOtp = () => {
  return Math.floor(100000 + Math.random() * 900000).toString(); // OTP 6 chiffres
};


const register = async (req, res) => {
  const { username, email, password, privacyAcceptedAt } = req.body;
  try {
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ message: 'E-mail déjà utilisé' });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const otp = generateOtp();
    const otpExpires = new Date(Date.now() + 30 * 60 * 1000);

    const newUser = await User.create({
      username,
      email,
      password: hashedPassword,
      otp,
      otpExpires,
      isActive: false,
      accountNumber: String(generateAccountNumber()),
      privacyAcceptedAt: privacyAcceptedAt ? new Date(privacyAcceptedAt) : new Date()
    });

    
    await mailer.sendMail({
      from: 'noreply@bimreseau.com',
      to: email,
      subject: 'Activation de votre compte Bim',
      html: generateOtpEmailTemplate(username,otp),
    });


    res.status(201).json({
      message: 'Utilisateur enregistré avec succès. Veuillez vérifier votre email pour l’OTP.',
      user: { id: newUser.id, username: newUser.username, email: newUser.email },
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};



const createAgent = async (req, res) => {
  const { username, email, password } = req.body;
  try {
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ message: 'E-mail déjà utilisé' });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const otp = generateOtp();
    const otpExpires = new Date(Date.now() + 30 * 60 * 1000);

    const newUser = await User.create({
      username,
      email,
      password: hashedPassword,
      otp,
      otpExpires,
      isActive: true,
      isAgent :true,
      accountNumber: String(generateAccountNumberAgent())
    });

    
    await mailer.sendMail({
      from: 'noreply@bimreseau.com',
      to: email,
      subject: 'Activation de votre compte Bim',
      html: generateOtpEmailTemplate(username,otp),
    });


    res.status(201).json({
      message: 'Utilisateur enregistré avec succès. Veuillez vérifier votre email pour l’OTP.',
      user: { id: newUser.id, username: newUser.username, email: newUser.email },
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

const login = async (req, res) => {
  const { email, password, device, location, appVersion } = req.body;
  try {
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    }

    // Compte verrouillé après 3 tentatives incorrectes
    if (user.lockUntil && user.lockUntil > new Date()) {
      return res.status(423).json({
        message: 'Compte verrouillé après 3 tentatives incorrectes. Veuillez réinitialiser votre mot de passe.',
        locked: true,
      });
    }

    // Compte inactif
    if (!user.isActive) {
      return res.status(409).json({
        message: 'This process cannot be completed because your account is not yet activated.',
      });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      const newAttempts = (user.loginAttempts || 0) + 1;

      if (newAttempts >= 3) {
        await user.update({
          loginAttempts: newAttempts,
          isActive: false,
          lockUntil: new Date(Date.now() + 24 * 60 * 60 * 1000),
        });
        return res.status(423).json({
          message: 'Compte désactivé après 3 tentatives incorrectes. Veuillez réinitialiser votre mot de passe.',
          locked: true,
        });
      }

      await user.update({ loginAttempts: newAttempts });
      return res.status(401).json({
        message: 'Mot de passe incorrect',
        remainingAttempts: 3 - newAttempts,
      });
    }

    // Mot de passe correct — réinitialiser compteur de tentatives
    const refreshToken = jwt.sign(
      { userId: user.id, email: user.email },
      process.env.JWT_REFRESH_SECRET,
      { expiresIn: '7d' }
    );
    const token = jwt.sign({ userId: user.id, email: user.email }, process.env.JWT_SECRET, {
      expiresIn: '2h',
    });

    await user.update({ refreshToken, Token: token, loginAttempts: 0, lockUntil: null });

    // Récupération du rôle réel et du companyId
    const userRoleRecord = await sequelize.models.UserRole.findOne({ where: { userId: user.id } });
    let roleName = null;
    let companyId = null;
    if (userRoleRecord) {
      const roleRecord = await Role.findByPk(userRoleRecord.roleId);
      roleName = roleRecord?.name ?? null;
      companyId = userRoleRecord.companyId ?? null;
    }

    // Email alerte connexion (fire & forget)
    try {
      await mailer.sendMail({
        from: 'noreply@bimreseau.com',
        to: email,
        subject: 'Alerte de sécurité – Connexion détectée sur votre compte BIM NEXT',
        html: generateNewLoginAlertEmailTemplate(user.username, device, location, appVersion, user.createdAt),
      });
    } catch (emailErr) {
      console.error('[login] Erreur email alerte :', emailErr.message);
    }

    return res.status(200).json({
      message: 'Login successful',
      token,
      refreshToken,
      status: user.isActive,
      role: roleName,
      companyId,
      userId: user.id,
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};


const logOut = async (req, res) => {
console.log(req.body)

  const { email} = req.body;
  try {
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    }

    user.update({
      Token : null,
      refreshToken:null,
    })

    res.status(200).json({
      message : "success"
    })
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

const askPasswordReset = async (req, res) => {
  const { email } = req.body;
  try {
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    } else {
      if (!user.isActive) {
        return res.status(409).json({
          message: 'This process cannot be completed because your account is not yet activated.',
        });
      }

      const resetToken = crypto.randomBytes(32).toString('hex');
      const resetTokenExpiry = Date.now() + 3600000;

          const otp = generateOtp();
          const otpExpires = new Date(Date.now() + 30 * 60 * 1000);

      await user.update(
        {
          otp:otp,
          otpExpires:otpExpires,
          resetPasswordToken: resetToken,
          resetPasswordExpiresAt: resetTokenExpiry,
        },
        { where: { id: user.id } }
      );

      // On attend l'envoi pour pouvoir remonter une vraie erreur si le mail échoue
      // (avant, la réponse "envoyé" partait avant même de savoir si ça marchait,
      // ce qui rendait le problème invisible côté utilisateur ET côté logs).
      const sent = await sendEmail({
        to: email,
        subject: 'Activation de votre compte Bim',
        html: generateOtpEmailTemplate(user.username, otp),
      });

      if (!sent) {
        return res.status(502).json({
          message: "L'envoi de l'e-mail a échoué. Réessayez dans quelques instants ou contactez le support.",
        });
      }

      res.status(200).json({
        message: 'Un code otp a été envoyé à votre adresse e-mail.',
        userId: user.id,
      });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};
const resetPassword = async (req, res) => {
  const { userId, newPassword } = req.body;
  try {
    const user = await User.findOne({ where: { id: userId } });

    if (!user) {
      return res.status(400).json({ message: 'Utilisateur introuvable' });
    }

    // Vérifier la limite de 2 réinitialisations par jour
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const lastReset = user.lastPasswordResetDate ? new Date(user.lastPasswordResetDate) : null;
    const isToday = lastReset && lastReset >= today;
    const resetCount = isToday ? (user.passwordResetCount || 0) : 0;

    if (resetCount >= 2) {
      return res.status(429).json({
        message: 'Vous avez atteint la limite de 2 réinitialisations de mot de passe par jour. Réessayez demain.',
      });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await user.update({
      password: hashedPassword,
      loginAttempts: 0,
      lockUntil: null,
      isActive: true,
      passwordResetCount: resetCount + 1,
      lastPasswordResetDate: new Date(),
    });

    return res.status(200).json({ message: 'Mot de passe réinitialisé avec succès', userId: user.id });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

const getAllUsers = async (req, res) => {
  try {
    const {
      search,
      paginate = 'false',
      page = 1,
      pageSize = 20,
      commerceId,
      branchTrackId,
      createdAtFrom,
      createdAtTo,
    } = req.query;

    const isPaginate = paginate === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

     const whereClause = {
      email: {
        [Op.ne]: 'bimbank@bimreseau.com', // 👈 exclure cet utilisateur
      },
    };

  
    if (commerceId) {
      whereClause.commerceId = commerceId;
    }

  
    if (commerceId && branchTrackId) {
      whereClause[Op.and] = [
        {
          [Op.or]: [
            { branchTrackId },
            { branchTrackId: null }, 
          ],
        },
      ];
    }

  
    if (search) {
      whereClause[Op.and] = [
        ...(whereClause[Op.and] || []),
        {
          [Op.or]: [
            { username: { [Op.like]: `%${search}%` } },
            { email: { [Op.like]: `%${search}%` } },
             { fullname: { [Op.like]: `%${search}%` } },
          ],
        },
      ];
    }

    if (createdAtFrom || createdAtTo) {
      const dateWhere = {};
      if (createdAtFrom) dateWhere[Op.gte] = new Date(createdAtFrom);
      if (createdAtTo) {
        const end = new Date(createdAtTo);
        end.setHours(23, 59, 59, 999);
        dateWhere[Op.lte] = end;
      }
      whereClause.createdAt = dateWhere;
    }

    const queryOptions = {
      where: whereClause,
        attributes: {
    exclude: [
      'password',
      'otp',
      'otpExpires',
      'resetPasswordToken',
      'resetPasswordExpiresAt',
      'refreshToken',
      'token',
      'TokenAbonemment',
    ],
  },
      include: [{ model: Role, as: 'role' },{model : BranchTrack, as : 'branchTrack'},{model:Commerce,as:'commerce'}],
      order: [['createdAt', 'ASC']],
    };

    if (isPaginate) {
      const { rows, count } = await User.findAndCountAll({
        ...queryOptions,
        limit,
        offset,
      });

      return res.status(200).json({
        message: 'Requête passée avec succès',
        data: rows,
        pagination: {
          total: count,
          page: currentPage,
          pageSize: limit,
          totalPages: Math.ceil(count / limit),
        },
      });
    }

    const users = await User.findAll({ ...queryOptions, limit: 1000 });

    return res.status(200).json({
      message: 'Requête passée avec succès',
      data: users,
      total: users.length,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Server error',
      error: error.message,
    });
  }
};
const getUserById = async (req, res) => {
  const { id } = req.params;
  try {
    const user = await User.findByPk(id,{
      include: [{ model: Role, as: 'role' },{model : BranchTrack, as : 'branchTrack'},{model:Commerce,as:'commerce'}],
    });
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    }
    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};


const updateUserProfile = async (req, res) => {
  const { id } = req.params;
  const { username, email, keyRole, isActive, imageUrl } = req.body;
  try {
    const user = await User.findByPk(id);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    } else {
      await User.update(
        { username, email, keyRole, isActive, imageUrl },
        { where: { id: user.id } }
      );
      return res.status(200).json({ message: 'Profil utilisateur mis à jour avec succès' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

export const updateUser = async (req, res) => {
  try {
    

    const { id } = req.params;

    if (!id) {
      return res.status(400).json({
        message: "User ID is required",
      });
    }

    if (isNaN(Number(id))) {
      return res.status(400).json({
        message: "Invalid user ID",
      });
    }

    const userExist = await User.findByPk(id);
    
    if (!userExist) {
      return res.status(404).json({
        message: "User not found",
      });
    }

  
    const allowedFields = {};
    
    // Mappage des noms frontend vers base de données
    if (req.body.username) allowedFields.username = req.body.username;
    if (req.body.fullname) allowedFields.fullname = req.body.fullname; // ou le nom de colonne correct
    if (req.body.email) allowedFields.email = req.body.email;
    if (req.body.poste) allowedFields.poste = req.body.poste;
    if (req.body.telephone) allowedFields.telephone = req.body.telephone;
    if (req.body.adresse) allowedFields.adresse = req.body.adresse;

 
    let imageUrl = userExist.imageUrl;

    if (req.file) {
      if (!req.file.mimetype.startsWith("image/")) {
        return res.status(400).json({
          message: "Invalid image file",
        });
      }

      if (userExist.imageUrl) {
        try {
          const oldImagePath = path.join(
            "public",
            userExist.imageUrl.replace("/images/", "images/")
          );
          
          if (fs.existsSync(oldImagePath)) {
            fs.unlinkSync(oldImagePath);
          }
        } catch (fsError) {
          console.error("Erreur suppression ancienne image:", fsError);
         
        }
      }

      imageUrl = `/images/${req.file.filename}`;
    }

    if (Object.keys(allowedFields).length === 0 && !req.file) {
      return res.status(400).json({
        message: "No data provided for update",
      });
    }

    const updateData = {
      ...allowedFields,
      imageUrl,
    };

    console.log("📤 Données à mettre à jour:", updateData);

    const [updatedRows] = await User.update(updateData, { 
      where: { id } 
    });

    if (updatedRows === 0) {
      return res.status(400).json({
        message: "No changes were made",
      });
    }

    const updatedUser = await User.findByPk(id, {
      attributes: ["id", "username", "email", "fullname", "poste", "telephone", "adresse", "imageUrl"],
    });

    return res.status(200).json({
      message: "User updated successfully",
      data: updatedUser,
    });

  } catch (error) {
    // console.error("🚨 UPDATE USER ERROR:", error);
    // console.error("🚨 Stack trace:", error.stack);
    // console.error("🚨 Error message:", error.message);

    return res.status(500).json({
      message: "Internal server error",
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};


const updateUserPassword = async (req, res) => {
  const { id } = req.params;
  const { currentPassword, newPassword } = req.body;
  try {
    const user = await User.findByPk(id);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    }
    const isPasswordValid = await bcrypt.compare(currentPassword, user.password);
    if (!isPasswordValid) {
      return res.status(400).json({ message: 'Mot de passe actuel incorrect' });
    }
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await User.update({ password: hashedPassword }, { where: { id: user.id } });
    return res.status(200).json({ message: 'Mot de passe mis à jour avec succès' });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};
const desactivateUser = async (req, res) => {
  const { id } = req.params;
  try {
    const user = await User.findByPk(id);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    }

    const isActiveUser = user.isActive;

    if (isActiveUser) {
      await User.update({ isActive: false }, { where: { id: user.id } });

    
    await mailer.sendMail({
      from: 'noreply@bimreseau.com',
      to: email,
      subject: 'Activation de votre compte Bim',
      html: generateOtpEmailTemplateActivated(user.username),
    });

      return res.status(200).json({ message: 'Utilisateur désactivé avec succès' });
    } else {
      await User.update({ isActive: true }, { where: { id: user.id } });
      return res.status(200).json({ message: 'Utilisateur activé avec succès' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};
export const blockUser = async (req, res) => {
  const { id } = req.params;
  try {
    const user = await User.findByPk(id);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    }

    const isActiveUser = user.isBlocked;

    if (isActiveUser) {
      await User.update({ isBlocked: false }, { where: { id: user.id } });
       
      return res.status(200).json({ message: 'Utilisateur désactivé avec succès' });
    } else {
      await User.update({ isBlocked: true }, { where: { id: user.id } });
      return res.status(200).json({ message: 'Utilisateur activé avec succès' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};
const deleteUser = async (req, res) => {
  try {
    const { id } = req.params;
    const userItem = await User.findOne({
      where: { id },
    });

    if (!userItem) {
      return res.status(404).json({ message: 'User not found' });
    }
    if (userItem.imageUrl) {
      const imagePath = path.join('public', userItem.imageUrl.replace('/images/', 'images/'));

      if (fs.existsSync(imagePath)) {
        fs.unlinkSync(imagePath);
      }
    }

    await User.destroy({
      where: { id },
    });

    res.status(200).json({ message: 'User and its image deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
const refreshToken = async (req, res) => {
  const { refreshToken } = req.body;
  try {
    if (!refreshToken) {
      return res.status(400).json({ message: 'Refresh token is required' });
    }
    const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
    const user = await User.findOne({ where: { id: decoded.userId, refreshToken } });
    if (!user) {
      return res.status(401).json({ message: 'Invalid refresh token' });
    }
    const newToken = jwt.sign({ userId: user.id, email: user.email }, process.env.JWT_SECRET, {
      expiresIn: '1h',
    });
    return res.status(200).json({ token: newToken });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};
const getMe = async (req, res) => {
  try {
    const { id } = req.params;
    const parsedId = Number(id);

    if (!id || isNaN(parsedId)) {
      return res.status(400).json({ message: 'Invalid Category ID' });
    }

    const user = await User.findByPk(id);

    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    }
    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};
 const createUsers = async (req, res) => {
  const users = req.body;

  if (!Array.isArray(users) || users.length === 0) {
    return res.status(400).json({ message: "Veuillez fournir un tableau d'utilisateurs." });
  }

  try {
    // Récupérer les emails déjà existants en une seule requête
    const emails = users.map((u) => u.email);
    const existing = await User.findAll({ where: { email: emails }, attributes: ['email'] });
    const existingEmails = new Set(existing.map((u) => u.email));

    // Filtrer et hasher les mots de passe en parallèle
    const newUsersData = await Promise.all(
      users
        .filter((u) => !existingEmails.has(u.email))
        .map(async ({ username, email, password }) => ({
          username,
          email,
          password: await bcrypt.hash(password, 10),
        }))
    );

    if (newUsersData.length === 0) {
      return res.status(200).json({ message: "Tous les utilisateurs existent déjà.", users: [] });
    }

    const created = await User.bulkCreate(newUsersData, { returning: true });

    res.status(201).json({
      message: "Utilisateurs créés avec succès",
      users: created.map((u) => ({ id: u.id, username: u.username, email: u.email })),
    });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};


const verifyOtp = async (req, res) => {
  try {
    const { otp } = req.body;

    if (!otp) {
      return res.status(400).json({
        message: "OTP_REQUIRED",
        error: "Le code OTP est requis"
      });
    }

    
    if (!/^[0-9]{6}$/.test(otp)) {
      return res.status(400).json({
        message: "INVALID_OTP_FORMAT",
        error: "Le code OTP doit contenir 6 chiffres"
      });
    }


    const user = await User.findOne({
      where: {
        otp,
        otpExpires: {
          [Op.gt]: new Date()
        }
      }
    });


    if (!user) {
      return res.status(400).json({
        message: "OTP_INVALID_OR_EXPIRED",
        error: "Code OTP invalide ou expiré"
      });
    }

    const pwd = generatePassword6Digits()
  const hashedPassword = await bcrypt.hash(pwd, 10);
    
const dateTime = getFormattedDateTime();

    
    await mailer.sendMail({
      from: 'noreply@bimreseau.com',
      to: user.email,
      subject: `Votre mot de passe de transaction BIM NEXT 🔐 — Créé le ${dateTime}`,
      html: generateTransactionPasswordEmailTemplate(user.username,pwd),
    });

 


   
    await user.update({
      isActive: true,
      otp: null,
      otpExpires: null,
      randomly: hashedPassword,
      randomlyPlain: pwd,
    });
    return res.status(200).json({
      message: "OTP_VERIFIED_SUCCESS",
      userId: user.id
    });

  } catch (error) {
    console.error("VERIFY OTP ERROR:", error);

    return res.status(500).json({
      message: "SERVER_ERROR",
      error: "Une erreur interne est survenue"
    });
  }
};

const storeExpoPushToken = async (req, res) => {
  try {
    const { tokenPush } = req.body;
    const { userId } = req.params;  

    if (!tokenPush) {
      return res.status(400).json({
        message: "TOKEN_REQUIRED",
        error: "Le token Expo Push est requis"
      });
    }

    const user = await User.findByPk(userId);

    if (!user) {
      return res.status(404).json({
        message: "USER_NOT_FOUND",
        error: "Utilisateur introuvable"
      });
    }

    
    await user.update({
      expoPushToken: tokenPush
    });

    return res.status(200).json({
      message: "EXPO_PUSH_TOKEN_STORED",
      userId: user.id
    });

  } catch (error) {
    console.error("STORE EXPO PUSH TOKEN ERROR:", error);

    return res.status(500).json({
      message: "SERVER_ERROR",
      error: "Une erreur interne est survenue"
    });
  }
};


const veryfUserPass = async (req, res) => {
  const { userId, password } = req.body;
  try {
    const user = await User.findByPk(userId)
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    } 

    const isPasswordValid = await bcrypt.compare(password, user.randomly);
  if (!isPasswordValid) {
        return res.status(401).json({ message: 'Invalid password' });
      }


  if (!user.isActive) {
          return res.status(409).json({
            message: 'This process cannot be completed because your account is not yet activated.',
          });
        }


  return res.status(200).json({
          message: 'Login successful',
          
        });

  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};
/* ─────────────────────────────────────────────────────────────────────────
   Suppression de compte par l'utilisateur lui-même
   ───────────────────────────────────────────────────────────────────────── */
const deleteAccount = async (req, res) => {
  try {
    const user = req.user; // injecté par authMiddleware
    const { password } = req.body;

    /* ── 1. Vérification mot de passe ── */
    if (!password) {
      return res.status(400).json({ message: "Le mot de passe est requis pour supprimer le compte." });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: "Mot de passe incorrect." });
    }

    /* ── 2. Supprimer l'image de profil si elle existe ── */
    if (user.imageUrl) {
      try {
        const imagePath = path.join('public', user.imageUrl.replace('/images/', 'images/'));
        if (fs.existsSync(imagePath)) {
          fs.unlinkSync(imagePath);
        }
      } catch (imgErr) {
        console.error("[deleteAccount] Erreur suppression image :", imgErr.message);
      }
    }

    /* ── 3. Sauvegarder infos pour l'email avant destruction ── */
    const { email, username } = user;
    const uid = user.id;

    /* ── 4. Suppression manuelle des enregistrements liés ──
            Les contraintes FK en DB n'ont pas ON DELETE CASCADE
            (seulement ON UPDATE CASCADE) → on supprime dans l'ordre ── */
    const q = (sql) => sequelize.query(sql, { replacements: { uid } });

    // Tables dont la colonne FK s'appelle "id" (références à users.id)
    await q('DELETE FROM `notifications`           WHERE `userId`  = :uid');
    await q('DELETE FROM `histories`               WHERE `userId`  = :uid');
    await q('DELETE FROM `UserRoles`               WHERE `userId`  = :uid');
    await q('DELETE FROM `transactions`            WHERE `id`      = :uid');
    await q('DELETE FROM `transactionsRetrait`     WHERE `id`      = :uid');
    await q('DELETE FROM `transactionsTransfert`   WHERE `id`      = :uid');
    await q('DELETE FROM `transactionsRecharge`    WHERE `id`      = :uid');
    await q('DELETE FROM `transactions_recharge`   WHERE `userId`  = :uid');

    // Supprimer l'utilisateur (les tables avec SET NULL s'auto-gèrent)
    await user.destroy();

    /* ── 5. Réponse ── */
    res.status(200).json({ message: "Votre compte a été supprimé définitivement." });

    /* ── 6. Email de confirmation (fire & forget) ── */
    try {

      await mailer.sendMail({
        from:    'noreply@bimreseau.com',
        to:      email,
        subject: 'Confirmation de suppression de votre compte BIM NEXT',
        html: `
          <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;">
            <h2 style="color:#e74c3c;">Compte supprimé</h2>
            <p>Bonjour <strong>${username}</strong>,</p>
            <p>Votre compte BIM NEXT a été supprimé définitivement le
               <strong>${new Date().toLocaleDateString('fr-FR')} à ${new Date().toLocaleTimeString('fr-FR')}</strong>.</p>
            <p>Toutes vos données personnelles ont été effacées de nos systèmes.</p>
            <p>Si vous n'êtes pas à l'origine de cette action, contactez immédiatement notre support.</p>
            <hr/>
            <small style="color:#999;">BIM NEXT — noreply@bimreseau.com</small>
          </div>
        `,
      });
    } catch (emailErr) {
      console.error("[deleteAccount] Erreur email (non critique) :", emailErr.message);
    }

  } catch (error) {
    console.error("[deleteAccount] Erreur :", error);
    if (!res.headersSent) {
      return res.status(500).json({ message: "Erreur serveur", error: error.message });
    }
  }
};

export const updateSoldNumber = async (req, res) => {
  const { id } = req.params;
  const { soldNumber } = req.body;
  try {
    if (soldNumber === undefined || soldNumber === null) {
      return res.status(400).json({ message: 'soldNumber est requis' });
    }
    const value = parseFloat(soldNumber);
    if (isNaN(value) || value < 0 || value > 5000) {
      return res.status(400).json({ message: 'soldNumber invalide (0 - 5000)' });
    }
    const user = await User.findByPk(id);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    }
    await user.update({ soldNumber: value });
    return res.status(200).json({ message: 'soldNumber mis à jour avec succès', soldNumber: value });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// ─── Étape 1 : Demande de reset admin BIM → envoie OTP par email ─────────────
export const requestBimReset = async (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ message: 'Email requis' });

  try {
    const user = await User.findOne({ where: { email } });
    if (!user) return res.status(404).json({ message: 'Aucun compte trouvé avec cet email' });

    const bimRole = await Role.findOne({ where: { name: 'BIM' } });
    if (!bimRole) return res.status(403).json({ message: 'Aucun rôle BIM configuré' });

    const userRole = await sequelize.models.UserRole.findOne({ where: { userId: user.id, roleId: bimRole.id } });
    if (!userRole) return res.status(403).json({ message: 'Ce compte n\'est pas un administrateur BIM' });

    const otp = generateOtp();
    const otpExpires = new Date(Date.now() + 15 * 60 * 1000); // 15 min

    await user.update({ otp, otpExpires });

    await mailer.sendMail({
      from: 'noreply@bimreseau.com',
      to: email,
      subject: 'BIM Admin — Code de réinitialisation',
      html: generateOtpEmailTemplate(user.username, otp),
    });

    return res.status(200).json({ message: 'Un code OTP a été envoyé à votre adresse email.' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Étape 2 : Vérification OTP + nouveau mot de passe ───────────────────────
export const resetBimAdminPassword = async (req, res) => {
  const { email, otp, newPassword } = req.body;
  if (!email || !otp || !newPassword) {
    return res.status(400).json({ message: 'Email, OTP et nouveau mot de passe requis' });
  }
  if (newPassword.length < 6) {
    return res.status(400).json({ message: 'Le mot de passe doit contenir au moins 6 caractères' });
  }
  try {
    const user = await User.findOne({ where: { email } });
    if (!user) return res.status(404).json({ message: 'Compte introuvable' });

    if (!user.otp || user.otp !== otp) {
      return res.status(400).json({ message: 'Code OTP incorrect' });
    }
    if (!user.otpExpires || new Date() > new Date(user.otpExpires)) {
      return res.status(400).json({ message: 'Code OTP expiré. Recommencez la procédure.' });
    }

    const bimRole = await Role.findOne({ where: { name: 'BIM' } });
    const userRole = bimRole
      ? await sequelize.models.UserRole.findOne({ where: { userId: user.id, roleId: bimRole.id } })
      : null;
    if (!userRole) return res.status(403).json({ message: 'Ce compte n\'est pas un administrateur BIM' });

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await user.update({
      password: hashedPassword,
      otp: null,
      otpExpires: null,
      loginAttempts: 0,
      lockUntil: null,
      isActive: true,
    });

    return res.status(200).json({ message: 'Mot de passe mis à jour. Vous pouvez vous connecter.' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Bootstrap : premier compte BIM Admin (public, une seule fois) ───────────
export const bootstrapAdmin = async (req, res) => {
  const { username, email, password } = req.body;
  if (!username || !email || !password) {
    return res.status(400).json({ message: 'username, email et password sont requis' });
  }
  try {
    const [bimRole] = await Role.findOrCreate({
      where: { name: 'BIM' },
      defaults: { name: 'BIM', description: 'Administrateur BIM — accès global' },
    });

    const existingAdmin = await sequelize.models.UserRole.findOne({ where: { roleId: bimRole.id } });
    if (existingAdmin) {
      return res.status(403).json({ message: 'Un administrateur BIM existe déjà. Utilisez la page de connexion.' });
    }

    const existingEmail = await User.findOne({ where: { email } });
    if (existingEmail) return res.status(400).json({ message: 'Email déjà utilisé' });

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = await User.create({
      username,
      email,
      password: hashedPassword,
      isActive: true,
      accountNumber: String(generateAccountNumber()),
    });

    await sequelize.models.UserRole.create({ userId: newUser.id, roleId: bimRole.id });

    return res.status(201).json({
      message: 'Compte administrateur BIM créé. Vous pouvez maintenant vous connecter.',
      user: { id: newUser.id, username: newUser.username, email: newUser.email },
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Dashboard Stats ─────────────────────────────────────────────────────────
export const getDashboardStats = async (req, res) => {
  try {
    const { period } = req.query;

    const now = new Date();
    const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0);

    let periodStart = null;
    if (period) {
      periodStart = getDateRangeByPeriod(period);
    }

    const periodWhere = periodStart ? { createdAt: { [Op.gte]: periodStart } } : {};

    const [
      totalUsers,
      usersToday,
      activeUsers,
      blockedUsers,
      totalTransactions,
      totalOrders,
      totalCompanies,
      totalSectors,
    ] = await Promise.all([
      User.count({ where: { email: { [Op.ne]: 'bimbank@bimreseau.com' } } }),
      User.count({ where: { createdAt: { [Op.gte]: startOfToday }, email: { [Op.ne]: 'bimbank@bimreseau.com' } } }),
      User.count({ where: { isActive: true, email: { [Op.ne]: 'bimbank@bimreseau.com' } } }),
      User.count({ where: { isBlocked: true } }),
      Transaction.count({ where: periodWhere }),
      Order.count({ where: periodWhere }),
      Company.count(),
      BusinessCategory.count(),
    ]);

    return res.status(200).json({
      totalUsers,
      usersToday,
      activeUsers,
      blockedUsers,
      totalTransactions,
      totalOrders,
      totalCompanies,
      totalSectors,
      period: period || 'all',
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Création compte BIM Admin ───────────────────────────────────────────────
export const createBimAdmin = async (req, res) => {
  const { username, email, password } = req.body;
  if (!username || !email || !password) {
    return res.status(400).json({ message: 'username, email et password sont requis' });
  }
  try {
    const existing = await User.findOne({ where: { email } });
    if (existing) return res.status(400).json({ message: 'Email déjà utilisé' });

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = await User.create({
      username,
      email,
      password: hashedPassword,
      isActive: true,
      accountNumber: String(generateAccountNumber()),
    });

    // Chercher ou créer le rôle BIM
    const [bimRole] = await Role.findOrCreate({
      where: { name: 'BIM' },
      defaults: { name: 'BIM', description: 'Administrateur BIM — accès global' },
    });

    await sequelize.models.UserRole.create({ userId: newUser.id, roleId: bimRole.id });

    return res.status(201).json({
      message: 'Compte BIM Admin créé avec succès',
      user: { id: newUser.id, username: newUser.username, email: newUser.email, role: 'BIM' },
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Création compte Entreprise (company + admin user) ────────────────────────
export const createCompanyAccount = async (req, res) => {
  const { company, admin } = req.body;

  if (!company?.name || !company?.email) {
    return res.status(400).json({ message: "Le nom et l'email de l'entreprise sont requis" });
  }
  if (!admin?.username || !admin?.email || !admin?.password) {
    return res.status(400).json({ message: "username, email et password de l'admin sont requis" });
  }

  const t = await sequelize.transaction();
  try {
    const existingCompany = await sequelize.models.Company.findOne({ where: { email: company.email }, transaction: t });
    if (existingCompany) {
      await t.rollback();
      return res.status(400).json({ message: "Email entreprise déjà utilisé" });
    }

    const existingUser = await User.findOne({ where: { email: admin.email }, transaction: t });
    if (existingUser) {
      await t.rollback();
      return res.status(400).json({ message: "Email admin déjà utilisé" });
    }

    const newCompany = await sequelize.models.Company.create(
      {
        name: company.name,
        email: company.email,
        description: company.description || null,
        location: company.location || null,
        businessId: company.businessId || null,
        logo: company.logo || null,
      },
      { transaction: t }
    );

    const hashedPassword = await bcrypt.hash(admin.password, 10);
    const newUser = await User.create(
      {
        username: admin.username,
        email: admin.email,
        password: hashedPassword,
        isActive: true,
        accountNumber: String(generateAccountNumber()),
      },
      { transaction: t }
    );

    const [companyRole] = await Role.findOrCreate({
      where: { name: 'COMPANY_ADMIN' },
      defaults: { name: 'COMPANY_ADMIN', description: 'Administrateur entreprise' },
      transaction: t,
    });

    await sequelize.models.UserRole.create(
      { userId: newUser.id, roleId: companyRole.id, companyId: newCompany.companyId },
      { transaction: t }
    );

    await t.commit();

    return res.status(201).json({
      message: 'Compte entreprise créé avec succès',
      company: { id: newCompany.companyId, name: newCompany.name, email: newCompany.email },
      admin: { id: newUser.id, username: newUser.username, email: newUser.email, role: 'COMPANY_ADMIN' },
    });
  } catch (error) {
    await t.rollback();
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Ajout d'un admin à une entreprise existante ──────────────────────────────
export const addCompanyAdmin = async (req, res) => {
  const { companyId, username, email, password } = req.body;

  if (!companyId || !username || !email || !password) {
    return res.status(400).json({ message: 'companyId, username, email et password sont requis' });
  }

  const t = await sequelize.transaction();
  try {
    const company = await sequelize.models.Company.findByPk(companyId, { transaction: t });
    if (!company) {
      await t.rollback();
      return res.status(404).json({ message: 'Entreprise introuvable' });
    }

    const existingUser = await User.findOne({ where: { email }, transaction: t });
    if (existingUser) {
      await t.rollback();
      return res.status(400).json({ message: 'Cet email est déjà utilisé' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = await User.create(
      {
        username,
        email,
        password: hashedPassword,
        isActive: true,
        accountNumber: String(generateAccountNumber()),
      },
      { transaction: t }
    );

    const [companyRole] = await Role.findOrCreate({
      where: { name: 'COMPANY_ADMIN' },
      defaults: { name: 'COMPANY_ADMIN', description: 'Administrateur entreprise' },
      transaction: t,
    });

    await sequelize.models.UserRole.create(
      { userId: newUser.id, roleId: companyRole.id, companyId: parseInt(companyId, 10) },
      { transaction: t }
    );

    await t.commit();

    return res.status(201).json({
      message: 'Administrateur ajouté avec succès',
      admin: { id: newUser.id, username: newUser.username, email: newUser.email, role: 'COMPANY_ADMIN' },
      company: { id: company.companyId, name: company.name },
    });
  } catch (error) {
    await t.rollback();
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Création d'un commerce + gestionnaire optionnel ─────────────────────────
export const createCommerceAccount = async (req, res) => {
  const { commerceName, commerceEmail, username, email, password } = req.body;

  if (!commerceName || !commerceEmail) {
    return res.status(400).json({ message: 'Nom et email du commerce sont requis' });
  }

  const hasManager = !!(username && email && password);
  const t = await sequelize.transaction();

  try {
    let newUser = null;

    if (hasManager) {
      const existingUser = await User.findOne({ where: { email }, transaction: t });
      if (existingUser) {
        await t.rollback();
        return res.status(400).json({ message: 'Email gestionnaire déjà utilisé' });
      }
      const hashedPassword = await bcrypt.hash(password, 10);
      newUser = await User.create(
        { username, email, password: hashedPassword, isActive: true, accountNumber: String(generateAccountNumber()) },
        { transaction: t }
      );
    }

    const commerceData = { commercename: commerceName, commerceemail: commerceEmail };
    if (newUser) {
      commerceData.id = newUser.id;
      commerceData.userId = newUser.id;
    }

    const newCommerce = await Commerce.create(commerceData, { transaction: t });

    if (newUser) {
      await newUser.update({ commerceId: newCommerce.commerceId }, { transaction: t });
    }

    await t.commit();
    return res.status(201).json({
      message: hasManager ? 'Commerce et gestionnaire créés avec succès' : 'Commerce créé avec succès',
      commerce: { id: newCommerce.commerceId, name: newCommerce.commercename, email: newCommerce.commerceemail },
      ...(newUser && { user: { id: newUser.id, username: newUser.username, email: newUser.email } }),
    });
  } catch (error) {
    await t.rollback();
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Liste des comptes admin (BIM + COMPANY_ADMIN) ───────────────────────────
export const getAdminAccounts = async (req, res) => {
  try {
    const { search, page = 1, pageSize = 20, paginate = 'false' } = req.query;
    const isPaginate = paginate === 'true';
    const limit = parseInt(pageSize, 10);
    const currentPage = parseInt(page, 10);
    const offset = (currentPage - 1) * limit;

    const userWhere = {};
    if (search) {
      userWhere[Op.or] = [
        { username: { [Op.like]: `%${search}%` } },
        { email: { [Op.like]: `%${search}%` } },
        { fullname: { [Op.like]: `%${search}%` } },
      ];
    }

    const queryOptions = {
      where: userWhere,
      attributes: {
        exclude: ['password', 'otp', 'otpExpires', 'resetPasswordToken', 'resetPasswordExpiresAt', 'refreshToken', 'token', 'TokenAbonemment', 'randomly'],
      },
      include: [
        {
          model: Role,
          as: 'role',
          where: { name: { [Op.in]: ['BIM', 'COMPANY_ADMIN'] } },
          required: true,
        },
      ],
      order: [['createdAt', 'DESC']],
      distinct: true,
    };

    if (isPaginate) {
      const { rows, count } = await User.findAndCountAll({ ...queryOptions, limit, offset });
      return res.status(200).json({
        data: rows,
        pagination: { total: count, page: currentPage, pageSize: limit, totalPages: Math.ceil(count / limit) },
      });
    }

    const users = await User.findAll(queryOptions);
    return res.status(200).json({ data: users, total: users.length });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Portail entreprise : gestion des admins de la company ───────────────────

export const getMyCompanyAdmins = async (req, res) => {
  try {
    const userId = req.user?.id;
    const myRole = await sequelize.models.UserRole.findOne({ where: { userId } });
    const companyId = myRole?.companyId;
    if (!companyId) return res.status(403).json({ message: 'Aucune entreprise associée à ce compte' });

    const companyRole = await Role.findOne({ where: { name: 'COMPANY_ADMIN' } });
    if (!companyRole) return res.status(200).json({ data: [] });

    const userRoles = await sequelize.models.UserRole.findAll({
      where: { companyId, roleId: companyRole.id },
    });
    const userIds = userRoles.map((ur) => ur.userId);

    const users = await User.findAll({
      where: { id: userIds },
      attributes: { exclude: ['password', 'otp', 'otpExpires', 'resetPasswordToken', 'resetPasswordExpiresAt', 'refreshToken', 'token', 'TokenAbonemment', 'randomly'] },
      order: [['createdAt', 'ASC']],
    });
    return res.status(200).json({ data: users });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

export const updateMyCompanyAdmin = async (req, res) => {
  try {
    const requesterId = req.user?.id;
    const targetId = parseInt(req.params.id, 10);
    const myRole = await sequelize.models.UserRole.findOne({ where: { userId: requesterId } });
    const companyId = myRole?.companyId;
    if (!companyId) return res.status(403).json({ message: 'Aucune entreprise associée à ce compte' });

    const targetRole = await sequelize.models.UserRole.findOne({ where: { userId: targetId, companyId } });
    if (!targetRole) return res.status(404).json({ message: 'Utilisateur introuvable dans votre entreprise' });

    const user = await User.findByPk(targetId);
    if (!user) return res.status(404).json({ message: 'Utilisateur introuvable' });

    const { username, email, password } = req.body;
    const updateData = {};
    if (username) updateData.username = username;
    if (email) updateData.email = email;
    if (password) updateData.password = await bcrypt.hash(password, 10);

    await user.update(updateData);
    return res.status(200).json({ message: 'Compte mis à jour avec succès' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

export const deleteMyCompanyAdmin = async (req, res) => {
  try {
    const requesterId = req.user?.id;
    const targetId = parseInt(req.params.id, 10);

    if (requesterId === targetId) {
      return res.status(400).json({ message: 'Vous ne pouvez pas supprimer votre propre compte' });
    }

    const myRole = await sequelize.models.UserRole.findOne({ where: { userId: requesterId } });
    const companyId = myRole?.companyId;
    if (!companyId) return res.status(403).json({ message: 'Aucune entreprise associée à ce compte' });

    const targetRole = await sequelize.models.UserRole.findOne({ where: { userId: targetId, companyId } });
    if (!targetRole) return res.status(404).json({ message: 'Utilisateur introuvable dans votre entreprise' });

    await sequelize.models.UserRole.destroy({ where: { userId: targetId } });
    await User.destroy({ where: { id: targetId } });

    return res.status(200).json({ message: 'Compte supprimé avec succès' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Liste des OTPs des utilisateurs ─────────────────────────────────────────
export const getOtps = async (req, res) => {
  try {
    const { page = 1, pageSize = 20, status, period } = req.query;
    const limit = parseInt(pageSize, 10);
    const offset = (parseInt(page, 10) - 1) * limit;

    const where = {
      email: { [Op.ne]: 'bimbank@bimreseau.com' },
      otp: { [Op.ne]: null },
    };

    const now = new Date();

    if (status === 'active') {
      where.otpExpires = { [Op.gt]: now };
    } else if (status === 'expired') {
      where.otpExpires = { [Op.lte]: now };
    }

    if (period) {
      const periodStart = getDateRangeByPeriod(period);
      if (periodStart) {
        where.createdAt = { [Op.gte]: periodStart };
      }
    }

    const { rows, count } = await User.findAndCountAll({
      where,
      attributes: ['id', 'username', 'fullname', 'email', 'otp', 'otpExpires', 'createdAt'],
      order: [['createdAt', 'DESC']],
      limit,
      offset,
    });

    const data = rows.map((u) => ({
      id: u.id,
      user: { id: u.id, username: u.username, email: u.email },
      otp: u.otp,
      code: u.otp,
      expiresAt: u.otpExpires,
      createdAt: u.createdAt,
      status: u.otpExpires && u.otpExpires > now ? 'active' : 'expired',
      type: 'activation',
    }));

    return res.status(200).json({
      data,
      pagination: { total: count, page: parseInt(page, 10), pageSize: limit, totalPages: Math.ceil(count / limit) },
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Statistiques de solde des utilisateurs ───────────────────────────────────
export const getUsersBalanceStats = async (req, res) => {
  try {
    const { period, createdAtFrom, createdAtTo } = req.query;

    // Base : exclure le compte système
    const baseWhere = { email: { [Op.ne]: 'bimbank@bimreseau.com' } };

    // Filtre temporel uniquement pour les compteurs d'utilisateurs (inscrits sur la période)
    const periodWhere = { ...baseWhere };
    if (period) {
      const periodStart = getDateRangeByPeriod(period);
      if (periodStart) periodWhere.createdAt = { [Op.gte]: periodStart };
    } else if (createdAtFrom || createdAtTo) {
      const dateWhere = {};
      if (createdAtFrom) dateWhere[Op.gte] = new Date(createdAtFrom);
      if (createdAtTo) {
        const end = new Date(createdAtTo);
        end.setHours(23, 59, 59, 999);
        dateWhere[Op.lte] = end;
      }
      periodWhere.createdAt = dateWhere;
    }

    const [totalBalance, totalUsers, activeUsers, newUsers] = await Promise.all([
      // Solde total = TOUJOURS la somme de tous les utilisateurs (pas de filtre date)
      User.sum('soldNumber', { where: baseWhere }),
      User.count({ where: baseWhere }),
      User.count({ where: { ...baseWhere, isActive: true } }),
      // Nouveaux inscrits sur la période sélectionnée
      User.count({ where: periodWhere }),
    ]);

    return res.status(200).json({
      totalBalance: totalBalance ?? 0,
      totalUsers,
      activeUsers,
      newUsers,
      period: period || 'all',
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Mot de passe de transaction d'un utilisateur ────────────────────────────
export const getTransactionPassword = async (req, res) => {
  try {
    const { id } = req.params;
    const user = await User.findByPk(id, {
      attributes: ['id', 'username', 'email', 'randomly', 'randomlyPlain'],
    });
    if (!user) return res.status(404).json({ message: 'Utilisateur introuvable' });

    return res.status(200).json({
      userId: user.id,
      username: user.username,
      randomly: user.randomlyPlain ?? null,
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Recharge admin d'un compte utilisateur ──────────────────────────────────
export const adminRechargeUser = async (req, res) => {
  try {
    const { id } = req.params;
    const { amount } = req.body;

    if (!amount || isNaN(amount) || Number(amount) <= 0) {
      return res.status(400).json({ message: 'Montant invalide' });
    }

    const user = await User.findByPk(id);
    if (!user) return res.status(404).json({ message: 'Utilisateur introuvable' });

    const current = parseFloat(user.soldNumber ?? 0);
    const newBalance = current + parseFloat(amount);

    await user.update({ soldNumber: newBalance });

    return res.status(200).json({
      message: `${amount} EC ajoutés au compte de ${user.username}`,
      previousBalance: current,
      newBalance,
      userId: user.id,
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── Réinitialisation du mot de passe d'un utilisateur par l'admin ───────────
export const adminResetUserPassword = async (req, res) => {
  try {
    const { id } = req.params;
    const user = await User.findByPk(id);
    if (!user) return res.status(404).json({ message: 'Utilisateur introuvable' });

    const newPassword = generatePassword6Digits();
    const hashed = await bcrypt.hash(newPassword, 10);
    await user.update({ password: hashed });

    return res.status(200).json({
      message: `Mot de passe réinitialisé pour ${user.username}`,
      newPassword,
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─── SOS Utilisateur ─────────────────────────────────────────────────────────

export const sendUserSOS = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { category = 'securite', type, subType, caseLocation, contactPhone, latitude, longitude } = req.body;

    const VALID_TYPES_SECURITE = ['suspect', 'urgence', 'secours'];
    const VALID_SUBTYPES_SANTE = ['ebola', 'cas_suspect', 'autre'];

    if (category === 'sante') {
      if (!VALID_SUBTYPES_SANTE.includes(subType)) {
        return res.status(400).json({ message: 'Sous-type SOS santé invalide (ebola | cas_suspect | autre)' });
      }
    } else {
      if (!VALID_TYPES_SECURITE.includes(type)) {
        return res.status(400).json({ message: 'Type SOS invalide (suspect | urgence | secours)' });
      }
    }

    const user = await User.findByPk(userId, {
      attributes: ['id', 'username', 'email', 'telephone'],
    });
    if (!user) return res.status(404).json({ message: 'Utilisateur introuvable' });

    const sos = await UserSOS.create({
      userId,
      category,
      type: category === 'sante' ? 'sante' : type,
      subType:       category === 'sante' ? subType       : null,
      caseLocation:  category === 'sante' ? (caseLocation ?? null) : null,
      contactPhone:  contactPhone ?? user.telephone ?? null,
      latitude:  latitude  ?? null,
      longitude: longitude ?? null,
      status: 'active',
    });

    const TYPE_LABEL = {
      suspect: '🟠 Suspect',
      urgence: '🔴 Urgence',
      secours: '🆘 AU SECOURS',
      sante:   '🏥 SOS Santé',
    };
    const SUBTYPE_LABEL = {
      ebola:      '🦠 Ebola',
      cas_suspect: '⚠️ Cas suspect de maladie',
      autre:      '🏥 Autre urgence médicale',
    };

    const mapsLink = latitude && longitude
      ? `https://maps.google.com/?q=${latitude},${longitude}`
      : 'Position inconnue';

    const payload = {
      sosId:        sos.sosId,
      category,
      type:         category === 'sante' ? 'sante' : type,
      typeLabel:    category === 'sante' ? TYPE_LABEL['sante'] : TYPE_LABEL[type],
      subType:      subType ?? null,
      subTypeLabel: subType ? SUBTYPE_LABEL[subType] : null,
      caseLocation: caseLocation ?? null,
      contactPhone: sos.contactPhone,
      source:       'user',
      userId,
      userName:     user.username,
      telephone:    user.telephone ?? null,
      latitude,
      longitude,
      mapsLink,
      createdAt:    sos.createdAt,
    };

    emitSOSAlert(payload);

    const emailSubject = category === 'sante'
      ? `${SUBTYPE_LABEL[subType] ?? 'SOS Santé'} — Alerte sanitaire BIM NEXT`
      : `${TYPE_LABEL[type]} — Alerte SOS utilisateur BIM NEXT`;

    try {
      await sendEmail({
        to: process.env.SUPPORT_EMAIL || 'support@bimreseau.com',
        subject: emailSubject,
        html: `
          <h2 style="color:#DC2626">🚨 ${category === 'sante' ? 'Alerte Sanitaire' : 'Alerte SOS Sécurité'}</h2>
          ${category === 'sante' ? `<p><b>Type :</b> ${SUBTYPE_LABEL[subType] ?? subType}</p>` : `<p><b>Type :</b> ${TYPE_LABEL[type]}</p>`}
          <p><b>Utilisateur :</b> ${user.username} (${user.email})</p>
          <p><b>Téléphone :</b> ${sos.contactPhone ?? 'Non renseigné'}</p>
          ${caseLocation ? `<p><b>Localisation du cas :</b> ${caseLocation}</p>` : ''}
          <p><b>Position GPS :</b> <a href="${mapsLink}">${mapsLink}</a></p>
          <p><b>Heure :</b> ${new Date().toLocaleString('fr-FR')}</p>
          <hr/>
          <p style="color:#666">Connectez-vous au panneau admin BIM NEXT pour gérer cette alerte.</p>
        `,
      });
    } catch { /* email non bloquant */ }

    return res.status(201).json({ message: 'Alerte SOS envoyée', sos: payload });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

export const resolveUserSOS = async (req, res) => {
  try {
    const { sosId } = req.params;
    const sos = await UserSOS.findByPk(sosId);
    if (!sos) return res.status(404).json({ message: 'Alerte introuvable' });
    await sos.update({ status: 'resolved', resolvedAt: new Date() });
    return res.json({ message: 'Alerte résolue', sosId });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

export const getUserSOSAlerts = async (req, res) => {
  try {
    const { status = 'active' } = req.query;
    const alerts = await UserSOS.findAll({
      where: status !== 'all' ? { status } : {},
      include: [{
        model: User, as: 'user',
        attributes: ['id', 'username', 'email', 'telephone'],
      }],
      order: [['createdAt', 'DESC']],
    });
    return res.json({ data: alerts, total: alerts.length });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// ─────────────────────────────────────────────────────────────────────────────
// POST /auth/admin/reset-all-balances
// Remet le soldNumber de TOUS les utilisateurs BIM NEXT à 0.
// Action irréversible — réservée aux super-admins BIM.
// ─────────────────────────────────────────────────────────────────────────────
export const resetAllBalances = async (req, res) => {
  try {
    // Double confirmation via corps de la requête
    const { confirmation } = req.body;
    if (confirmation !== 'RESET_ALL_BALANCES') {
      return res.status(400).json({
        message: 'Confirmation requise. Envoyez { confirmation: "RESET_ALL_BALANCES" }.',
      });
    }

    const [affectedRows] = await User.update(
      { soldNumber: 0 },
      { where: {} }   // tous les utilisateurs
    );

    // Log l'action dans l'historique si possible
    try {
      const adminId = req.user?.id;
      const { History } = await import('../models/index.js');
      await History.create({
        userId:   adminId,
        action:   'Réinitialisation',
        resource: 'soldNumber (all users)',
        details:  `Reset de ${affectedRows} soldes à 0 effectué par l'admin #${adminId}`,
        status:   'success',
      });
    } catch { /* ne pas bloquer si historique échoue */ }

    return res.json({
      message: `✅ Réinitialisation effectuée. ${affectedRows} solde(s) remis à 0.`,
      affectedRows,
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

export {
  register,
  login,
  askPasswordReset,
  resetPassword,
  getAllUsers,
  getUserById,
  updateUserProfile,
  updateUserPassword,
  desactivateUser,
  deleteUser,
  deleteAccount,
  refreshToken,
  getMe,
  createUsers,
  verifyOtp,
  logOut,
  storeExpoPushToken,
  createAgent,
  veryfUserPass,
};
/* eslint-disable no-undef */
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { User, Role ,BranchTrack, Commerce} from '../models/index.js';
import sequelize from '../config/database.js';
import { Op } from 'sequelize';
import crypto from 'crypto';
import nodemailer from 'nodemailer';
import path from 'path';
import fs from 'fs';
import { generateNewLoginAlertEmailTemplate,generateTransactionPasswordEmailTemplate, generateOtpEmailTemplate, generateOtpEmailTemplateActivated } from '../utils/templateMails.util.js';
import { generateAccountNumber,generateAccountNumberAgent} from '../utils/generateAccountNumber.util.js';
import { generatePassword6Digits,getFormattedDateTime} from '../utils/calculFrais.util.js';
const generateOtp = () => {
  return Math.floor(100000 + Math.random() * 900000).toString(); // OTP 6 chiffres
};


const register = async (req, res) => {
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
      isActive: false,
      accountNumber: String(generateAccountNumber())
    });

   
    const transporter = nodemailer.createTransport({
      host: 'mail.bimreseau.com',
      port: 465,
      secure: true,
      auth: {
        user: 'noreply@bimreseau.com',
        pass: process.env.EMAIL_PASSWORD,
      },
    });

    
    await transporter.sendMail({
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

   
    const transporter = nodemailer.createTransport({
      host: 'mail.bimreseau.com',
      port: 465,
      secure: true,
      auth: {
        user: 'noreply@bimreseau.com',
        pass: process.env.EMAIL_PASSWORD,
      },
    });

    
    await transporter.sendMail({
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

    // Email alerte connexion (fire & forget)
    try {
      const transporter = nodemailer.createTransport({
        host: 'mail.bimreseau.com',
        port: 465,
        secure: true,
        auth: { user: 'noreply@bimreseau.com', pass: process.env.EMAIL_PASSWORD },
      });
      await transporter.sendMail({
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
      role: user.role,
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

         
    const transporter = nodemailer.createTransport({
      host: 'mail.bimreseau.com',
      port: 465,
      secure: true,
      auth: {
        user: 'noreply@bimreseau.com',
        pass: process.env.EMAIL_PASSWORD,
      },
    });

    
    await transporter.sendMail({
      from: 'noreply@bimreseau.com',
      to: email,
      subject: 'Activation de votre compte Bim',
      html: generateOtpEmailTemplate(user.username,otp),
    });
      return res.status(200).json({
        message: 'Un code otp a été envoyé à votre adresse e-mail.',
        userId : user.id
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

    const users = await User.findAll(queryOptions);

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
    
       const transporter = nodemailer.createTransport({
      host: 'mail.bimreseau.com',
      port: 465,
      secure: true,
      auth: {
        user: 'noreply@bimreseau.com',
        pass: process.env.EMAIL_PASSWORD,
      },
    });

    
    await transporter.sendMail({
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
    const createdUsers = [];

    for (const userData of users) {
      const { username, email, password } = userData;

      const existingUser = await User.findOne({ where: { email } });
      if (existingUser) {
        continue; 
      }

      // Hash du mot de passe
      const hashedPassword = await bcrypt.hash(password, 10);

      // Création de l'utilisateur
      const newUser = await User.create({
        username,
        email,
        password: hashedPassword,
      });

      createdUsers.push({
        id: newUser.id,
        username: newUser.username,
        email: newUser.email,
      });
    }

    res.status(201).json({
      message: "Utilisateurs créés avec succès",
      users: createdUsers,
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
     const transporter = nodemailer.createTransport({
      host: 'mail.bimreseau.com',
      port: 465,
      secure: true,
      auth: {
        user: 'noreply@bimreseau.com',
        pass: process.env.EMAIL_PASSWORD,
      },
     });
    
const dateTime = getFormattedDateTime();

    
    await transporter.sendMail({
      from: 'noreply@bimreseau.com',
      to: user.email,
      subject: `Votre mot de passe de transaction BIM NEXT 🔐 — Créé le ${dateTime}`,
      html: generateTransactionPasswordEmailTemplate(user.username,pwd),
    });

 


   
    await user.update({
      isActive: true,
      otp: null,
      otpExpires: null,
      randomly : hashedPassword,
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
      const transporter = nodemailer.createTransport({
        host:    'mail.bimreseau.com',
        port:    465,
        secure:  true,
        auth:    { user: 'noreply@bimreseau.com', pass: process.env.EMAIL_PASSWORD },
        pool:    true,
        maxConnections: 3,
      });

      await transporter.sendMail({
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
  veryfUserPass
};
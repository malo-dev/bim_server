/* eslint-disable no-undef */
export const generateOtpEmailTemplate = (username, otp) => {
  return `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Activation de votre compte</title>
</head>

<body style="margin:0; padding:0; font-family: Arial, Helvetica, sans-serif; background-color:#f4f6f8;">

<table width="100%" cellpadding="0" cellspacing="0" style="padding:20px;">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
style="background:#ffffff;border-radius:10px;overflow:hidden;box-shadow:0 6px 18px rgba(0,0,0,0.08);">

<!-- HEADER -->
<tr>
<td style="background:#0d6efd;padding:30px;text-align:center;">

<img src="https://bimreseau.com/wp-content/uploads/2024/11/Rectangle-1319.png"
alt="BIM NEXT"
style="max-width:140px;margin-bottom:10px;" />

<h1 style="margin:0;color:#ffffff;font-size:24px;letter-spacing:1px;">
BIM NEXT
</h1>

</td>
</tr>

<!-- BODY -->
<tr>
<td style="padding:35px;color:#333;">

<h2 style="margin-top:0;font-size:20px;">
Bonjour ${username},
</h2>

<p style="font-size:16px;line-height:1.7;">
Merci d’avoir créé un compte sur <strong>BIM NEXT</strong>.  
Pour activer votre compte, veuillez utiliser le code OTP ci-dessous :
</p>

<!-- OTP BOX -->
<div style="
background:#f0f6ff;
border:2px dashed #0d6efd;
padding:20px;
margin:30px 0;
text-align:center;
border-radius:8px;">

<p style="
font-size:28px;
font-weight:bold;
letter-spacing:6px;
color:#0d6efd;
margin:0;">
${otp}
</p>

</div>

<p style="font-size:14px;color:#555;">
⏳ Ce code est valide pendant <strong>30 minutes</strong>.
</p>

<p style="font-size:14px;color:#777;margin-top:25px;">
Si vous n’êtes pas à l’origine de cette demande, veuillez ignorer cet email.
</p>

</td>
</tr>

<!-- FOOTER -->
<tr>
<td style="background:#f1f1f1;padding:18px;text-align:center;font-size:12px;color:#777;">

© ${new Date().getFullYear()} BIM NEXT — Tous droits réservés  
<br><br>
<strong>Ne pas répondre à cet email.</strong>  
Ceci est un message automatique.

</td>
</tr>

</table>

</td>
</tr>
</table>

</body>
</html>
`;
};



export const generateOtpEmailTemplateActivated = (username) => {
  return `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Compte activé</title>
</head>

<body style="margin:0;padding:0;background:#f4f6f8;font-family:Arial,Helvetica,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0" style="padding:20px;">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
style="background:#ffffff;border-radius:10px;overflow:hidden;box-shadow:0 6px 18px rgba(0,0,0,0.08);">

<!-- HEADER -->
<tr>
<td style="background:#0d6efd;padding:30px;text-align:center;">

<img src="https://bimreseau.com/wp-content/uploads/2024/11/Rectangle-1319.png"
alt="BIM NEXT"
style="max-width:140px;margin-bottom:10px;" />

<h1 style="margin:0;color:#ffffff;font-size:24px;letter-spacing:1px;">
BIM NEXT
</h1>

</td>
</tr>

<!-- BODY -->
<tr>
<td style="padding:35px;color:#333;">

<h2 style="margin-top:0;font-size:20px;">
Votre compte est activé 🎉
</h2>

<p style="font-size:16px;line-height:1.7;">
Bonjour ${username},
</p>

<p style="font-size:16px;line-height:1.7;">
Nous sommes heureux de vous informer que votre compte <strong>BIM NEXT</strong> a été activé avec succès.
</p>

<p style="font-size:16px;line-height:1.7;">
Vous pouvez désormais accéder à la plateforme et profiter de toutes ses fonctionnalités.
</p>

<div style="
background:#f0f6ff;
border-left:4px solid #0d6efd;
padding:15px;
margin:25px 0;
border-radius:6px;
">

<p style="margin:0;font-size:15px;">
Bienvenue dans la communauté <strong>BIM NEXT</strong> !
</p>

</div>

<p style="font-size:14px;color:#666;">
Cordialement,<br>
<strong>L’équipe BIM NEXT</strong>
</p>

</td>
</tr>

<!-- FOOTER -->
<tr>
<td style="background:#f1f1f1;padding:18px;text-align:center;font-size:12px;color:#777;">

© ${new Date().getFullYear()} BIM NEXT — Tous droits réservés  
<br><br>
<strong>Ne pas répondre à cet email.</strong>  
Ceci est un message automatique.

</td>
</tr>

</table>

</td>
</tr>
</table>

</body>
</html>
`;
};

export const generateTransactionPasswordEmailTemplate = (username, password) => {
  return `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mot de passe de transaction</title>
</head>

<body style="margin:0; padding:0; font-family: Arial, Helvetica, sans-serif; background-color:#f4f6f8;">

<table width="100%" cellpadding="0" cellspacing="0" style="padding:20px;">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
style="background:#ffffff;border-radius:10px;overflow:hidden;box-shadow:0 6px 18px rgba(0,0,0,0.08);">

<!-- HEADER -->
<tr>
<td style="background:#0d6efd;padding:30px;text-align:center;">

<img src="https://bimreseau.com/wp-content/uploads/2024/11/Rectangle-1319.png"
alt="BIM NEXT"
style="max-width:140px;margin-bottom:10px;" />

<h1 style="margin:0;color:#ffffff;font-size:24px;letter-spacing:1px;">
BIM NEXT
</h1>

</td>
</tr>

<!-- BODY -->
<tr>
<td style="padding:35px;color:#333;">

<h2 style="margin-top:0;font-size:20px;">
Bonjour ${username},
</h2>

<p style="font-size:16px;line-height:1.7;">
Votre <strong>mot de passe de transaction</strong> a été généré avec succès.
</p>

<p style="font-size:16px;line-height:1.7;">
Vous devrez utiliser ce code chaque fois que vous souhaitez effectuer une opération
(transfert, retrait, paiement, etc.).
</p>

<!-- PASSWORD BOX -->
<div style="
background:#f0f6ff;
border:2px dashed #0d6efd;
padding:20px;
margin:30px 0;
text-align:center;
border-radius:8px;">

<p style="
font-size:30px;
font-weight:bold;
letter-spacing:8px;
color:#0d6efd;
margin:0;">
${password}
</p>

</div>

<p style="font-size:14px;color:#555;">
🔐 Gardez ce code confidentiel et ne le partagez avec personne.
</p>

<p style="font-size:14px;color:#777;margin-top:25px;">
Si vous n’êtes pas à l’origine de cette demande, veuillez contacter immédiatement notre support.
</p>

</td>
</tr>

<!-- FOOTER -->
<tr>
<td style="background:#f1f1f1;padding:18px;text-align:center;font-size:12px;color:#777;">

© ${new Date().getFullYear()} BIM NEXT — Tous droits réservés  
<br><br>
<strong>Ne pas répondre à cet email.</strong>  
Ceci est un message automatique.

</td>
</tr>

</table>

</td>
</tr>
</table>

</body>
</html>
`;
};



export const generateNewLoginAlertEmailTemplate = (
  username,
  device,
  location,
  appVersion,
  date
) => {
  return `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Nouvelle connexion détectée</title>
</head>

<body style="margin:0;padding:0;background:#f4f6f8;font-family:Arial,Helvetica,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0" style="padding:20px;">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
style="background:#ffffff;border-radius:10px;overflow:hidden;box-shadow:0 6px 18px rgba(0,0,0,0.08);">

<!-- HEADER -->
<tr>
<td style="background:#dc3545;padding:30px;text-align:center;">

<img src="https://bimreseau.com/wp-content/uploads/2024/11/Rectangle-1319.png"
alt="BIM NEXT"
style="max-width:140px;margin-bottom:10px;" />

<h1 style="margin:0;color:#ffffff;font-size:24px;letter-spacing:1px;">
BIM NEXT
</h1>

</td>
</tr>

<!-- BODY -->
<tr>
<td style="padding:35px;color:#333;">

<h2 style="margin-top:0;font-size:20px;">
Nouvelle connexion détectée ⚠️
</h2>

<p style="font-size:16px;line-height:1.7;">
Bonjour ${username},
</p>

<p style="font-size:16px;line-height:1.7;">
Nous souhaitions vous informer qu’une <strong>nouvelle connexion</strong> a été détectée sur votre compte BIM NEXT.
</p>

<!-- INFO BOX -->
<div style="
background:#fff3f3;
border-left:4px solid #dc3545;
padding:15px;
margin:25px 0;
border-radius:6px;
">

<p style="margin:6px 0;font-size:15px;">
<strong>Appareil :</strong> ${device || "Inconnu"}
</p>

<p style="margin:6px 0;font-size:15px;">
<strong>Localisation :</strong> ${location || "Inconnue"}
</p>

<p style="margin:6px 0;font-size:15px;">
<strong>Version de l’application :</strong> ${appVersion || "Inconnue"}
</p>

<p style="margin:6px 0;font-size:15px;">
<strong>Date & heure :</strong> ${date || new Date().toLocaleString()}
</p>

</div>

<p style="font-size:16px;line-height:1.7;">
Si vous êtes à l’origine de cette connexion, aucune action n’est requise.
</p>

<p style="font-size:16px;line-height:1.7;">
Dans le cas contraire, nous vous recommandons de :
</p>

<ul style="font-size:15px;line-height:1.7;color:#333;">
  <li>Changer immédiatement votre mot de passe</li>
  <li>Contacter le support BIM NEXT</li>
</ul>

<p style="font-size:14px;color:#666;">
Cordialement,<br>
<strong>L’équipe BIM NEXT</strong>
</p>

</td>
</tr>

<!-- FOOTER -->
<tr>
<td style="background:#f1f1f1;padding:18px;text-align:center;font-size:12px;color:#777;">

© ${new Date().getFullYear()} BIM NEXT — Tous droits réservés  
<br><br>
<strong>Ne pas répondre à cet email.</strong>  
Ceci est un message automatique.

</td>
</tr>

</table>

</td>
</tr>
</table>

</body>
</html>
`;
};









export const generateRechargeSuccessEmailTemplate = (
  username,
  amount,
  transactionId,
  date
) => {
  return `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Recharge effectuée avec succès</title>
</head>

<body style="margin:0;padding:0;background:#f4f6f8;font-family:Arial,Helvetica,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0" style="padding:20px;">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
style="background:#ffffff;border-radius:10px;overflow:hidden;box-shadow:0 6px 18px rgba(0,0,0,0.08);">

<!-- HEADER -->
<tr>
<td style="background:#198754;padding:30px;text-align:center;">

<img src="https://bimreseau.com/wp-content/uploads/2024/11/Rectangle-1319.png"
alt="BIM NEXT"
style="max-width:140px;margin-bottom:10px;" />

<h1 style="margin:0;color:#ffffff;font-size:24px;">
BIM NEXT
</h1>

</td>
</tr>

<!-- BODY -->
<tr>
<td style="padding:35px;color:#333;">

<h2 style="margin-top:0;font-size:20px;">
Recharge confirmée ✅
</h2>

<p style="font-size:16px;line-height:1.7;">
Bonjour ${username},
</p>

<p style="font-size:16px;line-height:1.7;">
Nous vous informons que votre <strong>recharge a été effectuée avec succès</strong>.
</p>

<!-- INFO BOX -->
<div style="
background:#f0fff4;
border-left:4px solid #198754;
padding:15px;
margin:25px 0;
border-radius:6px;
">

<p style="margin:6px 0;font-size:15px;">
<strong>Montant :</strong> ${amount} $
</p>

<p style="margin:6px 0;font-size:15px;">
<strong>ID Transaction :</strong> ${transactionId}
</p>

<p style="margin:6px 0;font-size:15px;">
<strong>Date & heure :</strong> ${date || new Date().toLocaleString()}
</p>

</div>

<p style="font-size:16px;line-height:1.7;">
Le montant a été ajouté à votre compte BIM NEXT.
</p>

<p style="font-size:14px;color:#666;">
Merci pour votre confiance,<br/>
<strong>L’équipe BIM NEXT</strong>
</p>

</td>
</tr>

<!-- FOOTER -->
<tr>
<td style="background:#f1f1f1;padding:18px;text-align:center;font-size:12px;color:#777;">

© ${new Date().getFullYear()} BIM NEXT — Tous droits réservés  
<br/><br/>
<strong>Ne pas répondre à cet email.</strong>  
Ceci est un message automatique.

</td>
</tr>

</table>

</td>
</tr>
</table>

</body>
</html>
`;
};



export const generateProjectReceivedEmailTemplateValue = (username, projectTitle, date) => {
  return `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Projet reçu - BIM NEXT</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      background: #f4f6f8;
      font-family: Arial, Helvetica, sans-serif;
    }
    .container {
      max-width: 600px;
      margin: 20px auto;
      background: #ffffff;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 6px 18px rgba(0,0,0,0.08);
    }
    .header {
      background: #1e90ff;
      text-align: center;
      padding: 30px;
      color: #ffffff;
    }
    .header img {
      max-width: 120px;
      margin-bottom: 10px;
    }
    .header h1 {
      margin: 0;
      font-size: 22px;
    }
    .body {
      padding: 30px;
      color: #333333;
    }
    .body p {
      font-size: 16px;
      line-height: 1.7;
      margin: 10px 0;
    }
    .info-box {
      background: #e6f2ff;
      border-left: 4px solid #1e90ff;
      padding: 15px;
      margin: 20px 0;
      border-radius: 6px;
    }
    .info-box p {
      margin: 5px 0;
      font-size: 15px;
    }
    .btn {
      display: inline-block;
      background-color: #1e90ff;
      color: #ffffff;
      padding: 12px 25px;
      margin: 20px 0;
      text-decoration: none;
      border-radius: 5px;
      font-weight: bold;
    }
    .footer {
      background: #f1f1f1;
      text-align: center;
      padding: 18px;
      font-size: 12px;
      color: #777;
    }
    @media (max-width: 600px) {
      .container { margin: 10px; }
      .body { padding: 20px; }
    }
  </style>
</head>

<body>
  <div class="container">
    <!-- HEADER -->
    <div class="header">
      <img src="https://bimreseau.com/wp-content/uploads/2024/11/Rectangle-1319.png" alt="BIM NEXT" />
      <h1>Projet reçu ✅</h1>
    </div>

    <!-- BODY -->
    <div class="body">
      <p>Bonjour <strong>${username}</strong>,</p>

      <p>Nous avons bien reçu votre projet intitulé <strong>"${projectTitle}"</strong>.</p>

      <p>L’équipe BIM NEXT va l’étudier et reviendra vers vous rapidement avec les adaptations et recommandations nécessaires pour que votre projet soit optimisé.</p>

      <div class="info-box">
        <p><strong>Date de réception :</strong> ${date || new Date().toLocaleString()}</p>
      </div>

      <p style="font-size:16px;">Merci de votre confiance !</p>

      <a href="#" class="btn">Voir votre projet</a>
    </div>

    <!-- FOOTER -->
    <div class="footer">
      © ${new Date().getFullYear()} BIM NEXT — Tous droits réservés  
      <br/><br/>
      <strong>Ne pas répondre à cet email.</strong>  
      Ceci est un message automatique.
    </div>
  </div>
</body>
</html>
`;
};





export const generateSupportReceivedEmailTemplate = (username, subject) => {
  return `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>${subject}</title>
</head>

<body style="margin:0;padding:0;background:#f4f6f8;font-family:Arial,Helvetica,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0" style="padding:20px;">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
style="background:#ffffff;border-radius:10px;overflow:hidden;box-shadow:0 6px 18px rgba(0,0,0,0.08);">

<!-- HEADER -->
<tr>
<td style="background:#0d6efd;padding:30px;text-align:center;">

<img src="https://bimreseau.com/wp-content/uploads/2024/11/Rectangle-1319.png"
alt="BIM NEXT"
style="max-width:140px;margin-bottom:10px;" />

<h1 style="margin:0;color:#ffffff;font-size:24px;">
BIM NEXT
</h1>

</td>
</tr>

<!-- BODY -->
<tr>
<td style="padding:35px;color:#333;">

<h2 style="margin-top:0;font-size:20px;">
Bonjour ${username},
</h2>

<p style="font-size:16px;line-height:1.7;">
Nous vous informons que : <strong>${subject}</strong>.
</p>

<p style="font-size:14px;color:#555;margin-top:25px;">
Cet email vous est envoyé pour vous notifier de cette transaction sur votre compte.  
Si vous n’êtes pas à l’origine de cette action, veuillez contacter notre support immédiatement.
</p>

<p style="font-size:14px;color:#666;margin-top:25px;">
Merci,<br/>
<strong>L’équipe BIM NEXT</strong>
</p>

</td>
</tr>

<!-- FOOTER -->
<tr>
<td style="background:#f1f1f1;padding:18px;text-align:center;font-size:12px;color:#777;">

© ${new Date().getFullYear()} BIM NEXT — Tous droits réservés  
<br><br/>
<strong>Ne pas répondre à cet email.</strong>  
Ceci est un message automatique.

</td>
</tr>

</table>

</td>
</tr>
</table>

</body>
</html>
`;
};





export const generateSupportReceivedEmailTemplatePaiement = ({
  username,
  subject,
  amount,
  paymentDate,
  transactionId,
  payerName,
  companyName,
  productName,
}) => {
  return `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>${subject}</title>
</head>

<body style="margin:0;padding:0;background:#f4f6f8;font-family:Arial,Helvetica,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0" style="padding:20px;">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
style="background:#ffffff;border-radius:10px;overflow:hidden;box-shadow:0 6px 18px rgba(0,0,0,0.08);">

<!-- HEADER -->
<tr>
<td style="background:#0d6efd;padding:30px;text-align:center;">
  <img src="https://bimreseau.com/wp-content/uploads/2024/11/Rectangle-1319.png"
  alt="BIM NEXT"
  style="max-width:140px;margin-bottom:10px;" />

  <h1 style="margin:0;color:#ffffff;font-size:24px;">
    BIM NEXT
  </h1>
</td>
</tr>

<!-- BODY -->
<tr>
<td style="padding:35px;color:#333;">

<h2 style="margin-top:0;font-size:20px;">
Bonjour ${username},
</h2>

<p style="font-size:16px;line-height:1.7;">
Nous vous confirmons que le paiement suivant a été effectué avec succès :
</p>

<!-- PAYMENT DETAILS -->
<table width="100%" cellpadding="10" cellspacing="0"
style="border-collapse:collapse;margin-top:20px;font-size:14px;">

<tr style="background:#f1f5f9;">
  <td><strong>Produit / Service</strong></td>
  <td>${productName}</td>
</tr>

<tr>
  <td><strong>Montant payé</strong></td>
  <td>${amount}</td>
</tr>

<tr style="background:#f1f5f9;">
  <td><strong>Date de paiement</strong></td>
  <td>${paymentDate}</td>
</tr>

<tr>
  <td><strong>Numéro de transaction</strong></td>
  <td>${transactionId}</td>
</tr>

<tr style="background:#f1f5f9;">
  <td><strong>Payé par</strong></td>
  <td>${payerName}</td>
</tr>

<tr>
  <td><strong>Entreprise</strong></td>
  <td>${companyName}</td>
</tr>

</table>

<p style="font-size:14px;color:#555;margin-top:25px;">
Si vous n’êtes pas à l’origine de cette transaction, veuillez contacter notre support immédiatement.
</p>

<p style="font-size:14px;color:#666;margin-top:25px;">
Merci,<br/>
<strong>L’équipe BIM NEXT</strong>
</p>

</td>
</tr>

<!-- FOOTER -->
<tr>
<td style="background:#f1f1f1;padding:18px;text-align:center;font-size:12px;color:#777;">
© ${new Date().getFullYear()} BIM NEXT — Tous droits réservés  
<br><br/>
<strong>Ne pas répondre à cet email.</strong>  
Ceci est un message automatique.
</td>
</tr>

</table>

</td>
</tr>
</table>

</body>
</html>
`;
};






export const generateSupportReceivedEmailTemplateRecharge = ({
  username,
  subject,
  amount,
}) => {
  return `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>${subject}</title>
</head>

<body style="margin:0;padding:0;background:#f4f6f8;font-family:Arial,Helvetica,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0" style="padding:20px;">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
style="background:#ffffff;border-radius:10px;overflow:hidden;box-shadow:0 6px 18px rgba(0,0,0,0.08);">

<!-- HEADER -->
<tr>
<td style="background:#0d6efd;padding:30px;text-align:center;">
  <h1 style="margin:0;color:#ffffff;font-size:24px;">
    BIM NEXT
  </h1>
</td>
</tr>

<!-- BODY -->
<tr>
<td style="padding:35px;color:#333;">

<h2 style="margin-top:0;font-size:20px;">
Bonjour ${username},
</h2>

<p style="font-size:16px;line-height:1.7;">
Votre recharge a été effectuée avec succès !
</p>

<!-- PAYMENT DETAILS -->
<table width="100%" cellpadding="10" cellspacing="0"
style="border-collapse:collapse;margin-top:20px;font-size:14px;">

<tr style="background:#f1f5f9;">
  <td><strong>Sujet</strong></td>
  <td>${subject}</td>
</tr>

<tr>
  <td><strong>Montant crédité</strong></td>
  <td>${amount}</td>
</tr>

</table>

<p style="font-size:14px;color:#555;margin-top:25px;">
Merci d’avoir utilisé notre service.
</p>

<p style="font-size:14px;color:#666;margin-top:25px;">
Cordialement,<br/>
<strong>L’équipe BIM NEXT</strong>
</p>

</td>
</tr>

<!-- FOOTER -->
<tr>
<td style="background:#f1f1f1;padding:18px;text-align:center;font-size:12px;color:#777;">
© ${new Date().getFullYear()} BIM NEXT — Tous droits réservés  
<br/>
<strong>Ne pas répondre à cet email.</strong>  
Ceci est un message automatique.
</td>
</tr>

</table>

</td>
</tr>
</table>

</body>
</html>
`;
};




export const generateSupportReceivedEmailTemplateTransfert = ({
  username,
  subject,
  amount,
  senderName,    // optionnel pour receiver
  receiverName,  // optionnel pour sender
}) => {
  return `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>${subject}</title>
</head>

<body style="margin:0;padding:0;background:#f4f6f8;font-family:Arial,Helvetica,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0" style="padding:20px;">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
style="background:#ffffff;border-radius:10px;overflow:hidden;box-shadow:0 6px 18px rgba(0,0,0,0.08);">

<!-- HEADER -->
<tr>
<td style="background:#0d6efd;padding:30px;text-align:center;">
  <img src="https://bimreseau.com/wp-content/uploads/2024/11/Rectangle-1319.png"
  alt="BIM NEXT"
  style="max-width:140px;margin-bottom:10px;" />
  <h1 style="margin:0;color:#ffffff;font-size:24px;">BIM NEXT</h1>
</td>
</tr>

<!-- BODY -->
<tr>
<td style="padding:35px;color:#333;">

<h2 style="margin-top:0;font-size:20px;">Bonjour ${username},</h2>

<p style="font-size:16px;line-height:1.7;">
${senderName 
  ? `Vous avez transféré <strong>${amount}$</strong> à <strong>${receiverName}</strong> avec succès.` 
  : `Vous avez reçu <strong>${amount}$</strong> de <strong>${senderName}</strong>.`} 
</p>

<table width="100%" cellpadding="10" cellspacing="0"
style="border-collapse:collapse;margin-top:20px;font-size:14px;">

<tr style="background:#f1f5f9;">
  <td><strong>Montant</strong></td>
  <td>${amount}$</td>
</tr>

${senderName ? `
<tr>
  <td><strong>Bénéficiaire</strong></td>
  <td>${receiverName}</td>
</tr>
` : `
<tr>
  <td><strong>Expéditeur</strong></td>
  <td>${senderName}</td>
</tr>
`}

<tr style="background:#f1f5f9;">
  <td><strong>Date</strong></td>
  <td>${new Date().toLocaleString("fr-FR")}</td>
</tr>

</table>

<p style="font-size:14px;color:#555;margin-top:25px;">
Si vous n’êtes pas à l’origine de cette transaction, contactez immédiatement notre support.
</p>

<p style="font-size:14px;color:#666;margin-top:25px;">
Merci,<br/>
<strong>L’équipe BIM NEXT</strong>
</p>

</td>
</tr>

<!-- FOOTER -->
<tr>
<td style="background:#f1f1f1;padding:18px;text-align:center;font-size:12px;color:#777;">
© ${new Date().getFullYear()} BIM NEXT — Tous droits réservés  
<br><br/>
<strong>Ne pas répondre à cet email.</strong>  
Ceci est un message automatique.
</td>
</tr>

</table>

</td>
</tr>
</table>

</body>
</html>
`;
};

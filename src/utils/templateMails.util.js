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






export const generateSupportReceivedEmailTemplate = (
  sujet,
  description,
  date
) => {
  return `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Ticket support reçu</title>
</head>

<body style="margin:0;padding:0;background:#f4f6f8;font-family:Arial,Helvetica,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0" style="padding:20px;">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
style="background:#ffffff;border-radius:10px;overflow:hidden;box-shadow:0 6px 18px rgba(0,0,0,0.08);">

<!-- HEADER -->
<tr>
<td style="background:#3906C7;padding:30px;text-align:center;">

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
🎫 Ticket bien reçu
</h2>

<p style="font-size:16px;line-height:1.7;">
Bonjour,
</p>

<p style="font-size:16px;line-height:1.7;">
Nous vous confirmons la <strong>bonne réception de votre message</strong>.
</p>

<p style="font-size:16px;">
<strong>Sujet :</strong> ${sujet}
</p>

<!-- INFO BOX -->
<div style="
background:#f0f2ff;
border-left:4px solid #3906C7;
padding:15px;
margin:25px 0;
border-radius:6px;
">

<p style="margin:6px 0;font-size:15px;">
<strong>Description :</strong><br/>
${description}
</p>

<p style="margin:6px 0;font-size:15px;">
<strong>Date :</strong> ${date || new Date().toLocaleString()}
</p>

</div>

<p style="font-size:16px;line-height:1.7;">
Votre problème a été <strong>lu et pris en compte</strong> par notre équipe support.
</p>

<p style="font-size:16px;line-height:1.7;">
Il est actuellement <strong>en cours d’analyse et de test</strong>.
</p>

<p style="font-size:16px;line-height:1.7;">
Si nécessaire, <strong>l’équipe support BIM NEXT vous contactera</strong> prochainement.
</p>

<p style="font-size:14px;color:#666;">
Merci pour votre patience,<br/>
<strong>L’équipe Support BIM NEXT</strong>
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



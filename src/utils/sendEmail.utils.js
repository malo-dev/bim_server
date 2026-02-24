import nodemailer from "nodemailer";

export const sendEmail = async ({ to, subject, html }) => {
  try {
     const transporter = nodemailer.createTransport({
         host: "mail.bimreseau.com",
         port: 465,
         secure: true,
         auth: {
           user: "noreply@bimreseau.com",
           pass: process.env.EMAIL_PASSWORD,
         },
       });

    const mailOptions = {
      from: `"BIM NEXT" <${process.env.SMTP_USER}>`,
      to,
      subject,
      html,
    };

    const info = await transporter.sendMail(mailOptions);

    console.log("✅ Email envoyé :", info.messageId);

    return true;
  } catch (error) {
    console.error("❌ Erreur envoi email :", error);
    return false;
  }
};
import nodemailer from "nodemailer";

export const mailer = nodemailer.createTransport({
  host: "mail.bimreseau.com",
  port: 465,
  secure: true,
  auth: {
    user: "noreply@bimreseau.com",
    // eslint-disable-next-line no-undef
    pass: process.env.EMAIL_PASSWORD,
  },
  pool: true,
  maxConnections: 5,
});

export const sendEmail = async ({ to, subject, html }) => {
  try {
    const info = await mailer.sendMail({
      from: '"BIM NEXT" <noreply@bimreseau.com>',
      to,
      subject,
      html,
    });
    console.log("✅ Email envoyé :", info.messageId);
    return true;
  } catch (error) {
    console.error("❌ Erreur envoi email :", error);
    return false;
  }
};

export const calculFrais = (amount) => {
  if (Number(amount) <= 50) {
    return 0.5;
  }
  return Number(amount) * 0.01;
};


export const generatePassword6Digits = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};


export const getFormattedDateTime = () => {
  const now = new Date();

  return now.toLocaleString("fr-FR", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
};
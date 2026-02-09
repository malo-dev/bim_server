export const generateReference = () => {
  return "TX-" + Date.now() + "-" + Math.floor(Math.random() * 100000);
};

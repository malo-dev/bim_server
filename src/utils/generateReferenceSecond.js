export const generateReferenceRecharge = () => {
  const timestamp = Date.now();
  const random = Math.floor(Math.random() * 10000);
  return `RC-${timestamp}-${random}`; // ex: RC-1675234567890-4321
};
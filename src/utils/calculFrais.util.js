export const calculFrais = (amount) => {
  if (Number(amount) <= 50) {
    return 0.5;
  }
  return Number(amount) * 0.01;
};

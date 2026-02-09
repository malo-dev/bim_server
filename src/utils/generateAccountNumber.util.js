export const generateAccountNumber = () => {
  let number = "";

  for (let i = 0; i < 16; i++) {
    number += Math.floor(Math.random() * 10); // chiffre entre 0 et 9
  }

  return number;
};


export const generateAccountNumberAgent = () => {
  let number = "";

  for (let i = 0; i < 4; i++) {
    number += Math.floor(Math.random() * 10);
  }

  return number;
};


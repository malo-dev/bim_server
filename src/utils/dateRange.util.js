// `new Date("YYYY-MM-DD")` parse toujours la chaîne comme minuit UTC — si on
// construit la borne de fin avec `setHours` (heure locale du serveur), les
// deux bornes d'un même filtre "un jour" se retrouvent dans deux fuseaux
// différents, ce qui décale le résultat. On construit les deux bornes de la
// même façon (heure locale du serveur) pour qu'elles correspondent à la même
// journée calendaire.
export function parseLocalDayStart(str) {
  const [y, m, d] = str.split('-').map(Number);
  return new Date(y, m - 1, d, 0, 0, 0, 0);
}

export function parseLocalDayEnd(str) {
  const [y, m, d] = str.split('-').map(Number);
  return new Date(y, m - 1, d, 23, 59, 59, 999);
}

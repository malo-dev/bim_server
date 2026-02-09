export const parseFiltersConvert = (keys) => {
  const types = ['INFO', 'SUCCESS', 'ERREUR', 'EXPEDITION', 'RECEPTION', 'ALERTE', 'LITIGE'];
  const periods = ['daily', 'weekly', 'monthly', 'quarterly', 'yearly'];
  // const readStatus = ['isRead', 'isNotRead'];

  return {
    type: keys.find(k => types.includes(k)) || null,
    period: keys.find(k => periods.includes(k)) || null,
    isRead: keys.includes('isRead') ? true : keys.includes('isNotRead') ? false : null
  };
}

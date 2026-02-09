export const getDateRangeByPeriod = (period) => {
  const now = new Date();
  let startDate = null;

  switch (period) {
    case 'daily':
      startDate = new Date(now.setHours(0, 0, 0, 0));
      break;

    case 'weekly':
      startDate = new Date(now.setDate(now.getDate() - 7));
      break;

    case 'monthly':
      startDate = new Date(now.getFullYear(), now.getMonth(), 1);
      break;

    case 'quarterly':
      startDate = new Date(now.getFullYear(), Math.floor(now.getMonth() / 3) * 3, 1);
      break;

    case 'semiannual':
      startDate = new Date(now.getFullYear(), now.getMonth() < 6 ? 0 : 6, 1);
      break;

    case 'annual':
      startDate = new Date(now.getFullYear(), 0, 1);
      break;

    default:
      return null;
  }

  return startDate;
};

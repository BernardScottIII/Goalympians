/**
 * Returns an object containing two Date objects spanning one month and the
 * first of the following month
 * @param {Date} date - Day within the month desired to be outlined
 * @return {{currentMonthStart: Date, nextMonthStart: Date}} - First date is
 * the first of the current month, and the second date is the first of the
 * following month
 */
export function currentAndNextMonthStart(date: Date): {
  currentMonthStart: Date;
  nextMonthStart: Date;
} {
  const currentYear = date.getUTCFullYear();
  const currentMonth = date.getUTCMonth();

  const currentMonthStart = new Date(Date.UTC(currentYear, currentMonth, 1));

  const nextMonthStart = new Date(Date.UTC(currentYear, currentMonth+1, 1));

  return {currentMonthStart, nextMonthStart};
}

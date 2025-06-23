export function currentAndNextMonthStart(date: Date): {
  currentMonthStart: Date;
  nextMonthStart: Date;
} {
  const currentYear = date.getUTCFullYear();
  const currentMonth = date.getUTCMonth();

  const currentMonthStart = new Date(Date.UTC(currentYear, currentMonth, 1));

  const nextMonthStart = new Date(Date.UTC(currentYear, currentMonth+1, 1));

  return { currentMonthStart, nextMonthStart };
}
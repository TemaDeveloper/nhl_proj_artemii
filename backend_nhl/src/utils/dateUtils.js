import moment from 'moment';

export function getDateRange(daysToIngest = 0) {
  const dates = [];
  for (let i = daysToIngest; i >= 0; i--) {
    const date = moment().subtract(i, 'days').format('YYYY-MM-DD');
    dates.push(date);
  }
  return dates;
}
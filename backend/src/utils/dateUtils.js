import moment from 'moment';
import { ValidationError } from './errors.js';

/**
 * Generates an array of dates from today going back a specified number of days.
 * @param {number} daysToIngest - Number of days to ingest (0-365)
 * @returns {Array<string>} Array of dates in YYYY-MM-DD format
 * @throws {ValidationError} If daysToIngest is invalid
 */
export function getDateRange(daysToIngest = 0) {
  if (daysToIngest < 0) {
    throw new ValidationError('daysToIngest', 'Must be a non-negative number');
  }

  if (daysToIngest > 365) {
    throw new ValidationError('daysToIngest', 'Cannot ingest more than 365 days');
  }

  const dates = [];
  for (let i = daysToIngest; i >= 0; i--) {
    const date = moment().subtract(i, 'days').format('YYYY-MM-DD');
    dates.push(date);
  }
  return dates;
}
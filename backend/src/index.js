import * as dotenv from 'dotenv';
dotenv.config();

import './config/firebase.js';
import { ingestGameData } from './services/gameService.js';

function parseDaysArgument() {
  const arg = process.argv[2];
  
  if (!arg) {
    return 0;
  }

  const days = parseInt(arg, 10);

  if (isNaN(days) || days < 0) {
    console.error(`❌ ERROR: Invalid days argument: "${arg}"`);
    console.error('Usage: node src/index.js [days]');
    console.error('Examples:');
    console.error('  node src/index.js      # Today only');
    console.error('  node src/index.js 1    # Last 1 day');
    console.error('  node src/index.js 7    # Last 7 days');
    console.error('  node src/index.js 30   # Last 30 days');
    console.error('  node src/index.js 100  # Last 100 days');
    process.exit(1);
  }

  if (days > 365) {
    console.warn(`⚠️  WARNING: Ingesting ${days} days. This may take a while and consume API quota.`);
  }

  return days;
}

const days = parseDaysArgument();
ingestGameData(days);
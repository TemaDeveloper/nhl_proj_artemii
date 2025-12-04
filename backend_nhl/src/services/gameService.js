import axios from 'axios';
import db from '../config/firebase.js';
import { fetchGameDetails, fetchGameSchedule } from './nhlApi.js';
import { transformGameData } from '../transformers/gameTransformer.js';
import { getDateRange } from '../utils/dateUtils.js';
import { GAMES_COLLECTION, GAME_STATES_FOR_DETAILS } from '../constants/index.js';

/**
 * Processes a single game.
 */
async function processGame(game) {
  const gameId = game.id;
  const shouldFetchDetails = GAME_STATES_FOR_DETAILS.includes(game.gameState);
  const boxscore = shouldFetchDetails ? await fetchGameDetails(gameId) : {};

  const gameData = transformGameData(game, boxscore);
  
  const docRef = db.collection(GAMES_COLLECTION).doc(String(gameId));
  await docRef.set(gameData, { merge: true });
  
  console.log(`Ingested/Updated Game: ${gameId} (${game.awayTeam.abbrev} @ ${game.homeTeam.abbrev})`);
}

/**
 * Ingests game data for a specified number of days.
 */
export async function ingestGameData(days = 0) {
  const dates = getDateRange(days);
  console.log(`\nStarting NHL data ingestion for dates: ${dates.join(', ')}`);

  for (const date of dates) {
    try {
      const scheduleResponse = await fetchGameSchedule(date);
      
      const games = scheduleResponse.gameWeek?.flatMap(week => week.games) || [];
      
      console.log(`\n-- Date: ${date} | Found ${games.length} games. --`);
      
      for (const game of games) {
        await processGame(game);
      }
      
    } catch (error) {
      console.error(`\nERROR processing data for date ${date}: ${error.message}`);
    }
  }

  console.log('\nIngestion process finished.');
}
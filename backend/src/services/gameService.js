import axios from 'axios';
import db from '../config/firebase.js';
import { fetchGameDetails, fetchGameSchedule } from './nhlApi.js';
import { transformGameData } from '../transformers/gameTransformer.js';
import { getDateRange } from '../utils/dateUtils.js';
import { GAMES_COLLECTION, GAME_STATES_FOR_DETAILS } from '../constants/index.js';
// NEW IMPORT: Centralize the team ingestion call here
import { ingestTeamData } from './teamService.js'; 

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
 * Ingests both game data and team standings for a specified number of days.
 * This is now the central ingestion coordinator.
 */
export async function ingestGameData(days = 0) {
  const dates = getDateRange(days);
  console.log(`\nStarting combined NHL data ingestion for ${dates.length} dates: ${dates.join(', ')}`);

  for (const date of dates) {
    try {
      console.log(`\n======================================================`);
      console.log(`Starting processing for date: ${date}`);
      console.log(`======================================================`);
      
      // 1. INGEST TEAM STANDINGS FOR THE CURRENT DATE
      // We assume ingestTeamData handles a single date (YYYY-MM-DD string)
      await ingestTeamData(date); 
      
      // 2. INGEST GAME SCHEDULE AND DETAILS FOR THE CURRENT DATE
      const scheduleResponse = await fetchGameSchedule(date);
      
      const games = scheduleResponse.gameWeek?.flatMap(week => week.games) || [];
      
      console.log(`\n-- Game Schedule - Date: ${date} | Found ${games.length} games. --`);
      
      for (const game of games) {
        await processGame(game);
      }
      
    } catch (error) {
      console.error(`\n❌ CRITICAL ERROR processing data for date ${date}: ${error.message}`);
    }
  }

  console.log('\nCombined Ingestion process finished.');
}
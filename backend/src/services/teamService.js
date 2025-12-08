import db from '../config/firebase.js';
import admin from 'firebase-admin'; 
import { fetchTeamStandings } from './nhlApi.js';
import { transformTeamData } from '../transformers/teamTransformer.js';
import { TEAMS_COLLECTION } from '../constants/index.js';

/**
 * Processes a single team's standing data, ensuring createdAt is preserved.
 */
async function processTeam(teamData) {
  const teamId = teamData.id;
  const docRef = db.collection(TEAMS_COLLECTION).doc(String(teamId));
  
  const dataToSet = { ...teamData }; 
  
  const existingDoc = await docRef.get();

  if (existingDoc.exists && existingDoc.data().createdAt) {
    dataToSet.createdAt = existingDoc.data().createdAt;
  } else {
    dataToSet.createdAt = admin.firestore.FieldValue.serverTimestamp();
  }
  
  await docRef.set(dataToSet, { merge: true });
  
  console.log(`Ingested/Updated Team: ${teamData.fullName} (${teamId})`);
}

/**
 * Ingests team standings for a specified date.
 * @param {string} date - The date to fetch standings for (YYYY-MM-DD).
 */
export async function ingestTeamData(date) {
  const standingsDate = date; 
  console.log(`\nStarting NHL team standings ingestion for date: ${standingsDate}`);

  try {
    const standingsResponse = await fetchTeamStandings(standingsDate);
    
    const teams = standingsResponse.standings || [];
    
    console.log(`\n-- Date: ${standingsDate} | Found ${teams.length} teams. --`);
    
    for (const rawTeam of teams) {
      const teamData = transformTeamData(rawTeam);

      const city = teamData.city || '';
      const name = teamData.name || '';

      teamData.fullName = `${city} ${name}`.trim(); 

      await processTeam(teamData);
    }
    
  } catch (error) {
    console.error(`\nERROR processing team standings for date ${standingsDate}: ${error.message}`);
  }
}
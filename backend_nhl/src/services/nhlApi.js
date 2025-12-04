import axios from 'axios';
import { NHL_API_BASE } from '../constants/index.js';

export const fetchGameSchedule = async (date) => {
  try {
    const url = `${NHL_API_BASE}/schedule/${date}`;
    const response = await axios.get(url);
    return response.data;
  } catch (error) {
    console.warn(`WARN fetching schedule for date ${date}. Status: ${error.response?.status || 'No Status'} - ${error.message}`);
    return {};
  }
};

export const fetchGameDetails = async (gameId) => {
  try {
    const url = `${NHL_API_BASE}/gamecenter/${gameId}/boxscore`;
    const response = await axios.get(url);
    return response.data;
  } catch (error) {
    console.warn(`WARN fetching boxscore for game ${gameId}. Status: ${error.response?.status || 'No Status'} - ${error.message}`);
    return {};
  }
};

export const fetchTeamStandings = async (date) => {
  try {
    const url = `${NHL_API_BASE}/standings/${date}`;
    const response = await axios.get(url);
    return response.data;
  } catch (error) {
    console.warn(`WARN fetching standings for date ${date}. Status: ${error.response?.status || 'No Status'} - ${error.message}`);
    return {};
  }
};
import admin from 'firebase-admin';

/**
 * Safely extract the team name.
 */
function getTeamName(team) {
  if (team.name && typeof team.name.default === 'string') {
    return team.name.default;
  }
  if (typeof team.name === 'string') {
    return team.name;
  }
  return team.abbrev || 'UNKNOWN_TEAM';
}

/**
 * Transforms the raw API game data into the clean Firestore schema.
 */
export function transformGameData(rawGame, rawBoxscore = {}) {
  const homeTeam = rawGame.homeTeam;
  const awayTeam = rawGame.awayTeam;

  const homeScore = rawBoxscore.homeTeam?.score ?? rawGame.homeTeam.score ?? 0;
  const awayScore = rawBoxscore.awayTeam?.score ?? rawGame.awayTeam.score ?? 0;
  const status = rawGame.gameState || 'UNKNOWN';

  return {
    gameId: rawGame.id,
    startTime: rawGame.startTimeUTC,
    status,
    homeTeam: {
      id: homeTeam.id,
      name: getTeamName(homeTeam),
      abbrev: homeTeam.abbrev,
      score: homeScore,
      logoUrl: homeTeam.logo || null,
      darkLogoUrl: homeTeam.darkLogo || null,
    },
    awayTeam: {
      id: awayTeam.id,
      name: getTeamName(awayTeam),
      abbrev: awayTeam.abbrev,
      score: awayScore,
      logoUrl: awayTeam.logo || null,
      darkLogoUrl: awayTeam.darkLogo || null,
    },
    raw: {
      schedule: rawGame,
      boxscore: rawBoxscore,
    },
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
}
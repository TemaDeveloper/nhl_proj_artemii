import admin from 'firebase-admin';

/**
 * Transforms the raw API team standings data into the clean Firestore schema.
 * This function directly maps the calculated statistics provided by the API.
 */
export function transformTeamData(rawTeam) {
  const id = rawTeam.teamAbbrev?.default;

  return {
    id: id,
    name: rawTeam.teamName?.default ?? 'Unknown Team',
    city: rawTeam.placeName?.default ?? 'Unknown City',
    logo: rawTeam.teamLogo || null, 

    conference: rawTeam.conferenceName,
    division: rawTeam.divisionName,

    wins: rawTeam.wins ?? 0,
    losses: rawTeam.losses ?? 0,
    overtimeLosses: rawTeam.otLosses ?? 0, 

    points: rawTeam.points ?? 0,
    totalGames: rawTeam.gamesPlayed ?? 0,
    winPercentage: rawTeam.winPctg ?? 0.0,
    pointsPercentage: rawTeam.pointPctg ?? 0.0,

    raw: rawTeam,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
}
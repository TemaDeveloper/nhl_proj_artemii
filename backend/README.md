# NHL Data Ingestion Service

A Node.js service that ingests NHL game data from the official NHL API and stores it in Firebase Firestore.

## Features

- **Idempotent Operations**: Re-running the same ingestion won't create duplicates. Games are upserted using `merge: true`.
- **Graceful Error Handling**: Network errors, API failures, and missing data are logged and skipped without stopping the entire ingestion.
- **Schema Flexibility**: New API fields are preserved in a `raw` object without breaking existing fields.
- **Configurable Backfill**: Ingest data for any number of days (today, 2 days, 3 days, 7 days, 30 days, or custom).

## Setup

### Prerequisites
- Node.js >= 18.0.0
- Firebase project with Firestore enabled
- Firebase service account key

### Installation

```bash
npm install
```

### Configuration

Create a `.env` file in the root directory:

```env
FIREBASE_CREDENTIALS_PATH=./service-account-key.json
```

Place your Firebase service account JSON key at the specified path.

## Usage

### Ingest for Different Time Periods

```bash
npm run ingest:today       # Ingest today's games
npm run ingest:2days       # Ingest last 2 days
npm run ingest:3days       # Ingest last 3 days
npm run ingest:week        # Ingest last 7 days
npm run ingest:month       # Ingest last 30 days

# Or use custom days
node src/index.js 5        # Ingest last 5 days
```

### Development Mode

```bash
npm run dev    # Runs with auto-reload on file changes
```

## Architecture

```
src/
├── index.js                 # Entry point
├── config/
│   └── firebase.js          # Firebase initialization
├── constants/
│   └── index.js             # API constants
├── services/
│   ├── gameService.js       # Main ingestion logic
│   └── nhlApi.js            # NHL API calls
├── transformers/
│   └── gameTransformer.js   # Data transformation
└── utils/
    └── dateUtils.js         # Date utilities
```

## Idempotency

The service uses Firestore's `set(..., { merge: true })` operation:

- **First run**: Creates new game documents with ID = `gameId`
- **Subsequent runs**: Updates existing documents without creating duplicates
- **Score updates**: If a game score changes, the existing document is overwritten with new data
- **No duplicates**: Each game is stored once per `gameId`, regardless of how many times you run the ingestion

Example:
```javascript
// Always uses gameId as the document key
const docRef = db.collection('games').doc(String(gameId));
await docRef.set(gameData, { merge: true });
```

## Error Handling

The service gracefully handles:

1. **Network Errors**: Logs warning and continues with next date/game
2. **API Failures**: If NHL API is unreachable, skips that date
3. **Missing Data**: Safely extracts team names, scores with nullish coalescing (`??`)
4. **Partial Records**: Stores whatever data is available; skips malformed games

Example error handling in `nhlApi.js`:
```javascript
catch (error) {
  console.warn(`WARN fetching schedule for date ${date}. Status: ${error.response?.status}`);
  return {};  // Returns empty object instead of throwing
}
```

## Schema Flexibility

The Firestore document structure stores raw API responses alongside processed data:

```javascript
{
  gameId: "2025020406",
  startTime: "2025-12-01T00:00:00Z",
  status: "FINAL",
  homeTeam: { id, name, abbrev, score, logoUrl, darkLogoUrl },
  awayTeam: { id, name, abbrev, score, logoUrl, darkLogoUrl },
  raw: {
    schedule: { /* full raw game object */ },
    boxscore: { /* full raw boxscore object */ }
  },
  updatedAt: 1733222400000
}
```

**Benefits:**
- New NHL API fields are automatically preserved in `raw.schedule` and `raw.boxscore`
- Existing processed fields (`homeTeam`, `awayTeam`, etc.) remain stable
- No migrations needed if NHL API adds new data

## Backfill Strategy (30-day example)

To backfill the last 30 days:

```bash
npm run ingest:month
```

This runs:
```javascript
node src/index.js 30
```

The `getDateRange(30)` function generates dates from today back to 30 days ago:
```javascript
export function getDateRange(daysToIngest = 0) {
  const dates = [];
  for (let i = daysToIngest; i >= 0; i--) {
    const date = moment().subtract(i, 'days').format('YYYY-MM-DD');
    dates.push(date);
  }
  return dates;
}
```

**For even larger backfills** (e.g., entire season):
- Modify `package.json` to add: `"ingest:season": "node src/index.js 180"`
- Or implement pagination in `nhlApi.js` to fetch multiple weeks at once
- Add a `--batch-delay` flag to avoid rate limiting

## Firestore Configuration

### Required Collections
- `games` - Stores all ingested game documents

### Document Structure
- **Key**: Game ID (e.g., `"2025020406"`)
- **Fields**: See Schema Flexibility section above

### Indexes
No custom indexes required for basic queries, but for advanced analytics:
```
Collection: games
Index on: startTime (Ascending), status (Ascending)
```

## Logging

All ingestion runs produce logs:
```
🚀 Starting NHL data ingestion for dates: 2025-12-01, 2025-12-02, ...
-- Date: 2025-12-01 | Found 55 games. --
  ✅ Ingested/Updated Game: 2025020406 (CBJ @ NJD)
  ✅ Ingested/Updated Game: 2025020407 (PIT @ PHI)
...
✨ Ingestion process finished. ✨
```

## Troubleshooting

### "FIREBASE_CREDENTIALS_PATH environment variable is not set"
- Ensure `.env` file exists in the root directory
- Verify path points to valid Firebase service account JSON

### "Found 0 games" for all dates
- Check if those dates have NHL games scheduled
- Verify NHL API is accessible: `curl https://api-web.nhle.com/v1/schedule/2025-12-01`

### Firebase connection errors
- Verify Firebase project ID in service account JSON
- Ensure Firestore is enabled in Firebase console
- Check IAM permissions for service account

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `FIREBASE_CREDENTIALS_PATH` | Required | Path to Firebase service account JSON |

## Dependencies

- `axios` - HTTP client for NHL API
- `dotenv` - Environment variable loader
- `firebase-admin` - Firebase SDK
- `moment` - Date manipulation

## License

ISC
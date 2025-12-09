# NHL Backend Service

A Node.js backend service that ingests NHL game data from the official NHL API and stores it in Firebase Firestore, enabling real-time updates for the NHL Score Tracker application.

## Overview

This backend service provides:
- **Real-time Game Data**: Fetches current and historical game information from the official NHL API
- **Team Standings**: Retrieves team standings and statistics automatically
- **Smart Data Ingestion**: CLI-based tool for on-demand backfilling with idempotent operations
- **Firebase Integration**: Stores all data in Cloud Firestore for seamless frontend access
- **Graceful Error Handling**: Network errors and API failures don't stop the entire ingestion process

## Features

- **Idempotent Operations**: Re-running the same ingestion won't create duplicates. Games are upserted using `merge: true`.
- **Comprehensive Error Handling**: Network errors, API failures, and missing data are logged and skipped without stopping the entire ingestion.
- **Schema Flexibility**: New API fields are preserved in a `raw` object without breaking existing fields.
- **Configurable Backfill**: Ingest data for any number of days (today, week, month, 100 days, or custom).
- **Automatic Timestamp Tracking**: Updates include `updatedAt` timestamps for cache validation

## Tech Stack

- **Runtime**: Node.js >= 18.0.0
- **Database**: Firebase Cloud Firestore
- **API Client**: Axios
- **Date Handling**: Moment.js
- **Authentication**: Firebase Admin SDK

## Project Structure

```
backend/
├── src/
│   ├── index.js              # CLI entry point with argument parsing
│   ├── config/
│   │   └── firebase.js       # Firebase Admin SDK initialization
│   ├── constants/
│   │   └── index.js          # Application constants and API endpoints
│   ├── services/
│   │   ├── gameService.js    # Game data ingestion orchestration
│   │   ├── teamService.js    # Team standings ingestion
│   │   └── nhlApi.js         # NHL API wrapper and HTTP client
│   ├── transformers/
│   │   ├── gameTransformer.js # Transforms raw API data to Firestore format
│   │   └── teamTransformer.js # Team data transformation
│   └── utils/
│       ├── dateUtils.js      # Date range calculations for backfill
│       └── errors.js         # Custom error classes (ValidationError, APIError, FirestoreError)
├── .env                      # Environment variables (not tracked in git)
├── .gitignore                # Git ignore rules
├── service-account-key.json  # Firebase service account credentials (not tracked)
├── package.json              # Dependencies and npm scripts
└── README.md                 # This file

## Setup

### Prerequisites
- Node.js >= 18.0.0
- Firebase project with Firestore enabled
- Firebase service account key from Firebase Console

### Installation

1. **Install Dependencies**
   ```bash
   npm install
   ```

2. **Configure Environment**
   Create a `.env` file in the root directory:
   ```env
   FIREBASE_CREDENTIALS_PATH=./service-account-key.json
   FIREBASE_PROJECT_ID=nhl-project-75e9c
   ```

3. **Add Firebase Credentials**
   - Download your Firebase service account key from Firebase Console
   - Save it as `service-account-key.json` in the project root
   - **Important**: Never commit this file to version control

4. **Verify Installation**
   ```bash
   npm run ingest:today
   ```
   This will fetch today's games and populate your Firestore database.

## Usage

### Available NPM Commands

```bash
# Ingest today's games
npm run ingest:today

# Ingest last 7 days
npm run ingest:week

# Ingest last 30 days
npm run ingest:month

# Ingest last 100 days (comprehensive backfill)
npm run ingest:100

# Development mode with auto-reload
npm run dev
```

### Custom Date Range

Ingest games for any number of days:
```bash
node src/index.js 5        # Ingest last 5 days
node src/index.js 14       # Ingest last 2 weeks
```

### Typical Workflow

1. **Initial Setup**: Run once to backfill historical data
   ```bash
   npm run ingest:100      # Get 100 days of history
   ```

2. **Daily Updates**: Run daily (via cron or scheduler) to stay current
   ```bash
   npm run ingest:today
   ```

3. **Weekly Backfill**: Periodically sync past week to catch any missed updates
   ```bash
   npm run ingest:week
   ```

## Architecture

The backend follows a modular service-based architecture:

```
┌─────────────┐
│  CLI Entry  │ (index.js)
│   (Node)    │
└──────┬──────┘
       │
       ├─────────────────────┬──────────────────────┐
       │                     │                      │
   ┌───▼────┐          ┌─────▼─────┐          ┌───▼────┐
   │  Game  │          │   Team    │          │  Date  │
   │Service │          │  Service  │          │ Utils  │
   └───┬────┘          └─────┬─────┘          └────────┘
       │                     │
       │     ┌───────────────┴───────────────┐
       │     │                               │
   ┌───▼─────▼──┐          ┌────────────────▼──┐
   │  NHL API   │          │   Transformer     │
   │  Wrapper   │          │   (Data Format)   │
   └────┬───────┘          └──────────────────┘
        │                          │
        └──────────────┬───────────┘
                       │
              ┌────────▼─────────┐
              │ Firebase Store   │
              │ (Firestore)      │
              └──────────────────┘
```

### Module Descriptions

- **index.js**: Entry point that parses CLI arguments and orchestrates the ingestion flow
- **gameService.js**: Coordinates game fetching and transformation, manages Firestore writes
- **teamService.js**: Handles team standings ingestion and updates
- **nhlApi.js**: Makes HTTP requests to NHL API, handles rate limiting and errors
- **gameTransformer.js**: Normalizes raw NHL API responses to Firestore document format
- **dateUtils.js**: Generates date ranges for backfill operations

## Data Model

### Games Collection

Firestore Collection: `games`

Document ID: Game ID (e.g., `"2025020406"`)

```javascript
{
  gameId: "2025020406",
  startTime: "2025-12-01T20:00:00Z",
  status: "FINAL",                    // SCHEDULED, LIVE, FINAL
  
  homeTeam: {
    id: 1,
    name: "Colorado Avalanche",
    abbrev: "COL",
    score: 3,
    logoUrl: "https://...",
    darkLogoUrl: "https://..."
  },
  
  awayTeam: {
    id: 2,
    name: "Dallas Stars",
    abbrev: "DAL",
    score: 2,
    logoUrl: "https://...",
    darkLogoUrl: "https://..."
  },
  
  venue: {
    name: "Ball Arena",
    city: "Denver"
  },
  
  season: 20242025,
  updatedAt: 1733222400000,           // Timestamp for cache validation
  
  // Raw API responses preserved for future expansion
  raw: {
    schedule: { /* full raw game object from /schedule */ },
    boxscore: { /* full raw boxscore object if available */ }
  }
}
```

### Teams Collection

Firestore Collection: `teams`

Document ID: Team ID (e.g., `"1"`)

```javascript
{
  id: 1,
  name: "Colorado Avalanche",
  abbrev: "COL",
  season: 20242025,
  
  // Standings
  wins: 15,
  losses: 8,
  overtimeLosses: 2,
  points: 32,
  gamesPlayed: 25,
  pointsPercentage: 0.640,
  
  // Logos
  logoUrl: "https://...",
  darkLogoUrl: "https://...",
  
  // Metadata
  updatedAt: 1733222400000
}
```

## Key Design Principles

### Idempotency
The service uses Firestore's `set(..., { merge: true })` operation:
- **First run**: Creates new documents with gameId as document ID
- **Subsequent runs**: Updates existing documents without creating duplicates
- **Score updates**: Changes are reflected automatically without duplication
- **No data loss**: Field-level merging preserves existing data

### Graceful Error Handling
The service is designed to be resilient:
- **Network errors**: Logged and skipped; doesn't stop the entire process
- **API failures**: Continues with other dates if one fails
- **Missing data**: Uses nullish coalescing (`??`) to handle missing fields
- **Partial records**: Stores whatever data is available

### Schema Flexibility
Raw API responses are preserved in a `raw` field:
- New NHL API fields are automatically captured
- Existing processed fields remain stable
- No migrations needed when NHL API changes
- Easy to backfill derived fields later

## NHL API Integration

### Base URL
```
https://api-web.nhle.com/v1/
```

### Endpoints Used

1. **Game Schedule**
   ```
   GET /schedule?date=YYYY-MM-DD
   Returns: Games for the specified date
   ```

2. **Team Standings**
   ```
   GET /standings/[SEASON]
   Returns: Current team standings and statistics
   ```

### Rate Limiting
- The NHL API has built-in rate limiting
- The backend implements reasonable delays between requests
- For large backfills (100+ days), consider adding delays

## Firestore Security Rules

Recommended security rules configuration:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow anyone to read games (public data)
    match /games/{gameId} {
      allow read: if true;
      allow write: if false;  // Only backend can write
    }
    
    // Allow anyone to read teams
    match /teams/{teamId} {
      allow read: if true;
      allow write: if false;  // Only backend can write
    }
  }
}
```

## Logging & Monitoring

The backend produces structured logs:

```
🚀 Starting NHL data ingestion for dates: 2025-12-01, 2025-12-02, ...
-- Date: 2025-12-01 | Found 55 games. --
  ✅ Ingested/Updated Game: 2025020406 (CBJ @ NJD)
  ✅ Ingested/Updated Game: 2025020407 (PIT @ PHI)
  ⚠️  WARN: Missing data for game 2025020408
...
✨ Ingestion process finished. ✨
```

### Key Metrics
- **Games fetched**: Total games found for date range
- **Games ingested**: Games successfully written to Firestore
- **Errors**: Network, API, or database errors encountered
- **Duration**: Total time for ingestion cycle

## Troubleshooting

### "FIREBASE_CREDENTIALS_PATH is not set"
**Solution**: 
- Create `.env` file in project root
- Add `FIREBASE_CREDENTIALS_PATH=./service-account-key.json`

### "Found 0 games" for all dates
**Solution**:
- Check if NHL games are scheduled for those dates
- Verify NHL API accessibility: `curl https://api-web.nhle.com/v1/schedule/2025-12-01`
- Check internet connection

### Firebase Connection Errors
**Solution**:
- Verify service account JSON is valid and not corrupted
- Ensure Firebase project ID matches in service account
- Check that Firestore is enabled in Firebase Console
- Verify service account has Firestore read/write permissions

### High Memory Usage
**Solution**:
- Reduce backfill window (use 7 days instead of 100)
- Implement streaming writes for large backfills
- Clear old game data periodically

## Production Deployment: GitHub Actions

The backend service is designed to run on a schedule, ingesting fresh game data daily. **GitHub Actions** is the recommended approach for simplicity and cost.

### Why GitHub Actions?

✅ **Free** — GitHub includes 2000 minutes/month  
✅ **Simple** — No infrastructure to manage  
✅ **Integrated** — Lives in your repository  
✅ **Transparent** — Full logs and history in GitHub UI  
✅ **Flexible** — Can trigger manually anytime  

### Setup Instructions

#### Step 1: Store Firebase Credentials

Add your Firebase service account key to GitHub Secrets:

1. Download your Firebase service account key from Firebase Console
2. Go to GitHub repo → Settings → Secrets and variables → Actions
3. Create secret: `FIREBASE_SERVICE_ACCOUNT_KEY`
4. Paste the entire JSON content (multi-line is fine)

Never commit `service-account-key.json` to your repository.

#### Step 2: Create Workflow File

Create `.github/workflows/nhl-ingest.yml` in your repository:

```yaml
name: Daily NHL Data Ingest

on:
  schedule:
    # Runs at 9:00 AM UTC every day
    - cron: '0 9 * * *'
  
  # Allow manual trigger via GitHub UI
  workflow_dispatch:

jobs:
  ingest:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - uses: actions/cache@v3
        with:
          path: backend/node_modules
          key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
      
      - name: Install dependencies
        run: |
          cd backend
          npm ci
      
      - name: Configure Firebase
        env:
          FIREBASE_KEY: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}
        run: |
          echo "$FIREBASE_KEY" > backend/service-account-key.json
      
      - name: Ingest today's games
        run: |
          cd backend
          npm run ingest:today
      
      - name: Notify on failure (optional)
        if: failure()
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: '❌ NHL ingest failed!'
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

#### Step 3: Test the Workflow

1. Commit and push the workflow file to your repository
2. Go to GitHub → Actions → "Daily NHL Data Ingest"
3. Click "Run workflow" to test immediately
4. Monitor execution in real-time
5. Check logs for any errors

#### Step 4: Monitor Scheduled Runs

The workflow runs automatically daily at 9:00 AM UTC. To monitor:

- Go to GitHub → Actions → "Daily NHL Data Ingest"
- Each workflow run shows:
  - Execution start and end time
  - Success/failure status
  - Step-by-step execution logs
  - Duration and resource usage

### Workflow Execution Flow

```
GitHub Actions Scheduler
    ↓ (Every day at 9:00 AM UTC)
Ubuntu Runner (GitHub infrastructure)
    ↓
1. Check out repository code
2. Set up Node.js 18
3. Cache npm dependencies
4. Load Firebase credentials from secret
5. Install dependencies (npm ci)
6. Run: npm run ingest:today
    ↓
Node.js Service
    ↓
1. Fetch games from NHL API
2. Transform data
3. Upsert to Firestore
    ↓
Success/Failure Report
    ↓
(Optional) Send Slack notification
```

### Customizing the Schedule

Edit the cron expression in `.github/workflows/nhl-ingest.yml`:

```yaml
# Run at different times (all times in UTC):

# Daily at 6:00 AM UTC
- cron: '0 6 * * *'

# Twice daily (9 AM and 9 PM UTC)
- cron: '0 9,21 * * *'

# Every 6 hours
- cron: '0 */6 * * *'

# Only on weekdays at 9 AM UTC
- cron: '0 9 * * 1-5'
```

**Format**: `minute hour day month weekday` (all in UTC)

### Backfilling Historical Data

For one-time historical ingestion:

```bash
# Run locally
node src/index.js 30        # Ingest last 30 days
node src/index.js 7         # Ingest last 7 days
```

Or temporarily modify the workflow:

```yaml
- name: Ingest historical data
  run: |
    cd backend
    node src/index.js 30    # 30 days
```

Then manually trigger via GitHub UI.

### Adding Slack Notifications (Optional)

To be notified of ingest failures:

1. Create a Slack webhook: https://api.slack.com/messaging/webhooks
2. Go to GitHub repo → Settings → Secrets and variables → Actions
3. Create secret: `SLACK_WEBHOOK` (paste webhook URL)
4. Workflow already includes notification step (will auto-trigger on failure)

### Troubleshooting

**Workflow not running?**
- Check: GitHub repo → Settings → Actions → Enable workflows
- Verify workflow file is in `.github/workflows/nhl-ingest.yml`
- Commit to default branch (usually `main` or `master`)

**Ingestion failed?**
- View logs: GitHub → Actions → Click workflow run
- Check Firebase credentials are correct in GitHub Secrets
- Verify NHL API is accessible (test locally first)

**Manual trigger not working?**
- Ensure workflow file has `workflow_dispatch:` in `on:` section
- Commit and push changes
- Wait a few seconds, refresh page

**"service-account-key.json not found"?**
- Verify `FIREBASE_SERVICE_ACCOUNT_KEY` secret is set correctly
- Check secret value is valid JSON (not truncated)
- Re-paste the entire service account key

### Cost Breakdown

| Item | Usage | Cost |
|------|-------|------|
| GitHub Actions | ~5 min/day × 30 = 150 min/mo | Free ($0) |
| Firestore writes | ~1800 games/month | <$0.01 |
| NHL API calls | ~1800/month | Free |
| **Total Monthly** | | **~$0.01** |

### Security Considerations

✅ **Good Practices:**
- Firebase credentials stored in GitHub Secrets (encrypted, never logged)
- Service account key only written during workflow execution
- No credentials visible in workflow logs
- Temporary file cleaned up automatically

⚠️ **Never:**
- Commit `service-account-key.json` to repository
- Log `FIREBASE_SERVICE_ACCOUNT_KEY` value
- Use hardcoded credentials in workflow files
- Share secret values in GitHub issues

### Next Steps

1. ✅ Create `.github/workflows/nhl-ingest.yml`
2. ✅ Add `FIREBASE_SERVICE_ACCOUNT_KEY` secret to GitHub
3. ✅ Test manually via GitHub UI
4. ✅ Verify first automated run at 9 AM UTC tomorrow
5. ✅ (Optional) Add Slack webhook for failure alerts

Once set up, the service runs automatically every day with **zero maintenance**!

## Dependencies

| Package | Purpose |
|---------|---------|
| `axios` | HTTP client for NHL API requests |
| `dotenv` | Environment variable management |
| `firebase-admin` | Firebase SDK and Firestore access |
| `moment` | Date parsing and calculations |

## Future Enhancements

- [ ] Player statistics ingestion
- [ ] Advanced game analytics and metrics
- [ ] Real-time game updates via polling
- [ ] Caching layer for frequently accessed data
- [ ] WebSocket support for live updates
- [ ] Comprehensive logging and monitoring
- [ ] Database query optimization and indexing
- [ ] Automatic data retention policies

## Support & Troubleshooting Checklist

Before reporting issues:
- [ ] `.env` file exists with correct paths
- [ ] `service-account-key.json` is present and valid
- [ ] Node.js version >= 18.0.0
- [ ] All dependencies installed (`npm install`)
- [ ] Firebase Console shows Firestore enabled
- [ ] Network access to NHL API (`https://api-web.nhle.com/v1/`) confirmed
- [ ] Service account has Firestore write permissions

## License

This project is part of the NHL Score Tracker application.
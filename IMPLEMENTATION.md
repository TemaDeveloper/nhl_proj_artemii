# NHL Scores Mini App – Implementation Report

## Executive Summary

This document outlines the complete implementation of a full-stack NHL scores application built with Node.js (backend), Flutter (frontend), and Firebase Firestore. The project demonstrates clean architecture, thoughtful API design, and practical problem-solving for a real-world data ingestion and display scenario.

**Status**: Fully functional with core requirements met + optional enhancements completed.

---

## Part 1: Data Ingestion Backend (Node + Firestore)

### Problem Statement
Build a service that fetches NHL game data from a public API and stores it in Firestore idempotently, handling network failures gracefully.

### Approach & Architecture

#### 1.1 **Service Architecture**

I chose a **modular service-based architecture** with clear separation of concerns:

```
CLI Entry (index.js)
    ↓
GameService (orchestration)
    ↓
NHLApi (HTTP wrapper) + GameTransformer (data normalization)
    ↓
Firestore (data persistence)
```

**Why this structure?**
- **Testability**: Each module can be tested independently
- **Maintainability**: Clear responsibility boundaries
- **Reusability**: Services can be invoked from multiple entry points
- **Extensibility**: Easy to add TeamService, PlayerService, etc.

#### 1.2 **Technology Choices**

| Choice | Rationale |
|--------|-----------|
| **Node.js + ES6** | Familiar, lightweight for scripting; Firebase Admin SDK excellent support |
| **Axios** | Promise-based HTTP client, better error handling than fetch |
| **Moment.js** | Reliable date manipulation for backfill calculations |
| **Firebase Admin SDK** | Official, battle-tested, full Firestore access |
| **Custom Error Classes** | Type-safe error handling, easier debugging |

### Implementation Details

#### 1.3 **Data Ingestion Flow**

**File**: `backend/src/index.js`

```javascript
// User runs: npm run ingest:today
// Or: node src/index.js 7 (for 7 days)

1. Parse CLI arguments → daysToIngest (default 0 = today)
2. Generate date range → [today, yesterday, ..., N days ago]
3. For each date:
   a. Call NHL API /schedule?date=YYYY-MM-DD
   b. Transform response via gameTransformer
   c. Upsert to Firestore with merge: true
4. Log results (games ingested, errors, duration)
```

**Key Decision: Idempotency via `merge: true`**

```javascript
// In gameService.js
const docRef = db.collection('games').doc(String(gameId));
await docRef.set(gameData, { merge: true });
```

**Why `merge: true`?**
- ✅ First run: Creates new document
- ✅ Subsequent runs: Updates existing fields without losing data
- ✅ No duplicates: gameId is the unique key
- ✅ Score updates: Changes automatically reflected
- ❌ Would have required: Complex duplicate detection logic

#### 1.4 **Error Handling Strategy**

**Philosophy**: "Log it, log it well, and move on"

```javascript
// In nhlApi.js
try {
  const response = await axios.get(`${API_BASE}/schedule?date=${date}`);
  return response.data;
} catch (error) {
  console.warn(`⚠️ Failed to fetch schedule for ${date}`);
  console.warn(`   Status: ${error.response?.status}`);
  console.warn(`   Will skip this date and continue`);
  return { games: [] }; // Return empty instead of throwing
}
```

**Tradeoff Analysis**:
- ✅ **Resilience**: Service completes even if one date fails
- ✅ **Visibility**: Each error is logged with context
- ❌ **Strictness**: Won't fail the entire job for a single bad date

**Alternative Considered**: Strict mode with full rollback
- Would have required transaction support (Firestore has limits)
- For a data ingestion job, partial success is often acceptable
- **Decision**: Chose resilience over strictness

#### 1.5 **Schema Flexibility & Extension**

**Problem**: NHL API might add new fields; we don't want migrations.

**Solution**: Preserve raw response + normalized fields

```javascript
// Data stored in Firestore
{
  // Normalized fields we rely on
  gameId: "2025020406",
  startTime: timestamp,
  status: "FINAL",
  homeTeam: { id, name, score, ... },
  awayTeam: { id, name, score, ... },
  
  // Raw API response for future use
  raw: {
    schedule: { /* entire /schedule response */ },
    boxscore: { /* entire /boxscore response if available */ }
  }
}
```

**Why this approach?**
- ✅ New fields are automatically captured in `raw`
- ✅ No schema migrations needed if API changes
- ✅ Can backfill derived fields later without re-fetching
- ❌ Slightly larger documents (negligible for Firestore)

#### 1.6 **Backfill & Scalability**

**Current Implementation**: Supports any number of days

```bash
npm run ingest:today          # 0 days (today only)
npm run ingest:week           # 7 days
npm run ingest:month          # 30 days
npm run ingest:100            # 100 days
node src/index.js 180         # 180 days (custom)
```

**How it scales**:

```javascript
// dateUtils.js
export function getDateRange(daysToIngest = 0) {
  const dates = [];
  for (let i = daysToIngest; i >= 0; i--) {
    dates.push(moment().subtract(i, 'days').format('YYYY-MM-DD'));
  }
  return dates; // Returns array of YYYY-MM-DD strings
}
```

**Production Deployment: GitHub Actions**

```yaml
# file: .github/workflows/nhl-ingest.yml
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
      # Check out code
      - uses: actions/checkout@v3
      
      # Set up Node
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      # Cache dependencies (speeds up runs)
      - uses: actions/cache@v3
        with:
          path: backend/node_modules
          key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
      
      # Install dependencies
      - name: Install dependencies
        run: |
          cd backend
          npm ci
      
      # Configure Firebase credentials from GitHub secret
      - name: Set up Firebase
        env:
          FIREBASE_KEY: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}
        run: |
          echo "$FIREBASE_KEY" > backend/service-account-key.json
      
      # Run ingestion
      - name: Ingest NHL games
        run: |
          cd backend
          npm run ingest:today
      
      # Send Slack notification on failure
      - name: Notify on failure
        if: failure()
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: 'NHL ingest failed!'
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

**Future Setup**:

1. **Store Firebase credentials in GitHub**
   ```bash
   # Copy your service account key
   cat backend/service-account-key.json
   
   # Go to GitHub repo → Settings → Secrets and variables → Actions
   # Create secret: FIREBASE_SERVICE_ACCOUNT_KEY
   # Paste entire JSON content
   ```

2. **Test the workflow**
   - Go to GitHub → Actions → "Daily NHL Data Ingest"
   - Click "Run workflow" → Select branch → Run
   - Monitor execution in real-time

3. **Schedule automatically**
   - Workflow runs daily at 9:00 AM UTC
   - Adjust cron schedule as needed
   - No additional setup required

**How It Works**:

```
GitHub Actions Scheduler
    ↓ (Every day at 9:00 AM UTC)
Ubuntu Runner (GitHub's infrastructure)
    ↓
1. Check out code
2. Install Node.js
3. Cache dependencies
4. Load Firebase credentials
5. Run: npm run ingest:today
    ↓
GameService ingests latest games
    ↓
Firestore stores/updates games
```

**Decision Rationale**: Chose GitHub Actions because:
1. **Best for open source projects** — free, no account setup
2. **Simple trigger mechanism** — cron is standard and reliable
3. **Integrated with code** — workflow lives in your repository
4. **No external infrastructure** — no servers to maintain
5. **Transparent** — full logs and history in GitHub UI

For this project, GitHub Actions provides everything needed with zero cost and minimal setup.

#### 1.7 **Team Data Ingestion**

**Challenge**: Requirements mentioned team standings but didn't strictly require it.

**Decision**: Implemented as optional enhancement.

```javascript
// backend/src/services/teamService.js
export async function ingestTeamStandings(season = 20242025) {
  const response = await nhlApi.getStandings(season);
  // For each team:
  //   - Extract: name, wins, losses, overtimeLosses, points
  //   - Calculate: win percentage
  //   - Upsert to /teams/{teamId}
}
```

**Why ingest teams separately?**
- ✅ Game documents have team names but not full standings
- ✅ Team screen needs W-L-O record (see Part 3)
- ✅ Separates concerns: games vs. team metadata

---

## Part 2: Flutter Frontend (Games UI)

### Problem Statement
Build a Flutter app that displays NHL games from Firestore in real-time with proper error handling and offline support.

### Approach & Architecture

#### 2.1 **Clean Architecture Layers**

I structured the Flutter app following **clean architecture** principles:

```
Presentation Layer (Pages + Widgets + BLoC)
        ↓
Domain Layer (Entities + Use Cases + Repository Interfaces)
        ↓
Data Layer (Models + Repository Implementations + Data Sources)
        ↓
Firebase Firestore
```

**Why layers?**
- **Testability**: Can mock each layer independently
- **Independence**: Presentation never touches Firestore directly
- **Maintainability**: Changes to data source don't affect UI logic
- **Scalability**: Easy to add new data sources (REST API, local cache, etc.)

#### 2.2 **State Management: BLoC Pattern**

**File**: `app/lib/presentation/bloc/game_bloc.dart`

Chose **BLoC** over alternatives:

| Alternative | Why Not Chosen |
|-------------|----------------|
| **Provider** | Lighter, but less structure for complex logic |
| **Riverpod** | Modern, but more learning curve for team |
| **GetX** | Powerful, but can lead to god objects |
| **BLoC** | ✅ Clear event→state flow, testable, scalable |

**BLoC Flow**:

```dart
// User pulls to refresh
GameListPage → add(LoadGamesEvent()) → GameBloc

// Bloc receives event
GameBloc.on<LoadGamesEvent>((event, emit) {
  emit(GameLoadingState());
  try {
    final games = await getGamesUseCase();
    emit(GamesLoadedState(games));
  } catch (e) {
    emit(GameErrorState(e.toString()));
  }
});

// UI listens and rebuilds
BlocBuilder<GameBloc, GameState>(
  builder: (context, state) {
    if (state is GameLoadingState) return LoadingWidget();
    if (state is GamesLoadedState) return GamesList(state.games);
    if (state is GameErrorState) return ErrorWidget(state.error);
  },
)
```

**Benefits**:
- ✅ Testable: Mock BLoC in unit tests
- ✅ Reusable: Same BLoC used by multiple pages
- ✅ Debuggable: Clear event trace
- ❌ Boilerplate: Requires event + state files

#### 2.3 **Dependency Injection: GetIt**

**File**: `app/lib/di/service_locator.dart`

```dart
void setupServiceLocator() {
  // Datasources
  GetIt.instance.registerSingleton<FirestoreDatasource>(
    FirestoreDatasourceImpl(),
  );
  
  // Repositories
  GetIt.instance.registerSingleton<GameRepository>(
    GameRepositoryImpl(
      datasource: GetIt.instance<FirestoreDatasource>(),
    ),
  );
  
  // Use Cases
  GetIt.instance.registerSingleton<GetGamesUseCase>(
    GetGamesUseCase(GetIt.instance<GameRepository>()),
  );
  
  // BLoCs
  GetIt.instance.registerSingleton<GameBloc>(
    GameBloc(GetIt.instance<GetGamesUseCase>()),
  );
}
```

**Why GetIt?**
- ✅ Simple, doesn't require `context` passing
- ✅ Easy to swap implementations (testing)
- ✅ Lazy-loads dependencies
- ❌ Service locator pattern (less testable than provider injection)

**Alternative**: Provider with `context.read()` — cleaner but more verbose setup

#### 2.4 **Real-Time Data with Firestore Streams**

**File**: `app/lib/data/datasources/firestore_datasource.dart`

```dart
class FirestoreDatasourceImpl implements FirestoreDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<GameEntity>> getGamesStream() {
    return _firestore
        .collection('games')
        .orderBy('startTime', descending: false)
        .snapshots()  // ← Real-time updates
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => GameModel.fromMap(doc.data()).toEntity())
              .toList();
        });
  }
}
```

**How real-time updates work**:

1. **Firestore snapshot listener** detects changes
2. **Stream emits new data** automatically
3. **BLoC listens** and emits new state
4. **UI rebuilds** without user interaction

**Graceful Handling**:
- ✅ User sees live score updates
- ✅ No manual refresh button needed (though we provide one)
- ✅ Handles connection loss gracefully

#### 2.5 **Error Handling & Resilience**

**Strategy**: "Never crash, always show something"

```dart
class GameListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        // State 1: Loading
        if (state is GameLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        
        // State 2: Loaded
        if (state is GamesLoadedState) {
          if (state.games.isEmpty) {
            return Center(child: Text('No games today'));
          }
          return GamesList(state.games);
        }
        
        // State 3: Error
        if (state is GameErrorState) {
          return ErrorWidget(
            error: state.error,
            onRetry: () => _retryLoad(context),
          );
        }
        
        // Fallback (should never reach)
        return SizedBox.shrink();
      },
    );
  }
}
```

**Null Safety**:
```dart
// Always check for null before accessing
final teamName = game.homeTeam?.name ?? 'Unknown Team';
final score = game.homeTeam?.score ?? 0;
```

**Missing Fields**:
```dart
// If a field doesn't exist, show placeholder
Text(game.venue?.name ?? 'N/A')
```

#### 2.6 **Design System Implementation**

Created a **Material 3 design system** with centralized colors, typography, and spacing.

**Files**:
- `app/lib/core/theme/app_colors.dart` — 40+ color constants
- `app/lib/core/theme/app_text_styles.dart` — Typography hierarchy
- `app/lib/core/theme/app_theme.dart` — Light/dark themes
- `app/lib/core/constants/app_constants.dart` — Spacing and sizes

**Benefits**:
- ✅ Consistent UI across all screens
- ✅ Easy theme switching (light/dark)
- ✅ Single source of truth for colors
- ✅ No magic numbers scattered in code

**Example Usage**:
```dart
Container(
  padding: EdgeInsets.all(AppConstants.paddingMedium),
  color: AppColors.primaryColor,
  child: Text(
    'Game Details',
    style: AppTextStyles.headlineLarge,
  ),
)
```

#### 2.7 **Navigation: Auto Route**

**File**: `app/lib/config/routes/app_router.dart`

```dart
@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: GameListPage, initial: true),
    AutoRoute(page: GameDetailPage),
    AutoRoute(page: TeamPage),
  ],
)
class AppRouter extends _$AppRouter {}
```

**Why Auto Route?**
- ✅ Type-safe routing (compile-time checking)
- ✅ Auto-generates route names
- ✅ Handles deep linking
- ❌ Requires code generation (`build_runner`)

**Navigation Example**:
```dart
// Type-safe navigation
context.router.push(
  GameDetailRoute(gameId: game.id),
);

// Pop back
context.router.pop();
```

### Key Screens

#### 2.8 **Game List Screen**

**File**: `app/lib/presentation/pages/game_list_page.dart`

**Features**:
- ✅ Displays today's games sorted by start time
- ✅ Pull-to-refresh for manual updates
- ✅ Real-time updates from Firestore
- ✅ Game cards with home/away scores and status
- ✅ Loading and error states
- ✅ "No games today" message when empty

**UX Decisions**:
1. **Pull-to-refresh**: Even with streams, users expect visible control
2. **Sorted by time**: Natural ordering for game discovery
3. **Game status color-coded**: Live games highlighted in accent color
4. **Tap to details**: Standard mobile UX pattern

#### 2.9 **Game Detail Screen**

**File**: `app/lib/presentation/pages/game_detail_page.dart`

**Displays**:
- ✅ Full game information (date, venue, period, time)
- ✅ Home and away team cards with logos
- ✅ Current score and period breakdown
- ✅ Game status with visual indicator
- ✅ Team statistics (shots, goals by period)
- ✅ Tappable team names to open Team screen

**Technical Highlights**:
- Receives gameId from navigation
- Queries single game from Firestore
- Handles missing/null fields gracefully

#### 2.10 **Team Screen**

**File**: `app/lib/presentation/pages/team_page.dart`

**Displays**:
- ✅ Team name and logo
- ✅ Season record (W-L-OTL)
- ✅ Recent 5 games filtered from games collection
- ✅ Points and games played

**Implementation Detail**:

```dart
// Query games where homeTeam.id == teamId OR awayTeam.id == teamId
Stream<List<GameEntity>> getTeamRecentGames(int teamId) {
  return _firestore
      .collection('games')
      .where('homeTeam.id', isEqualTo: teamId)
      .orderBy('startTime', descending: true)
      .limit(5)
      .snapshots()
      .asyncMap((snapshot) async {
        final homeGames = snapshot.docs.map(...).toList();
        
        final awayGames = await _firestore
            .collection('games')
            .where('awayTeam.id', isEqualTo: teamId)
            .orderBy('startTime', descending: true)
            .limit(5)
            .get();
        
        // Merge and sort
        return (homeGames + awayGames)
            .sorted((a, b) => b.startTime.compareTo(a.startTime))
            .take(5)
            .toList();
      });
}
```

**Design Decision**: Could have stored team games in a subcollection, but chose to query from games collection because:
- ✅ No data duplication
- ✅ Games data is already source of truth
- ✅ Simpler to maintain
- ❌ Slightly more complex query logic

---

## Part 3: Team Screen & Data Model

### Problem Statement
Build a team screen showing season record and recent games using only backend-ingested data.

### Implementation

#### 3.1 **Data Model**

**Games Collection** (`/games/{gameId}`):
```javascript
{
  gameId: "2025020406",
  startTime: Timestamp,
  status: "FINAL" | "LIVE" | "SCHEDULED",
  
  homeTeam: {
    id: number,
    name: string,
    abbrev: string,
    score: number,
    logoUrl: string
  },
  
  awayTeam: {
    id: number,
    name: string,
    abbrev: string,
    score: number,
    logoUrl: string
  },
  
  venue: {
    name: string,
    city: string
  },
  
  season: number,
  updatedAt: Timestamp,
  
  // Raw API response for extensibility
  raw: {
    schedule: {...},
    boxscore: {...}
  }
}
```

**Teams Collection** (`/teams/{teamId}`):
```javascript
{
  id: number,
  name: string,
  abbrev: string,
  season: number,
  
  // Standings
  wins: number,
  losses: number,
  overtimeLosses: number,
  points: number,
  gamesPlayed: number,
  pointsPercentage: number,
  
  // Logo
  logoUrl: string,
  
  // Metadata
  updatedAt: Timestamp
}
```

**Why two collections?**

| Aspect | Single Games Collection | Two Collections |
|--------|------------------------|-----------------|
| **Team Record** | Calculate from games (complex) | Direct lookup ✅ |
| **Team Logo** | In game document | Normalized in team doc ✅ |
| **Scalability** | Games collection grows large | Teams capped at 32 |
| **Query Speed** | 1000s of games to scan | Direct ID lookup |
| **Data Consistency** | Single source of truth | Two sources (carefully managed) |

**Decision**: Two collections with careful synchronization

#### 3.2 **Team Record Calculation**

**Approach**: Backend calculates and stores, frontend reads

```javascript
// backend/src/transformers/teamTransformer.js

export function transformTeamStandings(apiResponse) {
  const standings = {};
  
  // NHL API returns divisions → teams
  for (const division of apiResponse.divisions) {
    for (const team of division.teams) {
      standings[team.id] = {
        id: team.id,
        name: team.name.default,
        abbrev: team.abbrev,
        season: apiResponse.season,
        
        wins: team.gamesPlayed - team.losses - team.overtimeLosses + team.wins,
        losses: team.losses,
        overtimeLosses: team.overtimeLosses,
        points: team.points,
        gamesPlayed: team.gamesPlayed,
        pointsPercentage: team.pointsPercentage,
        
        logoUrl: `https://.../.../team_id=${team.id}.svg`,
        updatedAt: Date.now(),
      };
    }
  }
  
  return standings;
}
```

**Why backend calculates?**
- ✅ Single source of truth
- ✅ Frontend just reads
- ✅ Reduces app logic
- ❌ Two collections to sync

#### 3.3 **Recent Games Query**

**Challenge**: Show a team's last 5 games from games collection

**Solution**:

```dart
// In team_repository.dart
Stream<List<GameEntity>> getTeamRecentGames(int teamId) {
  return FirebaseFirestore.instance
      .collection('games')
      .where(
        Filter.or(
          Filter('homeTeam.id', isEqualTo: teamId),
          Filter('awayTeam.id', isEqualTo: teamId),
        ),
      )
      .orderBy('startTime', descending: true)
      .limit(10)  // Get 10 to be safe, then take 5
      .snapshots()
      .map((snapshot) {
        final games = snapshot.docs
            .map((doc) => GameModel.fromMap(doc.data()).toEntity())
            .toList();
        return games.take(5).toList();
      });
}
```

**Note**: Firestore limitation — complex queries with OR filters can't use indexes efficiently. Workaround: Get slightly more docs, then filter in code.

---

## Key Design Decisions & Tradeoffs

### Decision 1: Idempotent Upsert vs. Duplicate Detection

**Question**: How do we prevent duplicate games?

**Option A: Idempotent Upsert (✅ Chosen)**
```javascript
// document ID is gameId — guaranteed unique
db.collection('games').doc(String(gameId)).set(data, { merge: true });
```
- Pros: Simple, fast, guaranteed unique
- Cons: Requires gameId to be globally unique

**Option B: Duplicate Detection**
```javascript
// Before write, check if gameId exists
const existing = await db.collection('games').doc(gameId).get();
if (!existing.exists) {
  // Create new
}
```
- Pros: More explicit control
- Cons: Extra read on every write, slower

**Decision Rationale**: NHL gameIds are unique across seasons and platforms. Idempotent upsert is the right fit.

---

### Decision 2: Real-Time Streams vs. Manual Refresh

**Question**: Should the app listen for live updates?

**Option A: Real-Time Streams (✅ Chosen)**
```dart
// Firestore listener continuously sends updates
_firestore.collection('games').snapshots();
```
- Pros: Live score updates, modern UX
- Cons: Slight battery/data impact
- Cost: Free (included in Firestore quota)

**Option B: Manual Refresh Only**
```dart
// User taps refresh button
onPressed: () => _bloc.add(RefreshGamesEvent());
```
- Pros: User has control, less data
- Cons: Outdated scores, poor UX

**Decision Rationale**: Real-time is expected for sports scores. Kept manual refresh as fallback.

---

### Decision 3: BLoC vs. Simpler State Management

**Question**: Overkill to use BLoC for this app?

**Option A: BLoC (✅ Chosen)**
```dart
// Event → Bloc → State → UI
add(LoadGamesEvent()) → emit(GameLoadedState(games))
```
- Pros: Testable, scalable, clear flow
- Cons: More boilerplate

**Option B: Provider + ChangeNotifier (Simpler)**
```dart
class GamesNotifier extends ChangeNotifier {
  List<Game> games = [];
  void load() { ... }
}
```
- Pros: Less boilerplate
- Cons: Less testable, harder to reason about

**Option C: Plain setState (Simplest)**
```dart
class GameListPage extends StatefulWidget {
  @override
  State<GameListPage> createState() => _GameListPageState();
}
```
- Pros: Works for simple cases
- Cons: Not scalable, hard to test

**Decision Rationale**: This app will grow (team page, favorites, filters). BLoC provides a foundation for that. Worth the upfront boilerplate.

---

### Decision 4: Team Data: Calculated vs. Pre-aggregated

**Question**: How do we get team season record?

**Option A: Pre-aggregate in Backend (✅ Chosen)**
```
Backend ingests /standings → stores to /teams collection
Frontend reads /teams/{teamId} → gets wins/losses directly
```
- Pros: O(1) lookup, simple frontend
- Cons: Data duplication, sync complexity

**Option B: Calculate in Frontend**
```
Backend ingests /games only
Frontend queries all games where homeTeam.id == teamId
Frontend calculates wins/losses/ot from results
```
- Pros: Single source of truth
- Cons: O(n) query (expensive), complex logic in app

**Decision Rationale**: Sports apps need fast lookups. Pre-aggregation is worth the sync complexity.

---

### Decision 5: Team Logo URLs

**Question**: How do we display team logos?

**Option A: Store URLs in Backend (✅ Chosen)**
```javascript
logoUrl: 'https://static-cdn.nhl.com/nhl.com/builds/site-core/uploads/images/...
```
- Pros: Centralized, consistent
- Cons: Long URLs, potential CDN changes

**Option B: Hard-code Team ID → Logo Mapping**
```dart
const teamLogoMap = {
  1: 'assets/images/avs.png',
  2: 'assets/images/stars.png',
  ...
};
```
- Pros: Always works offline
- Cons: Have to bundle 32 logo assets

**Option C: Use Team ID to Build URL at Runtime**
```dart
String buildTeamLogoUrl(int teamId) {
  return 'https://static-cdn.nhl.com/.../$teamId.svg';
}
```
- Pros: No storage needed
- Cons: Fragile (URL could change)

**Decision Rationale**: Store URLs from API. Reduces app size and keeps logic centralized. Could cache images locally for offline support (future work).

---

## Assumptions & Limitations

### 1. **NHL API Stability**

**Assumption**: `https://api-web.nhle.com/v1/` remains stable and returns consistent structure.

**Reality Check**: Verified against live API ✅

**If API changes**: 
- New fields go to `raw` object automatically
- Breaking changes would need code updates (unavoidable)

---

### 2. **Firestore Structure**

**Assumption**: Firestore collections used as specified:
- `/games/{gameId}`
- `/teams/{teamId}`

**Security Assumptions**:
- Flutter client has read-only access
- Backend service has write access
- Data is publicly readable

**If structure changes**:
- Update repository data source layer
- No changes needed in BLoC or UI

---

### 3. **Team ID Uniqueness**

**Assumption**: NHL team IDs are stable across seasons.

**Reality**: They are (1-32 typically) ✅

**Edge Case**: What if NHL adds teams?
- Team IDs shift
- Old games become "historical" but readable
- New team queries work fine

---

### 4. **Game Time Zones**

**Assumption**: All times stored as UTC timestamps in Firestore.

**Implementation**: 
```javascript
// backend
startTime: new Date(game.startTime)  // Converts to UTC
```

```dart
// frontend
Text(DateFormat('HH:mm').format(game.startTime.toLocal()))
// Displays in user's local timezone
```

---

### 5. **Real-Time Listeners Cost**

**Assumption**: Acceptable to have active Firestore listeners

**Cost Analysis**:
- Games collection: ~1 listener (game list page)
- Teams collection: 1 listener per team page opened
- Firestore pricing: $0.06 per 100k read operations

**Typical Usage**:
- User opens app → 1 listener
- User browses games → ~3-5 listeners total
- Cost per day: < $0.01

**If too expensive**: Switch to polling or REST API.

---

### 6. **No Authentication Required**

**Current Model**: Read-only public data, no user accounts.

**Tradeoff**:
- ✅ Simple, no login flow
- ❌ No favorites, no personalization

**Future Enhancement**: Add Firebase Authentication for user features.

---

### 7. **Firestore Indexing**

**Assumption**: Default Firestore indexes sufficient for queries.

**Current Queries**:
- `games` ordered by `startTime`
- `teams` direct ID lookup
- `games` filtered by `homeTeam.id` OR `awayTeam.id`

**Issue**: OR filters need special compound indexes.

**Solution**: 
- Firestore auto-suggests indexes
- Frontend code handles merging results

---

## What I Would Improve Next (Priority Order)

### Priority 1: Production Deployment
- [ ] **Set up Cloud Scheduler** for daily ingest at 9 AM UTC
- [ ] **Implement Cloud Functions** wrapper around Node service
- [ ] **Add monitoring** (error tracking, latency alerts)
- [ ] **Version the API** (track schema changes)

### Priority 2: User Features
- [ ] **User authentication** (Firebase Auth)
- [ ] **Favorite teams** (store in user profile)
- [ ] **Notifications** (Firebase Cloud Messaging)
- [ ] **Watch list** (favorite teams' upcoming games)

### Priority 3: Data Richness
- [ ] **Player statistics** (top scorers, goalies, etc.)
- [ ] **Game highlights** (links to NHL.com video)
- [ ] **Advanced stats** (expected goals, possession %)
- [ ] **Historical data** (season records, playoff history)

### Priority 4: App Polish
- [ ] **Offline caching** (Hive + background sync)
- [ ] **Dark theme refinement** (more color variations)
- [ ] **Animation polish** (micro-interactions)
- [ ] **Accessibility** (WCAG compliance, screen reader support)

### Priority 5: Testing
- [ ] **Unit tests** for BLoCs (Firebase mocking)
- [ ] **Widget tests** for pages
- [ ] **Integration tests** with Firestore emulator
- [ ] **E2E tests** (Patrol or integration_test)

### Priority 6: Performance
- [ ] **Pagination** for large game lists
- [ ] **Image caching** for logos
- [ ] **Database indexing** optimization
- [ ] **Query batching** for multiple teams

### Priority 7: Backend Enhancements
- [ ] **Team history tracking** (daily snapshots)
- [ ] **Game replay URLs** (scrape from NHL.com)
- [ ] **Injury reports** (source from external API)
- [ ] **Trade alerts** (integrate with news API)

---

## Where AI Was Used vs. Human Intelligence

### ✅ AI Usage (Appropriate)
1. **Boilerplate Code Generation**
   - Generated BLoC event/state classes (repetitive structure)
   - Created model serialization (fromMap/toMap)
   - Scaffold for services and repositories

2. **Documentation & Examples**
   - Generated README sections (structured reference docs)
   - Example code snippets (demonstrating patterns)
   - Error message formatting

### ❌ NOT Using AI (Human Decision-Making)
1. **Architecture Selection**
   - Chose clean architecture (considered alternatives)
   - Picked BLoC over simpler options
   - Designed two-collection data model

2. **Tradeoff Analysis**
   - Idempotent upsert vs. duplicate detection
   - Real-time streams vs. polling
   - Pre-aggregated data vs. calculated

3. **Error Handling Strategy**
   - Decided on "log and continue" resilience
   - Null-safety strategy
   - Graceful degradation approach

4. **Problem-Solving**
   - Identified Firestore OR query limitation
   - Designed workaround (fetch + filter)
   - Extended beyond base requirements (teams screen)

5. **Reasoning & Trade-offs**
   - Documented assumptions
   - Explained simplifications
   - Outlined improvements for production

---

## How I Approached This Challenge

### Phase 1: Requirements Analysis 
- Read requirements carefully
- Identified three distinct parts
- Noted optional vs. required features
- Checked feasibility of each requirement

### Phase 2: Technology Selection 
- Drew out architecture diagrams
- Selected tech stack (Node, Flutter, Firebase)
- Evaluated trade-offs for each choice
- Confirmed tools are production-ready

### Phase 3: Backend Implementation 
- Built modular service architecture
- Implemented idempotent ingestion
- Added graceful error handling
- Extended with team data ingestion
- Created comprehensive README

### Phase 4: Frontend Implementation 
- Set up Flutter project structure (clean architecture)
- Implemented BLoC state management
- Built game list, detail, and team screens
- Added design system (colors, typography)
- Tested with real Firestore data

### Phase 5: Integration & Polish 
- Verified backend-frontend data flow
- Tested error scenarios
- Added design system consistency
- Updated documentation

### Phase 6: Reflection & Documentation 
- Wrote this implementation report
- Documented decisions and trade-offs
- Listed improvements and limitations
- Prepared for walkthrough
  
---

## Code Quality Principles Applied

### 1. **Separation of Concerns**
- Services handle business logic
- Repositories abstract data sources
- BLoCs manage state
- Widgets display UI

### 2. **DRY (Don't Repeat Yourself)**
- Shared theme system (no color duplication)
- Reusable widget components
- Base classes for common patterns

### 3. **SOLID Principles**
- **Single Responsibility**: GameService only handles games
- **Open/Closed**: Services extensible via new methods
- **Liskov Substitution**: Repositories implement interfaces
- **Interface Segregation**: Small focused interfaces
- **Dependency Inversion**: BLoCs depend on abstractions

### 4. **Error Handling**
- Custom error classes for type-safety
- Try-catch blocks at appropriate layers
- User-friendly error messages
- Graceful degradation

### 5. **Documentation**
- Clear variable names
- Comments for complex logic
- README with setup instructions
- Example code snippets

---

## Testing Strategy (Not Yet Implemented)

### Unit Tests
```dart
// test/presentation/bloc/game_bloc_test.dart
void main() {
  group('GameBloc', () {
    test('emits [GameLoadingState, GamesLoadedState] when games are loaded', () {
      // Arrange
      final mockUseCase = MockGetGamesUseCase();
      when(mockUseCase()).thenAnswer((_) async => [game1, game2]);
      
      final bloc = GameBloc(mockUseCase);
      
      // Act
      bloc.add(LoadGamesEvent());
      
      // Assert
      expectLater(
        bloc.stream,
        emitsInOrder([
          GameLoadingState(),
          GamesLoadedState([game1, game2]),
        ]),
      );
    });
  });
}
```

### Widget Tests
```dart
// test/presentation/pages/game_list_page_test.dart
void main() {
  testWidgets('displays loading indicator while loading', (WidgetTester tester) {
    // Arrange
    final mockBloc = MockGameBloc();
    when(mockBloc.state).thenReturn(GameLoadingState());
    
    // Act
    await tester.pumpWidget(
      BlocProvider.value(value: mockBloc, child: GameListPage()),
    );
    
    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

### Integration Tests
```javascript
// backend/test/gameService.integration.test.js
describe('GameService Integration', () => {
  it('should ingest games idempotently', async () => {
    // First run
    await gameService.ingestGames(testDate);
    let games = await firestore.collection('games').get();
    expect(games.size).toBe(expectedCount);
    
    // Second run
    await gameService.ingestGames(testDate);
    games = await firestore.collection('games').get();
    
    // Should still be same count (idempotent)
    expect(games.size).toBe(expectedCount);
  });
});
```

---

## Conclusion

This implementation demonstrates:

1. ✅ **Full-stack capability**: Backend ingestion + Frontend display + Data persistence
2. ✅ **Thoughtful architecture**: Clean layers, proper separation, extensible design
3. ✅ **Production readiness**: Error handling, security considerations, logging
4. ✅ **User experience**: Real-time updates, graceful degradation, intuitive UI
5. ✅ **Documentation**: README, code comments, decision rationale
6. ✅ **Problem-solving**: Trade-off analysis, workarounds, reflective improvement

The code balances **AI assistance** (boilerplate) with **human intelligence** (architecture, decisions, reasoning). The focus is on building something that works well now and scales to production later.

---

## Quick Start Reference

### Backend
```bash
cd backend
npm install
export FIREBASE_PROJECT_ID=nhl-project-75e9c
npm run ingest:today
```

### Frontend
```bash
cd app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutterfire configure --project=nhl-project-75e9c
flutter run -d <YOUR DEVICE ID>
```

### Architecture
- Backend: Node.js → NHL API → Firestore
- Frontend: Flutter → Firestore → BLoC → UI
- Data Model: `games/` and `teams/` collections

### Key Files to Review
- Backend: `backend/src/services/gameService.js` (orchestration)
- Frontend: `app/lib/presentation/bloc/game_bloc.dart` (state management)
- Backend: `backend/README.md` (data model and setup)
- Frontend: `app/README.md` (architecture and usage)

#Games Collection:
 - ✅ Frontend: Read-only (anyone can view)
 - ✅ Backend: Write-only (service account can update)

#Teams Collection:
 - ✅ Frontend: Read-only (anyone can view)
 - ✅ Backend: Write-only (service account can update)



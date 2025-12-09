# NHL Score Tracker - Flutter Frontend

A modern Flutter mobile application for tracking NHL games, team standings, and comprehensive game statistics in real-time. Built with Flutter and Firebase, featuring a clean architecture design pattern.

## Overview

NHL Score Tracker delivers a polished mobile experience for hockey fans:
- **Live Game Updates**: Real-time game scores and status updates
- **Detailed Game Information**: Comprehensive game stats, player performances, and venue details
- **Team Standings**: Current season standings with win-loss-overtime records
- **Beautiful UI/UX**: Material 3 design system with light and dark theme support
- **Offline Support**: Cached game data available when internet is unavailable
- **Fast Performance**: Optimized state management with BLoC pattern

## Project Structure

```
app/
├── lib/
│   ├── main.dart                    # App initialization and setup
│   ├── firebase_options.dart        # Firebase configuration
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart   # UI spacing, padding, icon sizes
│   │   │   └── ...
│   │   ├── theme/
│   │   │   ├── app_colors.dart      # 40+ color constants
│   │   │   ├── app_text_styles.dart # Typography system
│   │   │   ├── app_theme.dart       # Material3 light/dark themes
│   │   │   └── ...
│   │   └── ...
│   │
│   ├── config/
│   │   ├── routes/
│   │   │   ├── app_router.dart      # Auto route navigation setup
│   │   │   └── routes.dart          # Route definitions
│   │   └── ...
│   │
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── firestore_datasource.dart # Firestore queries
│   │   │   └── ...
│   │   ├── models/
│   │   │   ├── game_model.dart      # Game data model
│   │   │   ├── team_model.dart      # Team data model
│   │   │   └── ...
│   │   └── repositories/
│   │       ├── game_repository.dart # Game data access layer
│   │       ├── team_repository.dart # Team data access layer
│   │       └── ...
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── game_entity.dart     # Game business logic entity
│   │   │   ├── team_entity.dart     # Team business logic entity
│   │   │   └── ...
│   │   ├── repositories/
│   │   │   ├── game_repository.dart # Repository interface
│   │   │   └── ...
│   │   └── usecases/
│   │       ├── get_games_usecase.dart
│   │       └── ...
│   │
│   ├── presentation/
│   │   ├── bloc/
│   │   │   ├── game_bloc.dart       # Game state management
│   │   │   ├── game_event.dart      # Game events
│   │   │   ├── game_state.dart      # Game states
│   │   │   ├── team_bloc.dart       # Team state management
│   │   │   └── ...
│   │   │
│   │   ├── pages/
│   │   │   ├── game_list_page.dart  # Today's games display
│   │   │   ├── game_detail_page.dart # Game statistics & details
│   │   │   ├── team_page.dart       # Team standings view
│   │   │   └── ...
│   │   │
│   │   └── widgets/
│   │       ├── components/
│   │       │   ├── game_card.dart       # Game list card
│   │       │   ├── game_header.dart     # Game title/date header
│   │       │   ├── game_status_info.dart # Score display
│   │       │   ├── period_info.dart     # Period/time indicator
│   │       │   ├── team_stats.dart      # Team statistics
│   │       │   ├── stat_row.dart        # Statistics row component
│   │       │   └── ...
│   │       └── ...
│   │
│   ├── di/
│   │   └── service_locator.dart     # GetIt dependency injection setup
│   │
│   ├── converters/
│   │   ├── timestamp_converter.dart # Firebase timestamp handling
│   │   └── ...
│   │
│   └── config/
│       └── firebase_options.dart    # Auto-generated Firebase config
│
├── assets/
│   ├── fonts/                       # Custom fonts
│   ├── icons/                       # App icons
│   └── images/                      # Team logos, backgrounds
│
├── android/                         # Android native code
├── ios/                            # iOS native code
├── web/                            # Web platform support
├── linux/                          # Linux platform support
├── macos/                          # macOS platform support
├── windows/                        # Windows platform support
│
├── pubspec.yaml                    # Dependencies and configuration
├── analysis_options.yaml           # Linting rules
└── README.md                       # This file
```

## Features

### Pages

#### 🎮 Game List Page (`game_list_page.dart`)
- Display today's NHL games
- Pull-to-refresh functionality
- Game cards with home/away teams, scores, and status
- Real-time updates from Firestore
- Loading and error states

#### 📊 Game Detail Page (`game_detail_page.dart`)
- Comprehensive game statistics
- Three-period breakdown with goals and shots
- Team performance metrics
- Venue and date/time information
- Live score updates during games

#### 🏆 Team Page (`team_page.dart`)
- Current season team standings
- Wins, losses, overtime losses, and points
- Recent games for selected team
- Interactive team selection
- Sortable standings table

### Design System

#### App Colors (`app_colors.dart`)
- **Primary Colors**: Main brand colors for action buttons and highlights
- **Secondary Colors**: Supporting colors for secondary actions
- **Status Colors**: Game status indicators (scheduled, live, final)
- **Team Colors**: 32 NHL team-specific color schemes
- **Neutral Colors**: Backgrounds, borders, dividers

#### Text Styles (`app_text_styles.dart`)
- **Display Styles**: Large, Medium (for headings)
- **Headline Styles**: Large through Small (for section titles)
- **Title Styles**: Large through Small (for subsections)
- **Body Styles**: Large, Medium, Small (for body text)
- **Label Styles**: Large, Medium, Small (for buttons and labels)

#### Theme (`app_theme.dart`)
- **Light Theme**: Material3 light mode with custom color scheme
- **Dark Theme**: Material3 dark mode optimized for night viewing
- **Component Theming**: Custom styles for buttons, cards, dialogs, and more
- **Automatic Theme Switching**: System theme preference support

#### UI Constants (`app_constants.dart`)
- Spacing values (4pt, 8pt, 16pt, 24pt, 32pt)
- Padding values for different layouts
- Icon sizes (small, medium, large)
- Border radius values
- Animation durations

## Setup & Installation

### Prerequisites
- Flutter 3.x SDK installed ([install.flutter.dev](https://flutter.dev/docs/get-started/install))
- Dart 3.x (included with Flutter)
- iOS development tools (Xcode) for iOS development
- Android Studio or Android SDK for Android development
- Firebase project set up

### Installation Steps

1. **Clone the Repository**
   ```bash
   cd app
   ```

2. **Get Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   flutterfire configure --project=nhl-project-75e9c
   ```
   This will:
   - Create/update `firebase_options.dart`
   - Configure Android Firebase setup
   - Configure iOS Firebase setup

4. **Build Runners (if needed)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the App**
   ```bash
   flutter run
   ```

## Available Commands

### Development
```bash
# Run app on default device/emulator
flutter run

# Run with specific device
flutter run -d <device_id>

# Run in release mode
flutter run --release

# Run with verbose logging
flutter run -v

# Clean build artifacts
flutter clean
```

### Linting & Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format code
dart format lib/ test/

# Get all dependencies
flutter pub get

# Update dependencies
flutter pub upgrade
```

### Building for Release
```bash
# Build APK for Android
flutter build apk

# Build iOS app
flutter build ios

# Build web
flutter build web
```

## Architecture

The app follows **Clean Architecture** with three distinct layers:

### Presentation Layer
- **Pages**: Full-screen widgets that represent routes/screens
- **Widgets**: Reusable UI components
- **BLoC**: State management using the BLoC pattern
  - Events: User actions or external triggers
  - States: UI states (loading, success, error)
  - Logic: Business logic separation from UI

### Domain Layer
- **Entities**: Core business objects (game, team, player)
- **Repositories**: Abstract interfaces for data operations
- **Use Cases**: Business logic operations (get games, get standings)

### Data Layer
- **DataSources**: Concrete implementations (Firestore, local cache)
- **Models**: Data transfer objects with serialization
- **Repositories**: Concrete implementations of domain repositories

### Benefits of This Architecture
- ✅ **Testability**: Each layer can be tested independently
- ✅ **Maintainability**: Clear separation of concerns
- ✅ **Scalability**: Easy to add features without affecting existing code
- ✅ **Reusability**: Entities and repositories can be used across pages

## State Management (BLoC Pattern)

### Example: Game BLoC Flow

```
User Action (Pull to Refresh)
    ↓
GameBloc.add(LoadGamesEvent())
    ↓
BLoC receives event → Calls use case
    ↓
Repository fetches data from Firestore
    ↓
BLoC.emit(GameLoadedState(games))
    ↓
UI listens to state and rebuilds
    ↓
Display updated games
```

### BLoC Files
```
presentation/bloc/
├── game_bloc.dart      # Main state management logic
├── game_event.dart     # Events that trigger changes
├── game_state.dart     # States the UI can be in
└── team_bloc.dart      # Team standings state management
```

## Firebase Integration

### Firestore Collections Used

**Games Collection** (`games/`)
```
/games/{gameId}
  - homeTeam: {id, name, score, logo}
  - awayTeam: {id, name, score, logo}
  - status: "FINAL" | "LIVE" | "SCHEDULED"
  - startTime: timestamp
  - season: number
  - ... (see backend README for full schema)
```

**Teams Collection** (`teams/`)
```
/teams/{teamId}
  - name: string
  - abbrev: string
  - wins: number
  - losses: number
  - overtimeLosses: number
  - points: number
  - logoUrl: string
  - ... (see backend README for full schema)
```

### Real-time Listeners
- GameBloc sets up Firestore listeners for games
- TeamBloc sets up listeners for team standings
- Changes automatically trigger UI updates via state changes

## Dependency Injection (GetIt)

The app uses **GetIt** for dependency injection:

```dart
// In service_locator.dart
GetIt.instance.registerSingleton<GameRepository>(
  GameRepositoryImpl(datasource: firestoreDatasource),
);

// In pages
final gameRepository = GetIt.instance<GameRepository>();
```

Benefits:
- 🔌 Easy to swap implementations (mock for testing)
- 🎯 Centralized dependency configuration
- ♻️ Singleton pattern for single instance per app session

## Navigation (Auto Route)

Routes are defined in `app_router.dart`:

```dart
@singleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends $AppRouter {
@override
  List<AutoRoute> get routes => [
        AutoRoute(page: GameListRoute.page, path: '/', initial: true),
        AutoRoute(page: GameDetailRoute.page, path: '/games/:gameId'),
        AutoRoute(page: TeamRoute.page, path: '/teams/:teamId'),
      ];
} 
```

Navigation:
```dart
context.router.push(GameDetailRoute(gameId: gameId));
context.read<GamesBloc>().add(GamesCardTappedEvent(gameId: game.id, game: game));
```

Non-consitent navigation since I was running out of time I could come up only with the strange solution of resolution
so I have decided to leave - 'context.router.push(GameDetailRoute(gameId: gameId));' as it is right now. 

## Styling Guidelines

### Using App Colors
```dart
import 'package:app/core/theme/app_colors.dart';

Container(
  color: AppColors.primaryColor,
  child: Text('Game Over', style: TextStyle(
    color: AppColors.onPrimary,
  )),
)
```

### Using App Text Styles
```dart
import 'package:app/core/theme/app_text_styles.dart';

Text(
  'Team Standings',
  style: AppTextStyles.headlineLarge,
)
```

### Using App Constants
```dart
import 'package:app/core/constants/app_constants.dart';

Padding(
  padding: EdgeInsets.all(AppConstants.paddingMedium),
  child: child,
)
```

## Theme Switching

The app automatically respects system theme preference:

```dart
// In theme setup
ThemeData.light()  // Light theme
ThemeData.dark()   // Dark theme

// User can override in system settings
// App automatically adapts on startup
```

## Troubleshooting

### App Won't Start
**Solution**:
- Run `flutter pub get` to install dependencies
- Run `flutter clean` to clear build cache
- Run `flutterfire configure` to update Firebase setup

### Firestore Data Not Loading
**Solution**:
- Check Firebase security rules allow reads
- Verify backend is running and pushing data
- Check Firebase Console Firestore collections exist
- Check network connectivity

### Build Errors
**Solution**:
```bash
flutter pub get
flutter pub upgrade
flutter clean
flutter run
```

### Hot Reload Not Working
**Solution**:
- Stop the app and run `flutter run` again
- Check console for compilation errors
- Some changes (pubspec.yaml) require full restart

## Performance Tips

1. **Lazy Loading**: Use `lazy: true` in BLoC builders
2. **Const Constructors**: Make widgets const where possible
3. **Image Caching**: Team logos are cached locally
4. **Firestore Queries**: Use indexes for complex queries
5. **Pagination**: Load games in batches rather than all at once

## Known Limitations & Future Work

### Current Limitations
- [ ] No offline mode (future: implement Hive caching)
- [ ] Single game source (could add multiple data sources)
- [ ] No user authentication (future: add login/favorites)
- [ ] No push notifications for game updates

### Future Enhancements
- [ ] User authentication and accounts
- [ ] Favorite teams and games
- [ ] Push notifications for favorite team games
- [ ] Player statistics and profiles
- [ ] Game highlights and news integration
- [ ] Advanced filtering and search
- [ ] Multi-language support (i18n)
- [ ] Comprehensive test suite
- [ ] Widget tests for components
- [ ] Integration tests for BLoCs

## Code Style & Conventions

### Naming
- **Files**: `snake_case` (e.g., `game_list_page.dart`)
- **Classes**: `PascalCase` (e.g., `GameListPage`)
- **Variables**: `camelCase` (e.g., `gameList`)
- **Constants**: `camelCase` (e.g., `maxGames = 50`)

### Documentation
```dart
/// Brief description of what this does.
/// 
/// More detailed explanation if needed.
/// 
/// Example:
/// ```dart
/// MyWidget(param: value);
/// ```
```

### Formatting
- Use `dart format` to maintain consistent style
- Max line length: 80 characters
- Indentation: 2 spaces

## Contributing

1. Create a feature branch from `master`
2. Make changes following code style guidelines
3. Test thoroughly before submitting
4. Ensure `flutter analyze` passes
5. Update documentation as needed




- [Material 3 Design](https://m3.material.io/)


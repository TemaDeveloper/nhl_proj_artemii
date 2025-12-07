part of 'games_bloc.dart';

/// Base class for all Games states.
sealed class GamesState extends Equatable {
  const GamesState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is fetched.
final class GamesInitial extends GamesState {
  const GamesInitial();
}

/// Loading state when fetching games for the first time.
final class GamesLoading extends GamesState {
  const GamesLoading();
}

/// State when games are successfully loaded.
final class GamesLoaded extends GamesState {
  final List<Game> games;

  const GamesLoaded({required this.games});

  @override
  List<Object?> get props => [games];
}

/// State when refreshing games (shows current data while loading new).
final class GamesRefreshing extends GamesState {
  final List<Game> games;

  const GamesRefreshing({required this.games});

  @override
  List<Object?> get props => [games];
}

/// Error state with descriptive message.
final class GamesError extends GamesState {
  final String message;

  const GamesError({required this.message});

  @override
  List<Object?> get props => [message];
}
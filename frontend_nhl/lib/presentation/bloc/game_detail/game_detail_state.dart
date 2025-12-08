part of 'game_detail_bloc.dart';

/// Base class for all GameDetail states.
sealed class GameDetailState extends Equatable {
  const GameDetailState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is fetched.
final class GameDetailInitial extends GameDetailState {
  const GameDetailInitial();
}

/// Loading state when fetching game details.
final class GameDetailLoading extends GameDetailState {
  const GameDetailLoading();
}

/// State when game details are successfully loaded.
final class GameDetailLoaded extends GameDetailState {
  final Game game;

  const GameDetailLoaded({required this.game});

  @override
  List<Object?> get props => [game];
}

/// State when refreshing game details (shows current data while loading).
final class GameDetailRefreshing extends GameDetailState {
  final Game game;

  const GameDetailRefreshing({required this.game});

  @override
  List<Object?> get props => [game];
}

/// Error state with descriptive message.
final class GameDetailError extends GameDetailState {
  final String message;

  const GameDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
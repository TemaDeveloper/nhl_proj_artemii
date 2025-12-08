part of 'game_detail_bloc.dart';


sealed class GameDetailState extends Equatable {
  // 🚨 UPDATED: Added navigation property
  final TeamNavigation? doNavigation;
  const GameDetailState({this.doNavigation}); 

  @override
  List<Object?> get props => [doNavigation]; // Include in props
}

/// Initial state before any data is fetched.
final class GameDetailInitial extends GameDetailState {
  const GameDetailInitial({super.doNavigation});
}

/// Loading state when fetching game details.
final class GameDetailLoading extends GameDetailState {
  const GameDetailLoading({super.doNavigation});
}

/// State when game details are successfully loaded.
final class GameDetailLoaded extends GameDetailState {
  final Game game;

  const GameDetailLoaded({required this.game, super.doNavigation});

  GameDetailLoaded copyWith({
    Game? game,
    TeamNavigation? doNavigation,
  }) {
    return GameDetailLoaded(
      game: game ?? this.game,
      doNavigation: doNavigation,
    );
  }

  @override
  List<Object?> get props => [game, doNavigation];
}

/// State when refreshing game details (shows current data while loading).
final class GameDetailRefreshing extends GameDetailState {
  final Game game;

  const GameDetailRefreshing({required this.game, super.doNavigation});

  GameDetailRefreshing copyWith({
    Game? game,
    TeamNavigation? doNavigation,
  }) {
    return GameDetailRefreshing(
      game: game ?? this.game,
      doNavigation: doNavigation,
    );
  }

  @override
  List<Object?> get props => [game, doNavigation];
}

/// Error state with descriptive message.
final class GameDetailError extends GameDetailState {
  final String message;

  const GameDetailError({required this.message, super.doNavigation});

  @override
  List<Object?> get props => [message, doNavigation];
}
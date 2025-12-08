part of 'games_bloc.dart';

sealed class GamesState extends Equatable {
  final GameNavigation? doNavigation;
  const GamesState({this.doNavigation});

  @override
  List<Object?> get props => [doNavigation];
}

final class GamesInitial extends GamesState {
  const GamesInitial({super.doNavigation});

  @override
  List<Object?> get props => [doNavigation];
}

final class GamesLoading extends GamesState {
  const GamesLoading({super.doNavigation});

  @override
  List<Object?> get props => [doNavigation];
}

final class GamesLoaded extends GamesState {
  final List<Game> games;

  const GamesLoaded({required this.games, super.doNavigation});

  GamesLoaded copyWith({
    List<Game>? games,
    GameNavigation? doNavigation,
  }) {
    return GamesLoaded(
      games: games ?? this.games,
      doNavigation: doNavigation,
    );
  }

  @override
  List<Object?> get props => [games, doNavigation];
}

final class GamesRefreshing extends GamesState {
  final List<Game> games;

  const GamesRefreshing({required this.games, super.doNavigation});

  GamesRefreshing copyWith({
    List<Game>? games,
    GameNavigation? doNavigation,
  }) {
    return GamesRefreshing(
      games: games ?? this.games,
      doNavigation: doNavigation,
    );
  }

  @override
  List<Object?> get props => [games, doNavigation];
}

final class GamesError extends GamesState {
  final String message;

  const GamesError({required this.message, super.doNavigation});

  @override
  List<Object?> get props => [message, doNavigation];
}
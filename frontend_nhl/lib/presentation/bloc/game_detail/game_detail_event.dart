part of 'game_detail_bloc.dart';

/// Base class for all GameDetail events.
sealed class GameDetailEvent extends Equatable {
  const GameDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch game details by ID.
final class FetchGameDetailEvent extends GameDetailEvent {
  final String gameId;

  const FetchGameDetailEvent({required this.gameId});

  @override
  List<Object?> get props => [gameId];
}

/// Event to refresh game details.
final class RefreshGameDetailEvent extends GameDetailEvent {
  final String gameId;

  const RefreshGameDetailEvent({required this.gameId});

  @override
  List<Object?> get props => [gameId];
}
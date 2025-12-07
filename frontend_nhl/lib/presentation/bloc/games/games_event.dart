part of 'games_bloc.dart';

abstract class GamesEvent extends Equatable {
  const GamesEvent();

  @override
  List<Object> get props => [];
}

class FetchTodayGamesEvent extends GamesEvent {
  const FetchTodayGamesEvent();
}

final class RefreshGamesEvent extends GamesEvent {
  const RefreshGamesEvent();
}
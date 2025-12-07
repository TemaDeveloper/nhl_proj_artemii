import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend_nhl/core/utils/logger.dart';
import 'package:frontend_nhl/domain/entities/game.dart';
import 'package:frontend_nhl/domain/usecases/get_today_games_usecase.dart';

part 'games_state.dart';
part 'games_event.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final GetTodayGamesUseCase _getTodayGamesUseCase;
  StreamSubscription<List<Game>>? _gamesSubscription;

  GamesBloc(this._getTodayGamesUseCase) : super(const GamesInitial()) {
    on<FetchTodayGamesEvent>(_onFetchTodayGames);
    on<RefreshGamesEvent>(_onRefreshGames);
  }

  Future<void> _onFetchTodayGames(
    FetchTodayGamesEvent event,
    Emitter<GamesState> emit,
  ) async {
    AppLogger.info('Fetching today\'s games', tag: 'GamesBloc');
    emit(const GamesLoading());

    await _gamesSubscription?.cancel();

    await emit.forEach(
      _getTodayGamesUseCase.execute(),
      onData: (games) {
        AppLogger.success('Loaded ${games.length} games', tag: 'GamesBloc');
        return GamesLoaded(games: games);
      },
      onError: (error, stackTrace) {
        AppLogger.error(
          'Failed to load games',
          tag: 'GamesBloc',
          error: error,
          stackTrace: stackTrace,
        );
        return GamesError(message: 'Failed to load games: ${error.toString()}');
      },
    );
  }

  Future<void> _onRefreshGames(
    RefreshGamesEvent event,
    Emitter<GamesState> emit,
  ) async {
    AppLogger.info('Refreshing games', tag: 'GamesBloc');
    
    // Keep current state while refreshing
    if (state is GamesLoaded) {
      final currentGames = (state as GamesLoaded).games;
      emit(GamesRefreshing(games: currentGames));
    }

    // Re-fetch games
    add(const FetchTodayGamesEvent());
  }

  @override
  Future<void> close() {
    AppLogger.debug('Closing GamesBloc', tag: 'GamesBloc');
    _gamesSubscription?.cancel();
    return super.close();
  }
}
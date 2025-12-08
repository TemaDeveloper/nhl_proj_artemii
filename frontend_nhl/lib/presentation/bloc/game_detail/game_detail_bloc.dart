import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend_nhl/core/utils/logger.dart';
import 'package:frontend_nhl/domain/entities/game.dart';
import 'package:frontend_nhl/domain/usecases/get_game_detail_usecase.dart';

part 'game_detail_event.dart';
part 'game_detail_state.dart';

class GameDetailBloc extends Bloc<GameDetailEvent, GameDetailState> {
  final GetGameDetailUseCase _getGameDetailUseCase;
  StreamSubscription<Game>? _gameSubscription;

  GameDetailBloc(this._getGameDetailUseCase) : super(const GameDetailInitial()) {
    on<FetchGameDetailEvent>(_onFetchGameDetail);
    on<RefreshGameDetailEvent>(_onRefreshGameDetail);
  }

  Future<void> _onFetchGameDetail(
    FetchGameDetailEvent event,
    Emitter<GameDetailState> emit,
  ) async {
    AppLogger.info('Fetching game detail: ${event.gameId}', tag: 'GameDetailBloc');
    emit(const GameDetailLoading());

    await _gameSubscription?.cancel();

    try {
      await emit.forEach(
        _getGameDetailUseCase.execute(event.gameId),
        onData: (game) {
          AppLogger.success('Game detail loaded: ${game.id}', tag: 'GameDetailBloc');
          return GameDetailLoaded(game: game);
        },
        onError: (error, stackTrace) {
          AppLogger.error(
            'Failed to load game detail',
            tag: 'GameDetailBloc',
            error: error,
            stackTrace: stackTrace,
          );
          
          if (error is GameNotFoundException) {
            return GameDetailError(message: error.message);
          }
          
          return GameDetailError(
            message: 'Failed to load game details: ${error.toString()}',
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in game detail fetch',
        tag: 'GameDetailBloc',
        error: e,
        stackTrace: stackTrace,
      );
      emit(GameDetailError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> _onRefreshGameDetail(
    RefreshGameDetailEvent event,
    Emitter<GameDetailState> emit,
  ) async {
    AppLogger.info('Refreshing game detail: ${event.gameId}', tag: 'GameDetailBloc');
    
    // Keep current state while refreshing
    if (state is GameDetailLoaded) {
      final currentGame = (state as GameDetailLoaded).game;
      emit(GameDetailRefreshing(game: currentGame));
    }

    // Re-fetch game
    add(FetchGameDetailEvent(gameId: event.gameId));
  }

  @override
  Future<void> close() {
    AppLogger.debug('Closing GameDetailBloc', tag: 'GameDetailBloc');
    _gameSubscription?.cancel();
    return super.close();
  }
}
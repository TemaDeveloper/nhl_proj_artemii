import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend_nhl/domain/usecases/get_team_usecase.dart';
import 'package:frontend_nhl/domain/usecases/get_team_games_usecase.dart';
import 'package:frontend_nhl/core/utils/logger.dart';
import 'package:frontend_nhl/domain/entities/team.dart';
import 'package:frontend_nhl/domain/entities/game.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final GetTeamDetailsUseCase _getTeamDetailsUseCase;
  final GetTeamGamesUseCase _getTeamGamesUseCase;
  StreamSubscription<List<Game>>? _gamesSubscription;

  TeamBloc(this._getTeamDetailsUseCase, this._getTeamGamesUseCase)
      : super(const TeamInitial()) {
    on<FetchTeamDetailsEvent>(_onFetchTeamDetails);
  }

  Future<void> _onFetchTeamDetails(
    FetchTeamDetailsEvent event,
    Emitter<TeamState> emit,
  ) async {
    AppLogger.info('Fetching team details for ${event.teamId}', tag: 'TeamBloc');
    emit(const TeamLoading());

    try {
      final team = await _getTeamDetailsUseCase.execute(event.teamId);
      
      // Fetch games for the team
      await _gamesSubscription?.cancel();
      
      await emit.forEach(
        _getTeamGamesUseCase.execute(event.teamId),
        onData: (games) {
          AppLogger.success(
            'Successfully loaded team: ${team.id} with ${games.length} games',
            tag: 'TeamBloc',
          );
          return TeamLoaded(team: team, games: games);
        },
        onError: (error, stackTrace) {
          AppLogger.error(
            'Failed to load team games',
            tag: 'TeamBloc',
            error: error,
            stackTrace: stackTrace,
          );
          // Still load the team even if games fail
          return TeamLoaded(team: team, games: []);
        },
      );
    } catch (e, st) {
      AppLogger.error(
        'Failed to load team details',
        tag: 'TeamBloc',
        error: e,
        stackTrace: st,
      );
      emit(TeamError(message: 'Failed to load team details: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    AppLogger.debug('Closing TeamBloc', tag: 'TeamBloc');
    _gamesSubscription?.cancel();
    return super.close();
  }
}

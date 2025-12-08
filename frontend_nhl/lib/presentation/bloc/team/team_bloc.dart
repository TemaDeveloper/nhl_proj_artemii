import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend_nhl/domain/usecases/get_team_usecase.dart';
import 'package:frontend_nhl/core/utils/logger.dart';
import 'package:frontend_nhl/domain/entities/team.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final GetTeamDetailsUseCase _getTeamDetailsUseCase;

  TeamBloc(this._getTeamDetailsUseCase) : super(const TeamInitial()) {
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
      emit(TeamLoaded(team: team));
      print(team.toString());
      AppLogger.success('Successfully loaded team: ${team.name}', tag: 'TeamBloc');
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
}
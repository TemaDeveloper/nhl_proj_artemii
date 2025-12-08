import 'package:frontend_nhl/data/repositories/team_repository.dart';
import 'package:frontend_nhl/core/utils/logger.dart'; 
import 'package:frontend_nhl/domain/entities/team.dart';

class GetTeamDetailsUseCase {
  final TeamRepository _repository;

  GetTeamDetailsUseCase(this._repository);

  Future<Team> execute(String teamId) async {
    AppLogger.info('Executing GetTeamDetailsUseCase for ID: $teamId', tag: 'UseCase');
    try {
      final team = await _repository.getTeamDetails(teamId);
      AppLogger.success('Team details loaded for ID: $teamId', tag: 'UseCase');
      return team;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to load team details for ID: $teamId',
        tag: 'UseCase',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
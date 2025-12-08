import 'package:frontend_nhl/core/utils/logger.dart';
import 'package:frontend_nhl/data/repositories/game_repository.dart';
import 'package:frontend_nhl/domain/entities/game.dart';

class GetTeamGamesUseCase {
  final GameRepository _repository;

  GetTeamGamesUseCase(this._repository);

  Stream<List<Game>> execute(String teamId) {
    AppLogger.info('Executing GetTeamGamesUseCase for team: $teamId', tag: 'UseCase');
    return _repository.getTeamGames(teamId);
  }
}

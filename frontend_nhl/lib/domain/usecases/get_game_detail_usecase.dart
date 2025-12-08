import 'dart:async';
import 'package:frontend_nhl/core/utils/logger.dart';
import 'package:frontend_nhl/data/repositories/game_repository.dart';
import 'package:frontend_nhl/domain/entities/game.dart';

class GetGameDetailUseCase {
  final GameRepository _repository;

  GetGameDetailUseCase(this._repository);

  Stream<Game> execute(String gameId) {
    AppLogger.info('Executing GetGameDetailUseCase for game: $gameId', tag: 'UseCase');
    
    if (gameId.isEmpty) {
      AppLogger.error('Invalid gameId provided', tag: 'UseCase');
      throw ArgumentError('Game ID cannot be empty');
    }

    return _repository.getGameById(gameId).asStream().asyncExpand((game) {
      if (game == null) {
        AppLogger.warning('Game not found: $gameId', tag: 'UseCase');
        throw GameNotFoundException('Game with ID $gameId not found');
      }

      AppLogger.success('Game detail loaded: $gameId', tag: 'UseCase');
      return Stream.value(game);
    });
  }
}

/// Exception thrown when a game is not found.
class GameNotFoundException implements Exception {
  final String message;
  
  GameNotFoundException(this.message);
  
  @override
  String toString() => message;
}
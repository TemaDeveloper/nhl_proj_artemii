import 'dart:async';
import 'package:frontend_nhl/core/utils/logger.dart';
import 'package:frontend_nhl/data/repositories/game_repository.dart';
import 'package:frontend_nhl/domain/entities/game.dart';

class GetTodayGamesUseCase {
  final GameRepository _repository;

  GetTodayGamesUseCase(this._repository);

  Stream<List<Game>> execute() {
    AppLogger.info('Executing GetTodayGamesUseCase', tag: 'UseCase');
    
    return _repository.getTodayGames().map(
      (games) {
        AppLogger.debug('Received ${games.length} games from repository', tag: 'UseCase');
        
        // Apply business rules here
        final filteredGames = _filterValidGames(games);
        final sortedGames = _sortGamesByTime(filteredGames);
        
        AppLogger.debug(
          'After filtering: ${sortedGames.length} valid games',
          tag: 'UseCase',
        );
        
        return sortedGames;
      },
    );
  }

  /// Filter out any invalid games (business rule).
  List<Game> _filterValidGames(List<Game> games) {
    final filtered = games.where((game) {
      final isValid = game.homeTeamName.isNotEmpty && 
                      game.awayTeamName.isNotEmpty;
      
      if (!isValid) {
        AppLogger.warning(
          'Filtering out invalid game: ${game.id}',
          tag: 'UseCase',
        );
      }
      
      return isValid;
    }).toList();
    
    return filtered;
  }

  /// Sort games by start time (business rule).
  List<Game> _sortGamesByTime(List<Game> games) {
    final sorted = List<Game>.from(games);
    sorted.sort((a, b) => a.startTime.compareTo(b.startTime));
    return sorted;
  }
}
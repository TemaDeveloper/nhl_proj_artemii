import 'dart:async';
import 'package:frontend_nhl/domain/entities/game.dart';

abstract class GameRepository {
  /// Stream of today's games (filtered by current date).
  Stream<List<Game>> getTodayGames();
  
  /// Stream of all games (no date filter).
  Stream<List<Game>> getAllGames();

  Future<Game?> getGameById(String gameId);

  /// Stream of games for a specific team.
  Stream<List<Game>> getTeamGames(String teamId);
}
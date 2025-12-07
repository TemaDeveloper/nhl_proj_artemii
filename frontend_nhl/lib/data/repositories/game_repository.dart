import 'dart:async';
import 'package:frontend_nhl/domain/entities/game.dart';

abstract class GameRepository {
  /// Stream of today's games (filtered by current date).
  Stream<List<Game>> getTodayGames();
  
  /// Stream of all games (no date filter).
  Stream<List<Game>> getAllGames();

}
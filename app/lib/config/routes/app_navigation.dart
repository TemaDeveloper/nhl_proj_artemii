import 'package:frontend_nhl/domain/entities/game.dart';

sealed class GameNavigation {}
sealed class TeamNavigation {}

final class TeamNavOpenDetail extends TeamNavigation {
  final String teamId;
  TeamNavOpenDetail({required this.teamId});
}

final class GameNavOpenDetail extends GameNavigation {
  final String gameId;
  final Game game;
  GameNavOpenDetail({required this.gameId, required this.game});
}
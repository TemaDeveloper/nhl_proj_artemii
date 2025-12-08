sealed class GameNavigation {}
sealed class TeamNavigation {}

final class TeamNavOpenDetail extends TeamNavigation {
  final String teamId;
  TeamNavOpenDetail({required this.teamId});
}

final class GameNavOpenDetail extends GameNavigation {
  final String gameId;
  GameNavOpenDetail({required this.gameId});
}
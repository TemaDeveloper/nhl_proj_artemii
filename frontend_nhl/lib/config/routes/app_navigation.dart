sealed class GameNavigation {}

final class GameNavOpenDetail extends GameNavigation {
  final String gameId;
  GameNavOpenDetail({required this.gameId});
}
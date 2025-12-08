import 'package:json_annotation/json_annotation.dart';

enum GameStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('live')
  live,
  @JsonValue('final')
  final_;

  static GameStatus fromString(String status) {
    final lowerStatus = status.toLowerCase().trim();
    switch (lowerStatus) {
      case 'scheduled':
      case 'fut': // Future games (NHL API)
        return GameStatus.scheduled;
      case 'live':
      case 'on_going': // Sometimes used for live games
        return GameStatus.live;
      case 'final':
      case 'off': // Off (finished game, NHL API)
      case 'completed_regulation':
      case 'completed_ot':
      case 'completed_shootout':
        return GameStatus.final_;
      default:
        // Default to scheduled if unable to parse
        return GameStatus.scheduled;
    }
  }

  String toDisplayString() {
    switch (this) {
      case GameStatus.scheduled:
        return 'Scheduled';
      case GameStatus.live:
        return 'Live';
      case GameStatus.final_:
        return 'Final';
    }
  }

  bool get isLive => this == GameStatus.live;
  bool get isScheduled => this == GameStatus.scheduled;
  bool get isFinal => this == GameStatus.final_;
}
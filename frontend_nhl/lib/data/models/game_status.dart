import 'package:json_annotation/json_annotation.dart';

enum GameStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('live')
  live,
  @JsonValue('final')
  final_;

  static GameStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return GameStatus.scheduled;
      case 'live':
        return GameStatus.live;
      case 'final':
        return GameStatus.final_;
      default:
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
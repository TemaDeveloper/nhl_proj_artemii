import 'package:equatable/equatable.dart';

import '../../data/models/game_status.dart';

class Game extends Equatable {
  final String id;
  final String homeTeamId;
  final String awayTeamId;
  final String homeTeamName;
  final String awayTeamName;
  final int homeTeamScore;
  final int awayTeamScore;
  final GameStatus status;
  final DateTime startTime;
  final String? venue;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Game({
    required this.id,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamScore,
    required this.awayTeamScore,
    required this.status,
    required this.startTime,
    this.venue,
    this.homeTeamLogo,
    this.awayTeamLogo,
    this.createdAt,
    this.updatedAt,
  });

  String? get winner {
    if (!status.isFinal) return null;
    if (homeTeamScore > awayTeamScore) return homeTeamName;
    if (awayTeamScore > homeTeamScore) return awayTeamName;
    return null; 
  }

  bool get isTie => homeTeamScore == awayTeamScore;

  int get scoreDifference => (homeTeamScore - awayTeamScore).abs();

  bool get isHomeTeamWinning => homeTeamScore > awayTeamScore;

  bool get isAwayTeamWinning => awayTeamScore > homeTeamScore;

  String get formattedScore => '$homeTeamScore-$awayTeamScore';

  @override
  List<Object?> get props => [
        id,
        homeTeamId,
        awayTeamId,
        homeTeamName,
        awayTeamName,
        homeTeamScore,
        awayTeamScore,
        status,
        startTime,
        venue,
        homeTeamLogo,
        awayTeamLogo,
        createdAt,
        updatedAt,
      ];
}
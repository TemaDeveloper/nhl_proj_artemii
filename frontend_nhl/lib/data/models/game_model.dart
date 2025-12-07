// game_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend_nhl/converters/datetime_converter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/game.dart';
import 'game_status.dart';

part 'game_model.g.dart';

@JsonSerializable(explicitToJson: true, ignoreUnannotated: true)
class GameModel {
  @JsonKey(name: 'gameId')
  final String gameId;

  @JsonKey(name: 'homeTeamId')
  final String homeTeamId;

  @JsonKey(name: 'awayTeamId')
  final String awayTeamId;

  @JsonKey(name: 'homeTeamName')
  final String homeTeamName;

  @JsonKey(name: 'awayTeamName')
  final String awayTeamName;

  @JsonKey(name: 'homeTeamScore')
  final int homeTeamScore;

  @JsonKey(name: 'awayTeamScore')
  final int awayTeamScore;

  @JsonKey(name: 'status')
  final GameStatus status;

  @JsonKey(name: 'startTime')
  @DateTimeConverter()
  final DateTime startTime;

  @JsonKey(name: 'venue')
  final String? venue;

  @JsonKey(name: 'homeTeamLogo')
  final String? homeTeamLogo;

  @JsonKey(name: 'awayTeamLogo')
  final String? awayTeamLogo;

  @JsonKey(name: 'createdAt')
  @DateTimeConverter()
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  @DateTimeConverter()
  final DateTime? updatedAt;

  const GameModel({
    required this.gameId,
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

  static DateTime? _parseDateTime(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value)?.toUtc();
    }
    if (value is Timestamp) {
      return value.toDate().toUtc();
    }
    return null;
  }

  /// Convert Firestore document to GameModel
  factory GameModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Nested team data extraction
    final Map<String, dynamic> homeTeamData =
        (data['homeTeam'] as Map<String, dynamic>?) ?? {};
    final Map<String, dynamic> awayTeamData =
        (data['awayTeam'] as Map<String, dynamic>?) ?? {};

    return GameModel(
      gameId: data['gameId']?.toString() ?? doc.id, 
      
      // Extracting nested data
      homeTeamId: homeTeamData['id']?.toString() ?? '',
      awayTeamId: awayTeamData['id']?.toString() ?? '',
      homeTeamName: homeTeamData['name'] ?? 'Unknown',
      awayTeamName: awayTeamData['name'] ?? 'Unknown',
      homeTeamScore: (homeTeamData['score'] as num?)?.toInt() ?? 0,
      awayTeamScore: (awayTeamData['score'] as num?)?.toInt() ?? 0,
      
      // status field is at top level
      status: GameStatus.fromString(data['status'] ?? 'scheduled'),
      
      // Use the static helper method
      startTime: _parseDateTime(data['startTime']) ?? DateTime.now().toUtc(),

      // These fields are not present in your sample, defaulting to null
      venue: data['venue'] as String?,
      homeTeamLogo: homeTeamData['logoUrl'] as String?,
      awayTeamLogo: awayTeamData['logoUrl'] as String?,
      
      // Handle createdAt/updatedAt which might be Timestamp objects
      createdAt: _parseDateTime(data['createdAt']),
      updatedAt: _parseDateTime(data['updatedAt']),
    );
  }

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameModelToJson(this);

  Game toEntity() {
    return Game(
      id: gameId,
      homeTeamId: homeTeamId,
      awayTeamId: awayTeamId,
      homeTeamName: homeTeamName,
      awayTeamName: awayTeamName,
      homeTeamScore: homeTeamScore,
      awayTeamScore: awayTeamScore,
      status: status,
      startTime: startTime,
      venue: venue,
      homeTeamLogo: homeTeamLogo,
      awayTeamLogo: awayTeamLogo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  GameModel copyWith({
    String? gameId,
    String? homeTeamId,
    String? awayTeamId,
    String? homeTeamName,
    String? awayTeamName,
    int? homeTeamScore,
    int? awayTeamScore,
    GameStatus? status,
    DateTime? startTime,
    String? venue,
    String? homeTeamLogo,
    String? awayTeamLogo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GameModel(
      gameId: gameId ?? this.gameId,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      awayTeamName: awayTeamName ?? this.awayTeamName,
      homeTeamScore: homeTeamScore ?? this.homeTeamScore,
      awayTeamScore: awayTeamScore ?? this.awayTeamScore,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      venue: venue ?? this.venue,
      homeTeamLogo: homeTeamLogo ?? this.homeTeamLogo,
      awayTeamLogo: awayTeamLogo ?? this.awayTeamLogo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return '''GameModel(
      id: $gameId,
      homeTeamName: $homeTeamName,
      awayTeamName: $awayTeamName,
      status: ${status.toDisplayString()},
      score: $homeTeamScore - $awayTeamScore,
      startTime: $startTime,
    )''';
  }
}
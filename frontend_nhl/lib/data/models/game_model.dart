import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend_nhl/converters/datetime_converter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/game.dart';
import 'game_status.dart';

part 'game_model.g.dart';

@JsonSerializable(explicitToJson: true, ignoreUnannotated: true)
class GameModel {
  @JsonKey(name: 'id')
  final String id;

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

  /// Convert Firestore document to GameModel
  factory GameModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GameModel(
      id: doc.id,
      homeTeamId: data['homeTeamId'] ?? '',
      awayTeamId: data['awayTeamId'] ?? '',
      homeTeamName: data['homeTeamName'] ?? 'Unknown',
      awayTeamName: data['awayTeamName'] ?? 'Unknown',
      homeTeamScore: data['homeTeamScore'] ?? 0,
      awayTeamScore: data['awayTeamScore'] ?? 0,
      status: GameStatus.fromString(data['status'] ?? 'scheduled'),
      startTime: data['startTime'] != null
          ? (data['startTime'] as Timestamp).toDate()
          : DateTime.now(),
      venue: data['venue'],
      homeTeamLogo: data['homeTeamLogo'],
      awayTeamLogo: data['awayTeamLogo'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameModelToJson(this);

  Game toEntity() {
    return Game(
      id: id,
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
    String? id,
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
      id: id ?? this.id,
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
      id: $id,
      homeTeamName: $homeTeamName,
      awayTeamName: $awayTeamName,
      status: ${status.toDisplayString()},
      score: $homeTeamScore - $awayTeamScore,
      startTime: $startTime,
    )''';
  }
}
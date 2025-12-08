import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend_nhl/converters/datetime_converter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/team.dart';
part 'team_model.g.dart';

@JsonSerializable(explicitToJson: true, ignoreUnannotated: true)
class TeamModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'city')
  final String city;

  @JsonKey(name: 'logo')
  final String? logo;

  @JsonKey(name: 'conference')
  final String? conference;

  @JsonKey(name: 'division')
  final String? division;

  @JsonKey(name: 'wins')
  final int wins;

  @JsonKey(name: 'losses')
  final int losses;

  @JsonKey(name: 'overtimeLosses')
  final int? overtimeLosses;

  @JsonKey(name: 'points')
  final int points;

  @JsonKey(name: 'gamesPlayed')
  final int totalGames;

  @JsonKey(name: 'winPctg')
  final double winPercentage;

  @JsonKey(name: 'pointPctg')
  final double pointsPercentage;

  @JsonKey(name: 'createdAt')
  @DateTimeConverter()
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  @DateTimeConverter()
  final DateTime? updatedAt;

  const TeamModel({
    required this.id,
    required this.name,
    required this.city,
    this.logo,
    this.conference,
    this.division,
    required this.wins,
    required this.losses,
    this.overtimeLosses,
    required this.points,
    required this.totalGames,
    required this.winPercentage,
    required this.pointsPercentage,
    this.createdAt,
    this.updatedAt,
  });

  factory TeamModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final rawData = data['raw'] as Map<String, dynamic>? ?? {};

    // Helper function to safely parse integers
    int parseToInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.tryParse(value) ?? 0;
        } catch (e) {
          return 0;
        }
      }
      if (value is double) return value.toInt();
      return 0;
    }

    // Helper function to safely parse doubles
    double parseToDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        try {
          return double.tryParse(value) ?? 0.0;
        } catch (e) {
          return 0.0;
        }
      }
      return 0.0;
    }

    // Extract place name - it's nested: placeName: {default: Utah}
    final placeNameMap = rawData['placeName'] as Map<String, dynamic>?;
    final placeName = placeNameMap?['default']?.toString() ?? 'Unknown City';

    // Extract team abbreviation - it's nested: teamAbbrev: {default: UTA}
    final teamAbbrevMap = rawData['teamAbbrev'] as Map<String, dynamic>?;
    final teamAbbrev = teamAbbrevMap?['default']?.toString() ?? data['id']?.toString() ?? 'UNK';

    // Calculate total wins and losses from home/road
    final homeWins = parseToInt(rawData['homeWins']);
    final roadWins = parseToInt(rawData['roadWins']);
    final homeLosses = parseToInt(rawData['homeLosses']);
    final roadLosses = parseToInt(rawData['roadLosses']);
    
    final totalWins = homeWins + roadWins;
    final totalLosses = homeLosses + roadLosses;
    final totalGames = parseToInt(data['totalGames']);

    return TeamModel(
      id: data['id']?.toString() ?? doc.id,
      name: '$placeName $teamAbbrev', // e.g., "Utah UTA"
      city: placeName, // e.g., "Utah"
      conference: rawData['conferenceName']?.toString(), // Might be null in your data
      division: rawData['divisionName']?.toString(), // e.g., "Central"
      wins: totalWins,
      losses: totalLosses,
      overtimeLosses: parseToInt(rawData['otLosses']),
      points: parseToInt(data['points']),
      totalGames: totalGames,
      pointsPercentage: parseToDouble(data['pointsPercentage']),
      winPercentage: totalGames > 0 ? totalWins / totalGames : 0.0,
      logo: rawData['teamLogo']?.toString(),
      // These might not be in your Firestore data
      createdAt: null,
      updatedAt: null,
    );
  }

  // Constructor for JSON serialization (for API calls if needed)
  factory TeamModel.fromJson(Map<String, dynamic> json) => _$TeamModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamModelToJson(this);

  Team toEntity() {
    return Team(
      id: id,
      name: name,
      city: city,
      logo: logo,
      conference: conference,
      division: division,
      wins: wins,
      losses: losses,
      overtimeLosses: overtimeLosses,
      points: points,
      totalGames: totalGames,
      winPercentage: winPercentage,
      pointsPercentage: pointsPercentage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  TeamModel copyWith({
    String? id,
    String? name,
    String? city,
    String? logo,
    String? conference,
    String? division,
    int? wins,
    int? losses,
    int? overtimeLosses,
    int? points,
    int? totalGames,
    double? winPercentage,
    double? pointsPercentage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      logo: logo ?? this.logo,
      conference: conference ?? this.conference,
      division: division ?? this.division,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      overtimeLosses: overtimeLosses ?? this.overtimeLosses,
      points: points ?? this.points,
      totalGames: totalGames ?? this.totalGames,
      winPercentage: winPercentage ?? this.winPercentage,
      pointsPercentage: pointsPercentage ?? this.pointsPercentage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    final entity = toEntity();
    return '''TeamModel(
      id: $id,
      fullName: ${entity.name},
      record: ${entity.recordString},
      conference: $conference,
      division: $division,
      wins: $wins,
      losses: $losses,
      points: $points,
    )''';
  }
}
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

  factory TeamModel.fromStandings(Map<String, dynamic> json) {
    return TeamModel(
      id: json['teamAbbrev']?['default']?.toString() ?? 'unknown',
      name: json['teamName']?['default']?.toString() ?? 'Unknown Team',
      city: json['placeName']?['default']?.toString() ?? 'Unknown City',
      logo: json['teamLogo']?.toString(), 
      conference: json['conferenceName']?.toString(),
      division: json['divisionName']?.toString(),
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      overtimeLosses: json['otLosses'] ?? 0, 
      points: json['points'] ?? 0,
      totalGames: json['gamesPlayed'] ?? 0,
      winPercentage: (json['winPctg'] as num?)?.toDouble() ?? 0.0,
      pointsPercentage: (json['pointPctg'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);

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
      fullName: ${entity.fullName},
      record: ${entity.recordString},
      conference: $conference,
      division: $division,
    )''';
  }
}
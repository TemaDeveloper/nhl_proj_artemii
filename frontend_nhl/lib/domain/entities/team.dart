import 'package:equatable/equatable.dart';

class Team extends Equatable {
  final String id;
  final String name;
  final String city;
  final String? logo;
  final String? conference;
  final String? division;
  final int wins;
  final int losses;
  final int? overtimeLosses;
  
  final int points;
  final int totalGames;
  final double winPercentage;
  final double pointsPercentage;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Team({
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

  String get fullName => '$city $name';

  String get recordString {
    if (overtimeLosses != null && overtimeLosses! > 0) {
      return '$wins-$losses-$overtimeLosses';
    }
    return '$wins-$losses';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        city,
        logo,
        conference,
        division,
        wins,
        losses,
        overtimeLosses,
        points,
        totalGames,
        winPercentage,
        pointsPercentage,
        createdAt,
        updatedAt,
      ];
}
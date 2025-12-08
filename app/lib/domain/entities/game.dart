import 'package:equatable/equatable.dart';
import 'package:frontend_nhl/data/models/game_status.dart';

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
  
  // New fields from JSON
  final String? homeTeamAbbrev;
  final String? awayTeamAbbrev;
  final String? homeTeamCommonName;
  final String? awayTeamCommonName;
  final String? homeTeamPlaceName;
  final String? awayTeamPlaceName;
  
  // Game state fields
  final String? periodTimeRemaining;
  final String? clockTimeRemaining;
  final bool? isIntermission;
  final bool? isClockRunning;
  
  // Period descriptor
  final int? currentPeriodNumber;
  final String? currentPeriodType;
  final int? maxRegulationPeriods;
  final String? lastPeriodType;
  final int? otPeriods;
  
  // Game outcome
  final String? winningGoalie;
  final String? winningGoalScorer;
  final String? losingGoalieDecision; // "O" for Overtime loss, etc.
  
  // Team statistics
  final int? homeTeamSog; // Shots on Goal
  final int? awayTeamSog;
  final int? homeTeamPim; // Penalty Minutes
  final int? awayTeamPim;
  final int? homeTeamHits;
  final int? awayTeamHits;
  final int? homeTeamBlockedShots;
  final int? awayTeamBlockedShots;
  final int? homeTeamGiveaways;
  final int? awayTeamGiveaways;
  final int? homeTeamTakeaways;
  final int? awayTeamTakeaways;
  
  // Goalie stats
  final double? homeGoalieSavePctg;
  final double? awayGoalieSavePctg;
  final int? homeGoalieSaves;
  final int? awayGoalieSaves;
  final int? homeGoalieShotsAgainst;
  final int? awayGoalieShotsAgainst;
  
  // Game info
  final String? gameCenterLink;
  final String? condensedGameLink;
  final String? threeMinRecapLink;
  final bool? neutralSite;
  final int? gameType;
  final int? season;
  
  // TV broadcasts
  final List<TVBroadcast>? tvBroadcasts;
  
  // Player stats (simplified - you might want separate entities)
  final List<PlayerStat>? homeTeamPlayerStats;
  final List<PlayerStat>? awayTeamPlayerStats;

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
    
    // New fields
    this.homeTeamAbbrev,
    this.awayTeamAbbrev,
    this.homeTeamCommonName,
    this.awayTeamCommonName,
    this.homeTeamPlaceName,
    this.awayTeamPlaceName,
    this.periodTimeRemaining,
    this.clockTimeRemaining,
    this.isIntermission,
    this.isClockRunning,
    this.currentPeriodNumber,
    this.currentPeriodType,
    this.maxRegulationPeriods,
    this.lastPeriodType,
    this.otPeriods,
    this.winningGoalie,
    this.winningGoalScorer,
    this.losingGoalieDecision,
    this.homeTeamSog,
    this.awayTeamSog,
    this.homeTeamPim,
    this.awayTeamPim,
    this.homeTeamHits,
    this.awayTeamHits,
    this.homeTeamBlockedShots,
    this.awayTeamBlockedShots,
    this.homeTeamGiveaways,
    this.awayTeamGiveaways,
    this.homeTeamTakeaways,
    this.awayTeamTakeaways,
    this.homeGoalieSavePctg,
    this.awayGoalieSavePctg,
    this.homeGoalieSaves,
    this.awayGoalieSaves,
    this.homeGoalieShotsAgainst,
    this.awayGoalieShotsAgainst,
    this.gameCenterLink,
    this.condensedGameLink,
    this.threeMinRecapLink,
    this.neutralSite,
    this.gameType,
    this.season,
    this.tvBroadcasts,
    this.homeTeamPlayerStats,
    this.awayTeamPlayerStats,
  });

  // Helper getters
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
  
  // New helper methods
  String get currentPeriodDisplay {
    if (currentPeriodNumber == null || currentPeriodType == null) {
      return status.toDisplayString();
    }
    
    String periodName = '';
    switch (currentPeriodNumber) {
      case 1: periodName = '1st'; break;
      case 2: periodName = '2nd'; break;
      case 3: periodName = '3rd'; break;
      default: periodName = '$currentPeriodNumber';
    }
    
    if (currentPeriodType == 'OT') {
      periodName = 'OT';
    } else if (currentPeriodType == 'SO') {
      periodName = 'SO';
    }
    
    return periodName;
  }
  
  String get gameTimeInfo {
    if (status.isScheduled) {
      return _formatTime(startTime);
    } else if (status.isLive) {
      if (periodTimeRemaining != null && currentPeriodType != null) {
        return '$currentPeriodDisplay $periodTimeRemaining';
      } else if (isIntermission == true) {
        return '$currentPeriodDisplay Intermission';
      } else {
        return 'LIVE';
      }
    } else if (status.isFinal) {
      if (lastPeriodType != null && lastPeriodType != 'REG') {
        return 'Final/$lastPeriodType';
      }
      return 'Final';
    }
    return status.toDisplayString();
  }
  
  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
  
  // Get top scorers
  List<PlayerStat>? get homeTeamGoalScorers {
    return homeTeamPlayerStats
        ?.where((player) => player.goals > 0)
        .toList()
        ?..sort((a, b) => b.goals.compareTo(a.goals));
  }
  
  List<PlayerStat>? get awayTeamGoalScorers {
    return awayTeamPlayerStats
        ?.where((player) => player.goals > 0)
        .toList()
        ?..sort((a, b) => b.goals.compareTo(a.goals));
  }

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
        homeTeamAbbrev,
        awayTeamAbbrev,
        homeTeamCommonName,
        awayTeamCommonName,
        homeTeamPlaceName,
        awayTeamPlaceName,
        periodTimeRemaining,
        clockTimeRemaining,
        isIntermission,
        isClockRunning,
        currentPeriodNumber,
        currentPeriodType,
        maxRegulationPeriods,
        lastPeriodType,
        otPeriods,
        winningGoalie,
        winningGoalScorer,
        losingGoalieDecision,
        homeTeamSog,
        awayTeamSog,
        homeTeamPim,
        awayTeamPim,
        homeTeamHits,
        awayTeamHits,
        homeTeamBlockedShots,
        awayTeamBlockedShots,
        homeTeamGiveaways,
        awayTeamGiveaways,
        homeTeamTakeaways,
        awayTeamTakeaways,
        homeGoalieSavePctg,
        awayGoalieSavePctg,
        homeGoalieSaves,
        awayGoalieSaves,
        homeGoalieShotsAgainst,
        awayGoalieShotsAgainst,
        gameCenterLink,
        condensedGameLink,
        threeMinRecapLink,
        neutralSite,
        gameType,
        season,
        tvBroadcasts,
        homeTeamPlayerStats,
        awayTeamPlayerStats,
      ];
}

// TV Broadcast Model
class TVBroadcast extends Equatable {
  final String countryCode;
  final String network;
  final String market;
  final int id;

  const TVBroadcast({
    required this.countryCode,
    required this.network,
    required this.market,
    required this.id,
  });

  @override
  List<Object?> get props => [countryCode, network, market, id];
}

// Player Stat Model
class PlayerStat extends Equatable {
  final String playerId;
  final String name;
  final String position;
  final int sweaterNumber;
  final int goals;
  final int assists;
  final int points;
  final int plusMinus;
  final int pim; // Penalty Minutes
  final int sog; // Shots on Goal
  final int hits;
  final int blockedShots;
  final int giveaways;
  final int takeaways;
  final String toi; // Time on Ice
  final int shifts;
  final double? faceoffWinningPctg;
  final int? powerPlayGoals;

  const PlayerStat({
    required this.playerId,
    required this.name,
    required this.position,
    required this.sweaterNumber,
    this.goals = 0,
    this.assists = 0,
    this.points = 0,
    this.plusMinus = 0,
    this.pim = 0,
    this.sog = 0,
    this.hits = 0,
    this.blockedShots = 0,
    this.giveaways = 0,
    this.takeaways = 0,
    required this.toi,
    required this.shifts,
    this.faceoffWinningPctg,
    this.powerPlayGoals,
  });

  // Factory method to create from JSON
  factory PlayerStat.fromJson(Map<String, dynamic> json) {
    return PlayerStat(
      playerId: json['playerId'].toString(),
      name: json['name']['default'] ?? 'Unknown',
      position: json['position'] ?? '',
      sweaterNumber: json['sweaterNumber'] ?? 0,
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      points: json['points'] ?? 0,
      plusMinus: json['plusMinus'] ?? 0,
      pim: json['pim'] ?? 0,
      sog: json['sog'] ?? 0,
      hits: json['hits'] ?? 0,
      blockedShots: json['blockedShots'] ?? 0,
      giveaways: json['giveaways'] ?? 0,
      takeaways: json['takeaways'] ?? 0,
      toi: json['toi'] ?? '00:00',
      shifts: json['shifts'] ?? 0,
      faceoffWinningPctg: json['faceoffWinningPctg']?.toDouble(),
      powerPlayGoals: json['powerPlayGoals'],
    );
  }

  @override
  List<Object?> get props => [
        playerId,
        name,
        position,
        sweaterNumber,
        goals,
        assists,
        points,
        plusMinus,
        pim,
        sog,
        hits,
        blockedShots,
        giveaways,
        takeaways,
        toi,
        shifts,
        faceoffWinningPctg,
        powerPlayGoals,
      ];
}

// Goalie Stat Model (could extend PlayerStat or be separate)
class GoalieStat extends Equatable {
  final String playerId;
  final String name;
  final int sweaterNumber;
  final String decision; // "W", "L", "O"
  final int saves;
  final int shotsAgainst;
  final double savePctg;
  final int goalsAgainst;
  final String toi;
  final bool starter;

  const GoalieStat({
    required this.playerId,
    required this.name,
    required this.sweaterNumber,
    required this.decision,
    required this.saves,
    required this.shotsAgainst,
    required this.savePctg,
    required this.goalsAgainst,
    required this.toi,
    required this.starter,
  });

  factory GoalieStat.fromJson(Map<String, dynamic> json) {
    return GoalieStat(
      playerId: json['playerId'].toString(),
      name: json['name']['default'] ?? 'Unknown',
      sweaterNumber: json['sweaterNumber'] ?? 0,
      decision: json['decision'] ?? '',
      saves: json['saves'] ?? 0,
      shotsAgainst: json['shotsAgainst'] ?? 0,
      savePctg: (json['savePctg'] ?? 0.0).toDouble(),
      goalsAgainst: json['goalsAgainst'] ?? 0,
      toi: json['toi'] ?? '00:00',
      starter: json['starter'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        playerId,
        name,
        sweaterNumber,
        decision,
        saves,
        shotsAgainst,
        savePctg,
        goalsAgainst,
        toi,
        starter,
      ];
}
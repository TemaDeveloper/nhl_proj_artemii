import 'package:flutter/material.dart';
import 'package:frontend_nhl/domain/entities/game.dart';
import 'package:frontend_nhl/presentation/widgets/components/goalie_stat_card.dart';
import 'package:frontend_nhl/presentation/widgets/components/play_score_row.dart';
import 'package:frontend_nhl/presentation/widgets/components/player_points_row.dart';

class PlayerStats extends StatelessWidget {
  final Game game;

  const PlayerStats({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // Get top scorers
    final homeScorers = game.homeTeamGoalScorers;
    final awayScorers = game.awayTeamGoalScorers;
    
    // Get players with most points
    final homeTopPlayers = _getTopPlayersByPoints(game.homeTeamPlayerStats);
    final awayTopPlayers = _getTopPlayersByPoints(game.awayTeamPlayerStats);
    
    // Get goalies
    // final homeGoalie = game.homeTeamStartingGoalie;
    // final awayGoalie = game.awayTeamStartingGoalie;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Performers',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Starting Goalies
            // if (homeGoalie != null && awayGoalie != null)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Starting Goalies',
            //         style: Theme.of(context).textTheme.titleMedium?.copyWith(
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //       const SizedBox(height: 12),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: GoalieStatCard(
            //               goalie: homeGoalie,
            //               teamName: game.homeTeamName,
            //             ),
            //           ),
            //           const SizedBox(width: 16),
            //           Expanded(
            //             child: GoalieStatCard(
            //               goalie: awayGoalie,
            //               teamName: game.awayTeamName,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 24),
            //     ],
            //   ),
            
            // Top Scorers
            if ((homeScorers?.isNotEmpty ?? false) || (awayScorers?.isNotEmpty ?? false))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Goal Scorers',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  if (homeScorers?.isNotEmpty ?? false) ...[
                    Text(
                      '${game.homeTeamName}:',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...homeScorers!.take(3).map((player) => 
                      PlayerScoreRow(player: player)
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  if (awayScorers?.isNotEmpty ?? false) ...[
                    Text(
                      '${game.awayTeamName}:',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...awayScorers!.take(3).map((player) => 
                      PlayerScoreRow(player: player)
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            
            // Top Players by Points
            if ((homeTopPlayers?.isNotEmpty ?? false) || (awayTopPlayers?.isNotEmpty ?? false))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top Point Scorers',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.homeTeamName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (homeTopPlayers?.isNotEmpty ?? false)
                              ...homeTopPlayers!.take(2).map((player) => 
                                PlayerPointsRow(player: player)
                              )
                            else
                              const Text(
                                'No data',
                                style: TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.awayTeamName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (awayTopPlayers?.isNotEmpty ?? false)
                              ...awayTopPlayers!.take(2).map((player) => 
                                PlayerPointsRow(player: player)
                              )
                            else
                              const Text(
                                'No data',
                                style: TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            
            // Fallback if no player data
            if ((homeScorers?.isEmpty ?? true) && 
                (awayScorers?.isEmpty ?? true) && 
                (homeTopPlayers?.isEmpty ?? true) && 
                (awayTopPlayers?.isEmpty ?? true) 
            )
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Player statistics not available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  List<PlayerStat>? _getTopPlayersByPoints(List<PlayerStat>? players) {
    if (players == null || players.isEmpty) return null;
    
    return List<PlayerStat>.from(players)
      ..sort((a, b) => b.points.compareTo(a.points));
  }
}
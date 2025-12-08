import 'package:flutter/material.dart';
import 'package:frontend_nhl/domain/entities/game.dart';
import 'package:frontend_nhl/presentation/widgets/components/stat_row.dart';

class TeamStats extends StatelessWidget {
  final Game game;

  const TeamStats({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Stats Table Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Statistic',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    game.awayTeamName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    game.homeTeamName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            
            // Stats Rows
            StatRow(
              label: 'Score',
              awayValue: game.awayTeamScore.toString(),
              homeValue: game.homeTeamScore.toString(),
            ),
            
            if (game.awayTeamSog != null && game.homeTeamSog != null)
              StatRow(
                label: 'Shots on Goal',
                awayValue: game.awayTeamSog!.toString(),
                homeValue: game.homeTeamSog!.toString(),
              ),
            
            if (game.awayTeamPim != null && game.homeTeamPim != null)
              StatRow(
                label: 'Penalty Minutes',
                awayValue: game.awayTeamPim!.toString(),
                homeValue: game.homeTeamPim!.toString(),
              ),
            
            if (game.awayTeamHits != null && game.homeTeamHits != null)
              StatRow(
                label: 'Hits',
                awayValue: game.awayTeamHits!.toString(),
                homeValue: game.homeTeamHits!.toString(),
              ),
            
            if (game.awayTeamBlockedShots != null && game.homeTeamBlockedShots != null)
              StatRow(
                label: 'Blocked Shots',
                awayValue: game.awayTeamBlockedShots!.toString(),
                homeValue: game.homeTeamBlockedShots!.toString(),
              ),
            
            if (game.awayTeamGiveaways != null && game.homeTeamGiveaways != null)
              StatRow(
                label: 'Giveaways',
                awayValue: game.awayTeamGiveaways!.toString(),
                homeValue: game.homeTeamGiveaways!.toString(),
              ),
            
            if (game.awayTeamTakeaways != null && game.homeTeamTakeaways != null)
              StatRow(
                label: 'Takeaways',
                awayValue: game.awayTeamTakeaways!.toString(),
                homeValue: game.homeTeamTakeaways!.toString(),
              ),
          ],
        ),
      ),
    );
  }
}
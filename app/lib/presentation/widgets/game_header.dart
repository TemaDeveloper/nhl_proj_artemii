import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_nhl/domain/entities/game.dart';
import 'package:frontend_nhl/presentation/bloc/game_detail/game_detail_bloc.dart';

class GameHeader extends StatelessWidget {
  final Game game;

  const GameHeader({super.key, required this.game});

  void _navigateToTeamPage(BuildContext context, String teamId) {
    context.read<GameDetailBloc>().add(TeamTappedEvent(teamId: teamId));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Team Logos and Names
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TeamDisplay(
                  game: game,
                  teamId: game.awayTeamId,
                  teamName: game.awayTeamName,
                  teamLogo: game.awayTeamLogo,
                  score: game.awayTeamScore,
                  isWinning: game.isAwayTeamWinning,
                  onTeamTap: () => _navigateToTeamPage(context, game.awayTeamName),
                ),
                const Text(
                  '@',
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
                TeamDisplay(
                  game: game,
                  teamId: game.homeTeamId,
                  teamName: game.homeTeamName,
                  teamLogo: game.homeTeamLogo,
                  score: game.homeTeamScore,
                  isWinning: game.isHomeTeamWinning,
                  onTeamTap: () => _navigateToTeamPage(context, game.homeTeamName),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Final Score
            if (game.status.isFinal)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  'FINAL',
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TeamDisplay extends StatelessWidget {
  final Game game;
  final String teamId;
  final String teamName;
  final String? teamLogo;
  final int score;
  final bool isWinning;
  final VoidCallback onTeamTap;

  const TeamDisplay({
    super.key,
    required this.game,
    required this.teamId,
    required this.teamName,
    this.teamLogo,
    required this.score,
    required this.isWinning,
    required this.onTeamTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Team Logo (tappable)
        GestureDetector(
          onTap: onTeamTap,
          child: Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: teamLogo != null && teamLogo!.isNotEmpty
                ? ClipOval(
                    child: SvgPicture.network(
                      teamLogo!,
                      fit: BoxFit.cover,
                      placeholderBuilder: (context) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.sports_hockey,
                      color: Colors.grey.shade400,
                      size: 40,
                    ),
                  ),
          ),
        ),
        
        // Team Name (tappable)
        GestureDetector(
          onTap: onTeamTap,
          child: Text(
            teamName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isWinning ? Colors.black : Colors.grey.shade700,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue.shade300,
            ),
          ),
        ),
        
        const SizedBox(height: 4),
        
        // Score (not tappable)
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: isWinning ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
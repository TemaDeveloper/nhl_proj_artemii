import 'package:flutter/material.dart';
import 'package:frontend_nhl/domain/entities/game.dart';

class GameOutcomeInfo extends StatelessWidget {
  final Game game;

  const GameOutcomeInfo({super.key, required this.game});

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
              'Game Outcome',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            if (game.winningGoalie != null)
              OutcomeRow(
                label: 'Winning Goalie',
                value: game.winningGoalie!,
              ),
            
            if (game.winningGoalScorer != null)
              OutcomeRow(
                label: 'Game-Winning Goal',
                value: game.winningGoalScorer!,
              ),
            
            if (game.lastPeriodType != null)
              OutcomeRow(
                label: 'Final Period',
                value: game.lastPeriodType!,
              ),
          ],
        ),
      ),
    );
  }
}

class OutcomeRow extends StatelessWidget {
  final String label;
  final String value;

  const OutcomeRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
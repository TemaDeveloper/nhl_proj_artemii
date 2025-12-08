import 'package:flutter/material.dart';
import 'package:frontend_nhl/domain/entities/game.dart';

class GoalieStatCard extends StatelessWidget {
  final GoalieStat goalie;
  final String teamName;

  const GoalieStatCard({
    super.key,
    required this.goalie,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade50,
                  ),
                  child: Center(
                    child: Text(
                      goalie.sweaterNumber.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goalie.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        teamName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (goalie.decision.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDecisionColor(goalie.decision),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      goalie.decision,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GoalieStatItem(
                  label: 'Saves',
                  value: '${goalie.saves}/${goalie.shotsAgainst}',
                ),
                GoalieStatItem(
                  label: 'Save %',
                  value: '${(goalie.savePctg * 100).toStringAsFixed(1)}%',
                ),
                GoalieStatItem(
                  label: 'TOI',
                  value: goalie.toi,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getDecisionColor(String decision) {
    switch (decision) {
      case 'W':
        return Colors.green.shade600;
      case 'L':
        return Colors.red.shade600;
      case 'O': // Overtime loss
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}

class GoalieStatItem extends StatelessWidget {
  final String label;
  final String value;

  const GoalieStatItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
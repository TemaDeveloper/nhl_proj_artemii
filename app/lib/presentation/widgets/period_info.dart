import 'package:flutter/material.dart';
import 'package:frontend_nhl/domain/entities/game.dart';

class PeriodInfo extends StatelessWidget {
  final Game game;

  const PeriodInfo({super.key, required this.game});

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
              'Period Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PeriodItem(
                  label: 'Current',
                  value: '${game.currentPeriodNumber ?? 'N/A'}',
                ),
                PeriodItem(
                  label: 'Type',
                  value: game.currentPeriodType ?? 'N/A',
                ),
                PeriodItem(
                  label: 'Max Regulation',
                  value: '${game.maxRegulationPeriods ?? 'N/A'}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PeriodItem extends StatelessWidget {
  final String label;
  final String value;

  const PeriodItem({
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
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
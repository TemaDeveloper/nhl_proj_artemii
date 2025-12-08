import 'package:flutter/material.dart';
import 'package:frontend_nhl/domain/entities/game.dart';
import 'package:frontend_nhl/data/models/game_status.dart';
import 'package:frontend_nhl/presentation/widgets/components/info_row.dart';

class GameStatusInfo extends StatelessWidget {
  final Game game;

  const GameStatusInfo({super.key, required this.game});

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
              'Game Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            InfoRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: _formatDate(game.startTime),
            ),
            
            InfoRow(
              icon: Icons.schedule,
              label: 'Time',
              value: _formatTime(game.startTime),
            ),
            
            InfoRow(
              icon: Icons.flag,
              label: 'Status',
              value: game.status.toDisplayString(),
              valueColor: _getStatusColor(game.status),
            ),
            
            if (game.periodTimeRemaining != null)
              InfoRow(
                icon: Icons.timer,
                label: 'Time Remaining',
                value: game.periodTimeRemaining!,
              ),
            
            if (game.isIntermission != null)
              InfoRow(
                icon: Icons.pause_circle,
                label: 'Intermission',
                value: game.isIntermission! ? 'Yes' : 'No',
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(GameStatus status) {
    if (status.isLive) return Colors.red.shade700;
    if (status.isFinal) return Colors.green.shade700;
    return Colors.blueGrey;
  }
}
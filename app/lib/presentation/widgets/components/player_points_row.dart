import 'package:flutter/material.dart';
import 'package:frontend_nhl/domain/entities/game.dart';

class PlayerPointsRow extends StatelessWidget {
  final PlayerStat player;

  const PlayerPointsRow({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade50,
            ),
            child: Center(
              child: Text(
                player.sweaterNumber.toString(),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              player.name,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Text(
                  '${player.points}',
                  style: TextStyle(
                    color: Colors.purple.shade800,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                Text(
                  ' P',
                  style: TextStyle(
                    color: Colors.purple.shade800,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
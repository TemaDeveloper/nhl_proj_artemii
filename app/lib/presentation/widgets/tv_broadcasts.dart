import 'package:flutter/material.dart';
import 'package:frontend_nhl/domain/entities/game.dart';

class TVBroadcasts extends StatelessWidget {
  final List<TVBroadcast> tvBroadcasts;

  const TVBroadcasts({super.key, required this.tvBroadcasts});

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
            Row(
              children: [
                Icon(Icons.tv, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'TV Broadcasts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            ...tvBroadcasts.take(3).map((broadcast) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      broadcast.network,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Chip(
                    label: Text(
                      broadcast.countryCode,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.blue.shade50,
                  ),
                ],
              ),
            )),
            
            if (tvBroadcasts.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '+ ${tvBroadcasts.length - 3} more',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
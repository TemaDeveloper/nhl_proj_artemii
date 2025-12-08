import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_nhl/core/utils/date_time_utils.dart';
import 'package:frontend_nhl/domain/entities/game.dart';
import 'package:frontend_nhl/data/models/game_status.dart';
import 'package:frontend_nhl/presentation/bloc/games/games_bloc.dart';

/// Card widget displaying a single game summary.
class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.read<GamesBloc>().add(
            GamesCardTappedEvent(gameId: game.id),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _GameStatusBadge(status: game.status),
              const SizedBox(height: 16),
              _GameScore(game: game),
              if (game.venue?.isNotEmpty ?? false) ...[
                const SizedBox(height: 8),
                _VenueInfo(venue: game.venue!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GameStatusBadge extends StatelessWidget {
  final GameStatus status;

  const _GameStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color, width: 1),
        ),
        child: Text(
          status.toDisplayString().toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (status.isLive) return Colors.red.shade700;
    if (status.isFinal) return Colors.green.shade700;
    return Colors.blueGrey;
  }
}

class _GameScore extends StatelessWidget {
  final Game game;

  const _GameScore({required this.game});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _TeamInfo(game: game, isHomeTeam: false)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: _GameSeparator(game: game),
        ),
        Expanded(child: _TeamInfo(game: game, isHomeTeam: true)),
      ],
    );
  }
}

class _TeamInfo extends StatelessWidget {
  final Game game;
  final bool isHomeTeam;

  const _TeamInfo({required this.game, required this.isHomeTeam});

  @override
  Widget build(BuildContext context) {
    final teamName = isHomeTeam ? game.homeTeamName : game.awayTeamName;
    final score = isHomeTeam ? game.homeTeamScore : game.awayTeamScore;
    final isWinning = isHomeTeam ? game.isHomeTeamWinning : game.isAwayTeamWinning;
    final alignment = isHomeTeam ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          teamName,
          style: TextStyle(
            fontWeight: isWinning ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
          ),
          textAlign: isHomeTeam ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 4),
        Text(
          game.status.isScheduled 
            ? (isHomeTeam ? 'HOME' : 'AWAY') 
            : score.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 32,
            color: game.status.isScheduled
              ? Colors.blueGrey
              : (isWinning ? Colors.black : Colors.grey.shade700),
          ),
        ),
      ],
    );
  }
}

class _GameSeparator extends StatelessWidget {
  final Game game;

  const _GameSeparator({required this.game});

  @override
  Widget build(BuildContext context) {
    if (game.status.isScheduled) {
      return Text(
        DateTimeUtils.formatTime(game.startTime),
        style: TextStyle(
          fontSize: 14,
          color: Colors.blueGrey.shade700,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    }

    return const Text(
      '-',
      style: TextStyle(
        color: Colors.black54,
        fontSize: 32,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

class _VenueInfo extends StatelessWidget {
  final String venue;

  const _VenueInfo({required this.venue});

  @override
  Widget build(BuildContext context) {
    return Text(
      '@ $venue',
      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
    );
  }
}
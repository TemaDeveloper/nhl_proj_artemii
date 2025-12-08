import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_nhl/config/routes/app_navigation.dart';
import 'package:frontend_nhl/config/routes/app_router.gr.dart';
import 'package:frontend_nhl/core/utils/date_time_utils.dart';
import 'package:frontend_nhl/di/injector_container.dart';
import 'package:frontend_nhl/domain/entities/game.dart';
import 'package:frontend_nhl/presentation/bloc/game_detail/game_detail_bloc.dart';

@RoutePage()
class GameDetailPage extends StatelessWidget {
  final String gameId;

  const GameDetailPage({super.key, @PathParam('gameId') required this.gameId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GameDetailBloc>()
        ..add(FetchGameDetailEvent(gameId: gameId)),
      
      child: BlocListener<GameDetailBloc, GameDetailState>(
        // Only listen when a navigation event is present
        listenWhen: (previous, current) => current.doNavigation != null,
        listener: (context, state) {
          final nav = state.doNavigation;
          
          if (nav is TeamNavOpenDetail) {
            // Execute the AutoRoute navigation to the Team page
            context.pushRoute(TeamRoute(teamId: nav.teamId));
          }
        },
        // The main view (Scaffold) is the child
        child: const _GameDetailView(),
      ),
    );
  }
}

class _GameDetailView extends StatelessWidget {
  const _GameDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Details'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<GameDetailBloc, GameDetailState>(
        builder: (context, state) {
          return switch (state) {
            GameDetailInitial() ||
            GameDetailLoading() => const Center(child: CircularProgressIndicator()),
            GameDetailError(:final message) => _ErrorView(message: message),
            GameDetailLoaded(:final game) ||
            GameDetailRefreshing(:final game) => _GameDetailContent(game: game),
          };
        },
      ),
    );
  }
}

class _GameDetailContent extends StatelessWidget {
  final Game game;

  const _GameDetailContent({required this.game});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GameDetailBloc>().add(RefreshGameDetailEvent(gameId: game.id));
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _GameStatusCard(game: game),
            const SizedBox(height: 16),
            _ScoreCard(game: game),
            const SizedBox(height: 16),
            _GameInfoCard(game: game),
            const SizedBox(height: 16),
            _TeamNavigationCard(game: game),
          ],
        ),
      ),
    );
  }
}

class _GameStatusCard extends StatelessWidget {
  final Game game;

  const _GameStatusCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getStatusColor(), width: 2),
              ),
              child: Text(
                game.status.toDisplayString().toUpperCase(),
                style: TextStyle(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              DateTimeUtils.formatDate(game.startTime),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              DateTimeUtils.formatTime(game.startTime),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (game.status.isLive) return Colors.red.shade700;
    if (game.status.isFinal) return Colors.green.shade700;
    return Colors.blueGrey;
  }
}

class _ScoreCard extends StatelessWidget {
  final Game game;

  const _ScoreCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _TeamScoreRow(
              teamName: game.awayTeamName,
              score: game.awayTeamScore,
              isWinning: game.isAwayTeamWinning && game.status.isFinal,
              isScheduled: game.status.isScheduled,
              label: 'AWAY',
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            _TeamScoreRow(
              teamName: game.homeTeamName,
              score: game.homeTeamScore,
              isWinning: game.isHomeTeamWinning && game.status.isFinal,
              isScheduled: game.status.isScheduled,
              label: 'HOME',
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamScoreRow extends StatelessWidget {
  final String teamName;
  final int score;
  final bool isWinning;
  final bool isScheduled;
  final String label;

  const _TeamScoreRow({
    required this.teamName,
    required this.score,
    required this.isWinning,
    required this.isScheduled,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                teamName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: isWinning ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Text(
          isScheduled ? '-' : score.toString(),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: isWinning ? Colors.green.shade700 : Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

class _GameInfoCard extends StatelessWidget {
  final Game game;

  const _GameInfoCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Game Information', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _InfoRow(label: 'Game ID', value: game.id),
            const Divider(height: 24),
            _InfoRow(label: 'Venue', value: game.venue ?? 'N/A'),
            const Divider(height: 24),
            _InfoRow(label: 'Home Team ID', value: game.homeTeamId),
            const Divider(height: 24),
            _InfoRow(label: 'Away Team ID', value: game.awayTeamId),
            if (game.status.isFinal && !game.isTie) ...[
              const Divider(height: 24),
              _InfoRow(
                label: 'Winner',
                value: game.winner ?? 'N/A',
                valueColor: Colors.green.shade700,
              ),
            ],
            if (game.status.isFinal && game.isTie) ...[
              const Divider(height: 24),
              _InfoRow(label: 'Result', value: 'Tie Game', valueColor: Colors.orange.shade700),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        Flexible(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: valueColor),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _TeamNavigationCard extends StatelessWidget {
  final Game game;

  const _TeamNavigationCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('View Team Details', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _TeamButton(
              teamName: game.homeTeamName, 
              teamAbbrev: game.homeTeamName,
              label: 'Home Team'
            ),
            const SizedBox(height: 12),
            _TeamButton(
              teamName: game.awayTeamName, 
              teamAbbrev: game.awayTeamName, // CHANGE: Get abbreviation
              label: 'Away Team'
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamButton extends StatelessWidget {
  final String teamName;
  final String teamAbbrev; // CHANGE: Use teamAbbrev instead of teamId
  final String label;

  const _TeamButton({
    required this.teamName, 
    required this.teamAbbrev, // CHANGE
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('Team ID: $teamAbbrev'); 
        context.read<GameDetailBloc>().add(
          TeamTappedEvent(teamId: teamAbbrev), 
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  teamName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Game Not Found', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Games'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_nhl/config/routes/app_navigation.dart';
import 'package:frontend_nhl/config/routes/app_router.gr.dart';
import 'package:frontend_nhl/di/injector_container.dart';
import 'package:frontend_nhl/domain/entities/game.dart';
import 'package:frontend_nhl/presentation/bloc/game_detail/game_detail_bloc.dart';
import 'package:frontend_nhl/presentation/widgets/game_header.dart';
import 'package:frontend_nhl/presentation/widgets/game_outcome_info.dart';
import 'package:frontend_nhl/presentation/widgets/game_status_info.dart';
import 'package:frontend_nhl/presentation/widgets/period_info.dart';
import 'package:frontend_nhl/presentation/widgets/player_stats.dart';
import 'package:frontend_nhl/presentation/widgets/team_stats.dart';
import 'package:frontend_nhl/presentation/widgets/tv_broadcasts.dart';
import 'package:frontend_nhl/presentation/widgets/venue_info.dart';

@RoutePage()
class GameDetailPage extends StatelessWidget {
  final String gameId;
  final Game game;

  const GameDetailPage({
    super.key,
    @PathParam('gameId') required this.gameId,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GameDetailBloc>()..add(FetchGameDetailEvent(gameId: gameId)),
      child: const _GameDetailView(),
    );
  }
}

class _GameDetailView extends StatelessWidget {
  const _GameDetailView();

  void _handleNavigation(BuildContext context, TeamNavigation navigation) {
    switch (navigation) {
      case TeamNavOpenDetail(teamId: final teamId):
        context.router.push(TeamRoute(teamId: teamId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameDetailBloc, GameDetailState>(
      listener: (context, state) {
        if (state.doNavigation != null) {
          _handleNavigation(context, state.doNavigation!);
        }
      },
      child: BlocBuilder<GameDetailBloc, GameDetailState>(
        builder: (context, state) {
          if (state is GameDetailLoaded) {
            final game = state.game;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Game Details'),
                centerTitle: true,
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Game Header with Team Logos and Score
                      GameHeader(game: game),
                      const SizedBox(height: 24),
                      
                      // Game Status and Time Info
                      GameStatusInfo(game: game),
                      const SizedBox(height: 24),
                      
                      // Venue Information
                      if (game.venue != null && game.venue!.isNotEmpty)
                        VenueInfo(venue: game.venue!),
                      if (game.venue != null && game.venue!.isNotEmpty)
                        const SizedBox(height: 24),
                      
                      // Game Outcome Details
                      if (game.status.isFinal)
                        GameOutcomeInfo(game: game),
                      if (game.status.isFinal)
                        const SizedBox(height: 24),
                      
                      // Period Descriptor (Current Period Info)
                      if (game.currentPeriodNumber != null || game.currentPeriodType != null)
                        PeriodInfo(game: game),
                      if (game.currentPeriodNumber != null || game.currentPeriodType != null)
                        const SizedBox(height: 24),
                      
                      // Team Statistics
                      TeamStats(game: game),
                      const SizedBox(height: 24),
                      
                      // Player Statistics
                      PlayerStats(game: game),
                      const SizedBox(height: 24),
                      
                      // TV Broadcasts
                      if (game.tvBroadcasts != null && game.tvBroadcasts!.isNotEmpty)
                        TVBroadcasts(tvBroadcasts: game.tvBroadcasts!),
                    ],
                  ),
                ),
              ),
            );
          }
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('Game Details'),
              centerTitle: true,
              backgroundColor: Colors.blue.shade800,
              foregroundColor: Colors.white,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
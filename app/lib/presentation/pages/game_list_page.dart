import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_nhl/config/routes/app_navigation.dart';
import 'package:frontend_nhl/config/routes/app_router.gr.dart';
import 'package:frontend_nhl/di/injector_container.dart';
import 'package:frontend_nhl/domain/entities/game.dart';
import 'package:frontend_nhl/presentation/bloc/games/games_bloc.dart';
import 'package:frontend_nhl/presentation/widgets/game_card.dart';

@RoutePage()
class GameListPage extends StatelessWidget {
  const GameListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GamesBloc>()..add(const FetchTodayGamesEvent()),
      child: const _GamesListView(),
    );
  }
}

class _GamesListView extends StatelessWidget {
  const _GamesListView();

  void _handleNavigation(BuildContext context, GameNavigation navigation) {
    switch (navigation) {
      case GameNavOpenDetail(gameId: final gameId, game: final game):
        context.router.push(
          GameDetailRoute(gameId: gameId, game: game), 
        );
      // Add other navigation cases here if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GamesBloc, GamesState>(
      listener: (context, state) {
        if (state.doNavigation != null) {
          _handleNavigation(context, state.doNavigation!);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NHL Today'),
          centerTitle: true,
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<GamesBloc, GamesState>(
          builder: (context, state) {
            return switch (state) {
              GamesInitial() || GamesLoading() => 
                const Center(child: CircularProgressIndicator()),
              
              GamesError(:final message) => 
                _ErrorView(message: message),
              
              GamesLoaded(:final games) || GamesRefreshing(:final games) => 
                games.isEmpty 
                  ? const _EmptyGamesView() 
                  : _GamesList(games: games),
            };
          },
        ),
      ),
    );
  }
}

class _GamesList extends StatelessWidget {
  final List<Game> games;

  const _GamesList({required this.games});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GamesBloc>().add(const RefreshGamesEvent());
        // Wait a moment for the refresh to start
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: games.length,
        itemBuilder: (context, index) => GameCard(game: games[index]),
      ),
    );
  }
}

class _EmptyGamesView extends StatelessWidget {
  const _EmptyGamesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_hockey, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No games scheduled for today',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
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
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<GamesBloc>().add(const FetchTodayGamesEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
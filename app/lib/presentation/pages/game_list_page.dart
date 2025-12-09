import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_nhl/config/routes/app_navigation.dart';
import 'package:frontend_nhl/config/routes/app_router.gr.dart';
import 'package:frontend_nhl/core/constants/app_constants.dart';
import 'package:frontend_nhl/core/theme/app_colors.dart';
import 'package:frontend_nhl/core/theme/app_text_styles.dart';
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
        await Future.delayed(AppConstants.refreshIndicatorDelay);
      },
      child: ListView.builder(
        padding: AppConstants.listViewPadding,
        itemCount: games.length,
        itemBuilder: (context, index) => GameCard(game: games[index]),
      ),
    );
  }
}

class _EmptyGamesView extends StatelessWidget {
  const _EmptyGamesView();

  @override
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_hockey, size: AppConstants.emptyStateIconSize, color: AppColors.grey),
            const SizedBox(height: AppConstants.largeGap),
            Text(
              'No games scheduled for today',
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.grey,
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
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: AppConstants.errorStateIconSize, color: AppColors.error),
            const SizedBox(height: AppConstants.largeGap),
            Text(
              'Oops! Something went wrong',
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: AppConstants.standardGap),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: AppConstants.xlargeGap),
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
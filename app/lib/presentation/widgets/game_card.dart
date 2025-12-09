import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_nhl/core/theme/app_colors.dart';
import 'package:frontend_nhl/core/theme/app_text_styles.dart';
import 'package:frontend_nhl/core/utils/date_time_utils.dart';
import 'package:frontend_nhl/domain/entities/game.dart';
import 'package:frontend_nhl/data/models/game_status.dart';
import 'package:frontend_nhl/presentation/bloc/games/games_bloc.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.read<GamesBloc>().add(GamesCardTappedEvent(gameId: game.id, game: game));
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
          style: AppTextStyles.labelSmall.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (status.isLive) return AppColors.gameLive;
    if (status.isFinal) return AppColors.gameFinal;
    return AppColors.gameScheduled;
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
        Expanded(
          child: _TeamInfo(
            game: game,
            isHomeTeam: false,
            teamName: game.awayTeamName,
            teamScore: game.awayTeamScore,
            teamLogoUrl: game.awayTeamLogo,
            isWinning: game.isAwayTeamWinning,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _GameSeparator(game: game),
        ),
        Expanded(
          child: _TeamInfo(
            game: game,
            isHomeTeam: true,
            teamName: game.homeTeamName,
            teamScore: game.homeTeamScore,
            teamLogoUrl: game.homeTeamLogo,
            isWinning: game.isHomeTeamWinning,
          ),
        ),
      ],
    );
  }
}

class _TeamInfo extends StatelessWidget {
  final Game game;
  final bool isHomeTeam;
  final String teamName;
  final int teamScore;
  final String? teamLogoUrl;
  final bool isWinning;

  const _TeamInfo({
    required this.game,
    required this.isHomeTeam,
    required this.teamName,
    required this.teamScore,
    this.teamLogoUrl,
    required this.isWinning,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Team Logo
        Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.mediumGrey, width: 1),
          ),
          child: teamLogoUrl != null
              ? ClipOval(
                  child: teamLogoUrl != null && teamLogoUrl!.isNotEmpty
                      ? ClipOval(
                          child: SvgPicture.network(
                            teamLogoUrl!,
                            fit: BoxFit.cover,
                            placeholderBuilder: (context) => Container(
                              color: AppColors.lightGrey,
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.lightGrey,
                          child: const Icon(Icons.sports_hockey, color: AppColors.grey, size: 30),
                        ),
                )
              : Container(
                  color: AppColors.lightGrey,
                  child: const Icon(Icons.sports_hockey, color: AppColors.grey, size: 30),
                ),
        ),

        // Team Name
        Text(
          teamName,
          style: AppTextStyles.teamName.copyWith(
            fontWeight: isWinning ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),

        const SizedBox(height: 4),

        // Team Score
        Text(
          game.status.isScheduled ? (isHomeTeam ? 'HOME' : 'AWAY') : teamScore.toString(),
          style: AppTextStyles.gameScore.copyWith(
            color: game.status.isScheduled
                ? AppColors.grey
                : (isWinning ? AppColors.black : AppColors.darkGrey),
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
      return Column(
        children: [
          Text(
            DateTimeUtils.formatTime(game.startTime),
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Icon(Icons.schedule, color: AppColors.primary, size: 20),
        ],
      );
    }

    return Column(
      children: [
        Text(
          'VS',
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.grey),
        ),
        const SizedBox(height: 16),
        Text(
          '-',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.mediumGrey,
            fontSize: 32,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class _VenueInfo extends StatelessWidget {
  final String venue;

  const _VenueInfo({required this.venue});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on, size: 14, color: AppColors.grey),
        const SizedBox(width: 4),
        Text(venue, style: AppTextStyles.bodySmall),
        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(venue, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

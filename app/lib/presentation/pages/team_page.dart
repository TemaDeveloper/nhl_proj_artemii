import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_nhl/core/constants/app_constants.dart';
import 'package:frontend_nhl/core/theme/app_colors.dart';
import 'package:frontend_nhl/core/theme/app_text_styles.dart';
import 'package:frontend_nhl/di/injector_container.dart';
import 'package:frontend_nhl/domain/entities/team.dart';
import 'package:frontend_nhl/presentation/bloc/team/team_bloc.dart';

@RoutePage()
class TeamPage extends StatelessWidget {
  final String teamId;

  const TeamPage({
    super.key,
    @PathParam('teamId') required this.teamId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TeamBloc>()..add(FetchTeamDetailsEvent(teamId: teamId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Team Details (ID: $teamId)'),
        ),
        body: BlocBuilder<TeamBloc, TeamState>(
          builder: (context, state) {
            return switch (state) {
              TeamInitial() || TeamLoading() => 
                const Center(child: CircularProgressIndicator()),
              
              TeamError(:final message) => 
                Center(child: Text('Error loading team: $message', textAlign: TextAlign.center)),
              
              TeamLoaded(:final team) => 
                _TeamDetailsView(team: team),
            };
          },
        ),
      ),
    );
  }
}

class _TeamDetailsView extends StatelessWidget {
  final Team team;

  const _TeamDetailsView({required this.team});

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.standardGap),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyLarge),
          Text(value, style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, state) {
        if (state is TeamLoaded) {
          final games = state.games;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultVerticalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.network(
                  team.logo!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
                Text(
                    team.name, 
                    style: AppTextStyles.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                
                const SizedBox(height: AppConstants.xlargeGap),
                _buildStatRow(context, 'Conference', team.conference ?? 'N/A'),
                _buildStatRow(context, 'Division', team.division ?? 'N/A'),
                const Divider(height: 32),
                Text('Record:', style: AppTextStyles.titleLarge),
                const SizedBox(height: AppConstants.standardGap),
                _buildStatRow(context, 'Total Games Played', team.totalGames.toString()),
                _buildStatRow(context, 'Wins (W)', team.wins.toString()),
                _buildStatRow(context, 'Losses (L)', team.losses.toString()),
                _buildStatRow(context, 'Points (PTS)', team.points.toString()),
                const Divider(height: 32),
                Text('Last Played Games:', style: AppTextStyles.titleLarge),
                const SizedBox(height: AppConstants.standardGap),
                if (games.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.largeGap),
                    child: Center(
                      child: Text(
                        'No games played yet',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final game = games[index];
                      final isHomeTeam = game.homeTeamId == team.id;
                      final opponent = isHomeTeam ? game.awayTeamName : game.homeTeamName;
                      final teamScore = isHomeTeam ? game.homeTeamScore : game.awayTeamScore;
                      final opponentScore = isHomeTeam ? game.awayTeamScore : game.homeTeamScore;
                      final isWin = teamScore > opponentScore;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppConstants.standardGap),
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.largeGap),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isHomeTeam ? 'HOME vs $opponent' : 'AWAY @ $opponent',
                                      style: AppTextStyles.labelLarge,
                                    ),
                                    const SizedBox(height: AppConstants.standardGap),
                                    Text(
                                      game.startTime.toString().split(' ')[0],
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '$teamScore - $opponentScore',
                                    style: AppTextStyles.titleLarge.copyWith(
                                      fontSize: 28,
                                      color: isWin ? AppColors.winColor : AppColors.lossColor,
                                    ),
                                  ),
                                  Text(
                                    isWin ? 'W' : 'L',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: isWin ? AppColors.winColor : AppColors.lossColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        }
        
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
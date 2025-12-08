import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_nhl/di/injector_container.dart';
import 'package:frontend_nhl/domain/entities/team.dart';
import 'package:frontend_nhl/presentation/bloc/team/team_bloc.dart';

@RoutePage()
class TeamPage extends StatelessWidget {
  final String teamId;

  const TeamPage({
    super.key,
    @pathParam required this.teamId, 
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TeamBloc>()..add(FetchTeamDetailsEvent(teamId: teamId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Team Details (ID: $teamId)'),
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    team.name, 
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                _buildStatRow(context, 'Conference', team.conference ?? 'N/A'),
                _buildStatRow(context, 'Division', team.division ?? 'N/A'),
                const Divider(height: 32),
                Text('Record:', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                _buildStatRow(context, 'Total Games Played', team.totalGames.toString()),
                _buildStatRow(context, 'Wins (W)', team.wins.toString()),
                _buildStatRow(context, 'Losses (L)', team.losses.toString()),
                _buildStatRow(context, 'Points (PTS)', team.points.toString()),
                const Divider(height: 32),
                Text('Last Played Games:', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (games.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No games played yet',
                        style: Theme.of(context).textTheme.bodyMedium,
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
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isHomeTeam ? 'HOME vs $opponent' : 'AWAY @ $opponent',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      game.startTime.toString().split(' ')[0],
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '$teamScore - $opponentScore',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isWin ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  Text(
                                    isWin ? 'W' : 'L',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isWin ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
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
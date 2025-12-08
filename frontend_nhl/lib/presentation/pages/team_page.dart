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
        ],
      ),
    );
  }
}
part of 'team_bloc.dart';

sealed class TeamState extends Equatable {
  const TeamState();
  
  @override
  List<Object> get props => [];
}

final class TeamInitial extends TeamState {
  const TeamInitial();
}

final class TeamLoading extends TeamState {
  const TeamLoading();
}

final class TeamLoaded extends TeamState {
  final Team team;
  final List<Game> games;

  const TeamLoaded({required this.team, required this.games});

  @override
  List<Object> get props => [team, games];
}

final class TeamError extends TeamState {
  final String message;
  const TeamError({required this.message});

  @override
  List<Object> get props => [message];
}
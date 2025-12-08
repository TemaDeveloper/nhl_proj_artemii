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
  const TeamLoaded({required this.team});

  @override
  List<Object> get props => [team];
}

final class TeamError extends TeamState {
  final String message;
  const TeamError({required this.message});

  @override
  List<Object> get props => [message];
}
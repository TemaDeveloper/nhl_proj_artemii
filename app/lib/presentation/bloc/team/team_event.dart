part of 'team_bloc.dart';

sealed class TeamEvent extends Equatable {
  const TeamEvent();
  
  @override
  List<Object> get props => [];
}

final class FetchTeamDetailsEvent extends TeamEvent {
  final String teamId;
  const FetchTeamDetailsEvent({required this.teamId});

  @override
  List<Object> get props => [teamId];
}
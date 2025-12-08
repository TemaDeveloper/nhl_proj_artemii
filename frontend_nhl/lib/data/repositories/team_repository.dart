import 'package:frontend_nhl/domain/entities/team.dart';

abstract class TeamRepository {
  Future<Team> getTeamDetails(String teamId);
}
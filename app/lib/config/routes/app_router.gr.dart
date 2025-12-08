// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:frontend_nhl/domain/entities/game.dart' as _i6;
import 'package:frontend_nhl/presentation/pages/game_detail_page.dart' as _i1;
import 'package:frontend_nhl/presentation/pages/game_list_page.dart' as _i2;
import 'package:frontend_nhl/presentation/pages/team_page.dart' as _i3;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    GameDetailRoute.name: (routeData) {
      final args = routeData.argsAs<GameDetailRouteArgs>();
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.GameDetailPage(
          key: args.key,
          gameId: args.gameId,
          game: args.game,
        ),
      );
    },
    GameListRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.GameListPage(),
      );
    },
    TeamRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<TeamRouteArgs>(
          orElse: () => TeamRouteArgs(teamId: pathParams.getString('teamId')));
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.TeamPage(
          key: args.key,
          teamId: args.teamId,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.GameDetailPage]
class GameDetailRoute extends _i4.PageRouteInfo<GameDetailRouteArgs> {
  GameDetailRoute({
    _i5.Key? key,
    required String gameId,
    required _i6.Game game,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          GameDetailRoute.name,
          args: GameDetailRouteArgs(
            key: key,
            gameId: gameId,
            game: game,
          ),
          rawPathParams: {'gameId': gameId},
          initialChildren: children,
        );

  static const String name = 'GameDetailRoute';

  static const _i4.PageInfo<GameDetailRouteArgs> page =
      _i4.PageInfo<GameDetailRouteArgs>(name);
}

class GameDetailRouteArgs {
  const GameDetailRouteArgs({
    this.key,
    required this.gameId,
    required this.game,
  });

  final _i5.Key? key;

  final String gameId;

  final _i6.Game game;

  @override
  String toString() {
    return 'GameDetailRouteArgs{key: $key, gameId: $gameId, game: $game}';
  }
}

/// generated route for
/// [_i2.GameListPage]
class GameListRoute extends _i4.PageRouteInfo<void> {
  const GameListRoute({List<_i4.PageRouteInfo>? children})
      : super(
          GameListRoute.name,
          initialChildren: children,
        );

  static const String name = 'GameListRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.TeamPage]
class TeamRoute extends _i4.PageRouteInfo<TeamRouteArgs> {
  TeamRoute({
    _i5.Key? key,
    required String teamId,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          TeamRoute.name,
          args: TeamRouteArgs(
            key: key,
            teamId: teamId,
          ),
          rawPathParams: {'teamId': teamId},
          initialChildren: children,
        );

  static const String name = 'TeamRoute';

  static const _i4.PageInfo<TeamRouteArgs> page =
      _i4.PageInfo<TeamRouteArgs>(name);
}

class TeamRouteArgs {
  const TeamRouteArgs({
    this.key,
    required this.teamId,
  });

  final _i5.Key? key;

  final String teamId;

  @override
  String toString() {
    return 'TeamRouteArgs{key: $key, teamId: $teamId}';
  }
}

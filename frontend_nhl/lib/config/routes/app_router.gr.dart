// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;
import 'package:frontend_nhl/presentation/pages/game_detail_page.dart' as _i1;
import 'package:frontend_nhl/presentation/pages/game_list_page.dart' as _i2;

abstract class $AppRouter extends _i3.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    GameDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<GameDetailRouteArgs>(
          orElse: () =>
              GameDetailRouteArgs(gameId: pathParams.getString('gameId')));
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.GameDetailPage(
          key: args.key,
          gameId: args.gameId,
        ),
      );
    },
    GameListRoute.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.GameListPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.GameDetailPage]
class GameDetailRoute extends _i3.PageRouteInfo<GameDetailRouteArgs> {
  GameDetailRoute({
    _i4.Key? key,
    required String gameId,
    List<_i3.PageRouteInfo>? children,
  }) : super(
          GameDetailRoute.name,
          args: GameDetailRouteArgs(
            key: key,
            gameId: gameId,
          ),
          rawPathParams: {'gameId': gameId},
          initialChildren: children,
        );

  static const String name = 'GameDetailRoute';

  static const _i3.PageInfo<GameDetailRouteArgs> page =
      _i3.PageInfo<GameDetailRouteArgs>(name);
}

class GameDetailRouteArgs {
  const GameDetailRouteArgs({
    this.key,
    required this.gameId,
  });

  final _i4.Key? key;

  final String gameId;

  @override
  String toString() {
    return 'GameDetailRouteArgs{key: $key, gameId: $gameId}';
  }
}

/// generated route for
/// [_i2.GameListPage]
class GameListRoute extends _i3.PageRouteInfo<void> {
  const GameListRoute({List<_i3.PageRouteInfo>? children})
      : super(
          GameListRoute.name,
          initialChildren: children,
        );

  static const String name = 'GameListRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../presentation/pages/game_list_page.dart';
import '../../presentation/pages/game_detail_page.dart';
import '../../presentation/pages/team_page.dart';

import 'app_router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends $AppRouter {
@override
  List<AutoRoute> get routes => [
        // 1. Game List Screen (Home)
        AutoRoute(page: GameListRoute.page, path: '/', initial: true),
        
        // 2. Game Detail Screen (for later)
        AutoRoute(page: GameDetailRoute.page, path: '/games/:gameId'),
        
        // // 3. Team Screen (for later)
        // AutoRoute(page: TeamRoute.page, path: '/teams/:teamId'),
      ];
}
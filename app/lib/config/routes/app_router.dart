import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'app_router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends $AppRouter {
@override
  List<AutoRoute> get routes => [
        AutoRoute(page: GameListRoute.page, path: '/', initial: true),
        
        AutoRoute(page: GameDetailRoute.page, path: '/games/:gameId'),

        AutoRoute(page: TeamRoute.page, path: '/teams/:teamId'),
      ];
} 
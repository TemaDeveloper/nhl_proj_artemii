import 'package:frontend_nhl/config/routes/app_router.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend_nhl/core/utils/logger.dart';
import 'package:frontend_nhl/data/repositories/game_repository.dart';
import 'package:frontend_nhl/data/repositories/firestore_game_repository.dart';
import 'package:frontend_nhl/domain/usecases/get_today_games_usecase.dart';
import 'package:frontend_nhl/domain/usecases/get_game_detail_usecase.dart';
import 'package:frontend_nhl/domain/usecases/get_team_games_usecase.dart';
import 'package:frontend_nhl/presentation/bloc/games/games_bloc.dart';
import 'package:frontend_nhl/presentation/bloc/game_detail/game_detail_bloc.dart';
import 'package:frontend_nhl/data/repositories/team_repository.dart';
import 'package:frontend_nhl/data/repositories/firestore_team_repository.dart';
import 'package:frontend_nhl/domain/usecases/get_team_usecase.dart';
import 'package:frontend_nhl/presentation/bloc/team/team_bloc.dart';

final getIt = GetIt.instance;


Future<void> initDependencies() async {
  AppLogger.section('Initializing Dependencies');
  

  // 1. Register AppRouter
  AppLogger.info('Registering AppRouter', tag: 'DI');
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  // 2. Register all repositories
  AppLogger.info('Registering GameRepository', tag: 'DI');
  getIt.registerLazySingleton<GameRepository>(() => FirestoreGameRepository());

  AppLogger.info('Registering TeamRepository', tag: 'DI');
  getIt.registerLazySingleton<TeamRepository>(() => FirestoreTeamRepository());

  // 3. Register Use Cases
  AppLogger.info('Registering GetTodayGamesUseCase', tag: 'DI');
  getIt.registerLazySingleton<GetTodayGamesUseCase>(
    () => GetTodayGamesUseCase(getIt<GameRepository>()),
  );

  AppLogger.info('Registering GetGameDetailUseCase', tag: 'DI');
  getIt.registerLazySingleton<GetGameDetailUseCase>(
    () => GetGameDetailUseCase(getIt<GameRepository>()),
  );

  AppLogger.info('Registering GetTeamDetailsUseCase', tag: 'DI');
  getIt.registerLazySingleton<GetTeamDetailsUseCase>(
    () => GetTeamDetailsUseCase(getIt<TeamRepository>()),
  );

  AppLogger.info('Registering GetTeamGamesUseCase', tag: 'DI');
  getIt.registerLazySingleton<GetTeamGamesUseCase>(
    () => GetTeamGamesUseCase(getIt<GameRepository>()),
  );

  // 4. Register BLoCs
  AppLogger.info('Registering GamesBloc factory', tag: 'DI');
  getIt.registerFactory<GamesBloc>(() => GamesBloc(getIt<GetTodayGamesUseCase>()));

  AppLogger.info('Registering GameDetailBloc factory', tag: 'DI');
  getIt.registerFactory<GameDetailBloc>(() => GameDetailBloc(getIt<GetGameDetailUseCase>()));

  AppLogger.info('Registering TeamBloc factory', tag: 'DI');
  getIt.registerFactory<TeamBloc>(() => TeamBloc(getIt<GetTeamDetailsUseCase>(), getIt<GetTeamGamesUseCase>()));

  AppLogger.success('Dependencies initialized successfully', tag: 'DI');
  AppLogger.divider();
}
import 'package:frontend_nhl/core/utils/logger.dart';
import 'package:frontend_nhl/data/repositories/firestore_game_repository.dart';
import 'package:frontend_nhl/data/repositories/game_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend_nhl/domain/usecases/get_today_games_usecase.dart';
import 'package:frontend_nhl/presentation/bloc/games/games_bloc.dart';

final getIt = GetIt.instance;


Future<void> initDependencies() async {
  AppLogger.section('Initializing Dependencies');
  
  // Repositories
  AppLogger.info('Registering GameRepository', tag: 'DI');
  getIt.registerLazySingleton<GameRepository>(
    () => FirestoreGameRepository(),
  );

  // Use Cases
  AppLogger.info('Registering GetTodayGamesUseCase', tag: 'DI');
  getIt.registerLazySingleton<GetTodayGamesUseCase>(
    () => GetTodayGamesUseCase(getIt<GameRepository>()),
  );

  // BLoCs - Factory so each page gets a new instance
  AppLogger.info('Registering GamesBloc factory', tag: 'DI');
  getIt.registerFactory<GamesBloc>(
    () => GamesBloc(getIt<GetTodayGamesUseCase>()),
  );
  
  AppLogger.success('Dependencies initialized successfully', tag: 'DI');
  AppLogger.divider();
}
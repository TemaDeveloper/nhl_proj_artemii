import 'package:frontend_nhl/data/repositories/game_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend_nhl/core/utils/logger.dart';
import 'package:frontend_nhl/data/repositories/firestore_game_repository.dart';
import 'package:frontend_nhl/domain/usecases/get_today_games_usecase.dart';
import 'package:frontend_nhl/domain/usecases/get_game_detail_usecase.dart';
import 'package:frontend_nhl/presentation/bloc/games/games_bloc.dart';
import 'package:frontend_nhl/presentation/bloc/game_detail/game_detail_bloc.dart';
import 'package:injectable/injectable.dart';
import 'injector_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> initDependencies() async {

  AppLogger.section('Initializing Dependencies');
  
  getIt.$initGetIt();

  AppLogger.info('Registering GameRepository', tag: 'DI');
  getIt.registerLazySingleton<GameRepository>(() => FirestoreGameRepository());


  // Use Cases
  AppLogger.info('Registering GetTodayGamesUseCase', tag: 'DI');
  getIt.registerLazySingleton<GetTodayGamesUseCase>(
    () => GetTodayGamesUseCase(getIt<GameRepository>()),
  );

  AppLogger.info('Registering GetGameDetailUseCase', tag: 'DI');
  getIt.registerLazySingleton<GetGameDetailUseCase>(
    () => GetGameDetailUseCase(getIt<GameRepository>()),
  );

  // BLoCs - Factory so each page gets a new instance
  AppLogger.info('Registering GamesBloc factory', tag: 'DI');
  getIt.registerFactory<GamesBloc>(() => GamesBloc(getIt<GetTodayGamesUseCase>()));

  AppLogger.info('Registering GameDetailBloc factory', tag: 'DI');
  getIt.registerFactory<GameDetailBloc>(() => GameDetailBloc(getIt<GetGameDetailUseCase>()));

  AppLogger.success('Dependencies initialized successfully', tag: 'DI');
  AppLogger.divider();
}

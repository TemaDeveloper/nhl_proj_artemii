import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend_nhl/config/routes/app_router.dart';
import 'package:frontend_nhl/di/injector_container.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize dependencies
  await initDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  //AppRouter get _appRouter => GetIt.instance<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NHL Scores',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
      builder: (context, child) {
        return ColoredBox(
          color: Colors.red,
          child: child,
        );
      },
      routerConfig: AppRouter().config(),
    );
  }
}

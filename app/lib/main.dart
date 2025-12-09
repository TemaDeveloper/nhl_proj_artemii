import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend_nhl/config/routes/app_router.dart';
import 'package:frontend_nhl/core/theme/app_theme.dart';
import 'package:frontend_nhl/di/injector_container.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NHL Scores',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
      routerConfig: AppRouter().config(),
    );
  }
}

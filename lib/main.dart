import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_config.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. AppConfig initialization (handled by flavor mains, but safety check here)
  try {
    AppConfig.instance;
  } catch (_) {
    AppConfig(
      appTitle: 'StreakSky',
      flavor: AppFlavor.dev,
      apiBaseUrl: 'http://localhost:3000',
      supabaseUrl: 'https://dev-project.supabase.co',
      supabaseAnonKey: 'dev-anon-key',
    );
  }

  // 2. Initialize Dependency Injection
  await configureDependencies();

  // 3. Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.instance.supabaseUrl,
    anonKey: AppConfig.instance.supabaseAnonKey,
  );

  // 4. Initialize Firebase (Note: Requires firebase_options.dart in a real setup)
  // For now, we wrap in try-catch to avoid crash if options are missing during dev setup
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed (likely missing options): $e');
  }

  runApp(
    const ProviderScope(
      child: StreakSkyApp(),
    ),
  );
}

class StreakSkyApp extends StatelessWidget {
  const StreakSkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.instance.appTitle,
      debugShowCheckedModeBanner: AppConfig.instance.flavor == AppFlavor.dev,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark as per PRD
      routerConfig: AppRouter.router,
    );
  }
}

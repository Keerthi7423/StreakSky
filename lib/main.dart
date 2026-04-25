import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_config.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

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
      supabaseUrl: 'https://fwwcbiskdyunwtuzwstj.supabase.co',
      supabaseAnonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3d2NiaXNrZHl1bnd0dXp3c3RqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxMTU3MTksImV4cCI6MjA5MjY5MTcxOX0.bQCELUv6d5LvPM33jKrSRS6BsOwIUJkH6TSQj0gVATQ',
    );
  }

  // 2. Initialize Dependency Injection
  await configureDependencies();

  // 3. Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.instance.supabaseUrl,
    anonKey: AppConfig.instance.supabaseAnonKey,
  );

  // 4. Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }


  runApp(
    const ProviderScope(
      child: StreakSkyApp(),
    ),
  );
}

class StreakSkyApp extends ConsumerWidget {
  const StreakSkyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConfig.instance.appTitle,
      debugShowCheckedModeBanner: AppConfig.instance.flavor == AppFlavor.dev,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark as per PRD
      routerConfig: router,
    );
  }
}


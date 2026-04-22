import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'app_config.dart';

void main() {
  // If main() is called directly (e.g. from tests or flutter run), 
  // ensure AppConfig is initialized with a default if not already.
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
  
  runApp(const StreakSkyApp());
}

class StreakSkyApp extends StatelessWidget {
  const StreakSkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.instance.appTitle,
      debugShowCheckedModeBanner: AppConfig.instance.flavor == AppFlavor.dev,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark as per PRD
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_queue,
                size: 80,
                color: Color(0xFFB3FF00),
              ),
              SizedBox(height: 20),
              Text(
                'STREAKSKY',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              Text(
                'Your habits. Your weather. Your legacy.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA0A0A0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

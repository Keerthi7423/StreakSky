import 'package:flutter/material.dart';
import 'app_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig(
    appTitle: 'StreakSky Staging',
    flavor: AppFlavor.staging,
    apiBaseUrl: 'https://staging-api.streaksky.app',
    supabaseUrl: 'https://staging-project.supabase.co',
    supabaseAnonKey: 'staging-anon-key',
  );
  
  app.main();
}

import 'package:flutter/material.dart';
import 'app_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig(
    appTitle: 'StreakSky DEV',
    flavor: AppFlavor.dev,
    apiBaseUrl: 'http://localhost:3000',
    supabaseUrl: 'https://dev-project.supabase.co',
    supabaseAnonKey: 'dev-anon-key',
  );
  
  app.main();
}

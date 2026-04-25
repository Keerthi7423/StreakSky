import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_config.dart';
import 'main.dart' as app;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  AppConfig(
    appTitle: 'StreakSky DEV',
    flavor: AppFlavor.dev,
    apiBaseUrl: 'http://localhost:3000',
    supabaseUrl: dotenv.env['SUPABASE_URL'] ?? '',
    supabaseAnonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  
  app.main();
}

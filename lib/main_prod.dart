import 'app_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig(
    appTitle: 'StreakSky',
    flavor: AppFlavor.prod,
    apiBaseUrl: 'https://api.streaksky.app',
    supabaseUrl: 'https://project.supabase.co',
    supabaseAnonKey: 'prod-anon-key',
  );
  
  app.main();
}

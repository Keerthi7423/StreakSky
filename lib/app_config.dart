enum AppFlavor { dev, staging, prod }

class AppConfig {
  final String appTitle;
  final AppFlavor flavor;
  final String apiBaseUrl;
  final String supabaseUrl;
  final String supabaseAnonKey;

  static AppConfig? _instance;

  factory AppConfig({
    required String appTitle,
    required AppFlavor flavor,
    required String apiBaseUrl,
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) {
    _instance ??= AppConfig._internal(
      appTitle: appTitle,
      flavor: flavor,
      apiBaseUrl: apiBaseUrl,
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
    );
    return _instance!;
  }

  AppConfig._internal({
    required this.appTitle,
    required this.flavor,
    required this.apiBaseUrl,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig has not been initialized. Call initialize() first.');
    }
    return _instance!;
  }
}

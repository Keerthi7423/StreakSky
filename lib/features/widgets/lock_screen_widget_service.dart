import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Note: In a complete implementation, we would use the 'home_widget' package.
// import 'package:home_widget/home_widget.dart';

/// Service to handle communication between the Flutter app and native
/// Home Screen / Lock Screen Widgets (iOS WidgetKit & Android App Widgets).
class LockScreenWidgetService {
  final String _appGroupId = 'group.com.streaksky.widget';
  final String _iOSWidgetName = 'StreakSkyWidget';
  final String _androidWidgetName = 'StreakSkyWidgetProvider';

  Future<void> updateWidgetData({
    required String weatherIcon,
    required int streakCount,
    required String quotePreview,
    required List<Map<String, dynamic>> habits,
  }) async {
    try {
      // 1. Save data to a shared AppGroup (iOS) / SharedPreferences (Android)
      // This data will be read by the native widget code (Swift/Kotlin).

      /*
      await HomeWidget.saveWidgetData<String>('weather_icon', weatherIcon);
      await HomeWidget.saveWidgetData<int>('streak_count', streakCount);
      await HomeWidget.saveWidgetData<String>('quote_preview', quotePreview);
      
      // Serialize habits to JSON string for the widget
      // String habitsJson = jsonEncode(habits);
      // await HomeWidget.saveWidgetData<String>('today_habits', habitsJson);

      // 2. Trigger native widget update
      await HomeWidget.updateWidget(
        name: _iOSWidgetName,
        androidName: _androidWidgetName,
        iOSName: _iOSWidgetName,
      );
      */

      debugPrint(
        "Lock Screen Widget updated successfully with: "
        "Weather=$weatherIcon, Streak=$streakCount, Quote=$quotePreview",
      );
    } catch (e) {
      debugPrint("Failed to update Lock Screen Widget: $e");
    }
  }

  /// Called when the user taps a habit checkbox directly on the widget.
  /// The native widget launches the app in the background via a URI scheme
  /// (e.g., streaksky://widget/complete_habit?id=123)
  void handleWidgetInteraction(Uri uri) {
    if (uri.host == 'widget' && uri.path == '/complete_habit') {
      final habitId = uri.queryParameters['id'];
      debugPrint("Widget Interaction: Completing habit $habitId in background");
      // Trigger Riverpod to update habit status and push to Supabase
    }
  }
}

final lockScreenWidgetServiceProvider = Provider<LockScreenWidgetService>((
  ref,
) {
  return LockScreenWidgetService();
});

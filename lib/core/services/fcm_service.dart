import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Top-level background message handler for FCM
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
  
  if (message.data['type'] == 'streak_danger') {
    // We could potentially trigger local notifications or Hive updates here
    debugPrint("Streak Danger Alert received in background!");
  }
}

/// Service to handle Firebase Cloud Messaging (FCM) operations.
/// Specifically configured for server-triggered "Streak Danger" alerts.
class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // 1. Request permissions (required for iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permissions');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    // 2. Get the FCM token (for server to target this specific device)
    String? token = await _messaging.getToken();
    debugPrint("FCM Token: $token");
    // In a real app, send this token to Supabase/Azure to link with the user profile

    // 3. Listen to token refreshes
    _messaging.onTokenRefresh.listen((newToken) {
      // Send newToken to backend
    });

    // 4. Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.notification?.title}');
      
      if (message.data['type'] == 'streak_danger') {
        // Trigger an in-app alert or banner via Riverpod/state management
        debugPrint("DANGER: You are about to lose your streak!");
      }
    });

    // 5. Setup background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

final fcmServiceProvider = Provider<FcmService>((ref) {
  return FcmService();
});

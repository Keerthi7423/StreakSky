import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteConfigServiceProvider = Provider<RemoteConfigService>((ref) {
  return RemoteConfigService();
});

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      await _remoteConfig.setDefaults(const {
        'subscription_monthly_price': 299,
        'subscription_yearly_price': 1999,
        'kill_switch_active': false,
        'maintenance_mode': false,
      });

      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Remote Config fetch failed: $e');
    }
  }

  int get monthlyPrice => _remoteConfig.getInt('subscription_monthly_price');
  int get yearlyPrice => _remoteConfig.getInt('subscription_yearly_price');
  // Emergency Toggles
  bool get killSwitchActive => _remoteConfig.getBool('kill_switch_active');
  bool get maintenanceMode => _remoteConfig.getBool('maintenance_mode');
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:streaksky/features/auth/presentation/controllers/auth_controller.dart';
import 'package:streaksky/features/subscription/data/repositories/subscription_repository.dart';
import 'package:streaksky/features/subscription/domain/models/subscription_status.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(Supabase.instance.client);
});

final subscriptionStatusProvider = FutureProvider<SubscriptionStatus?>((ref) async {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) return null;

  final repo = ref.watch(subscriptionRepositoryProvider);
  return repo.getSubscription(user.uid);
});

final isProProvider = Provider<bool>((ref) {
  final statusAsync = ref.watch(subscriptionStatusProvider);
  return statusAsync.maybeWhen(
    data: (status) => status?.isPro ?? false,
    orElse: () => false,
  );
});

final subscriptionControllerProvider = Provider<SubscriptionController>((ref) {
  return SubscriptionController(ref);
});

class SubscriptionController {
  final Ref _ref;

  SubscriptionController(this._ref);

  Future<void> upgradeToPro(String planType) async {
    final user = _ref.read(authStateProvider).asData?.value;
    if (user == null) throw Exception("User not logged in");

    final repo = _ref.read(subscriptionRepositoryProvider);
    await repo.upgradeToProMock(user.uid, planType);
    _ref.invalidate(subscriptionStatusProvider);
  }
}

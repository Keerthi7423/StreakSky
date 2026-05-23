import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:streaksky/features/subscription/domain/models/subscription_status.dart';

class SubscriptionRepository {
  final SupabaseClient _supabase;

  SubscriptionRepository(this._supabase);

  Future<SubscriptionStatus?> getSubscription(String userId) async {
    try {
      final data = await _supabase
          .from('subscriptions')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      
      if (data == null) return null;
      return SubscriptionStatus.fromJson(data);
    } catch (e) {
      print('Error fetching subscription: $e');
      return null;
    }
  }

  Future<void> upgradeToProMock(String userId, String planType) async {
    // Check if subscription exists
    final exists = await _supabase
        .from('subscriptions')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    final validUntil = DateTime.now().add(
      planType == 'monthly' ? const Duration(days: 30) : const Duration(days: 365)
    );

    if (exists == null) {
      await _supabase.from('subscriptions').insert({
        'user_id': userId,
        'status': 'active',
        'plan_type': planType,
        'valid_until': validUntil.toIso8601String(),
      });
    } else {
      await _supabase.from('subscriptions').update({
        'status': 'active',
        'plan_type': planType,
        'valid_until': validUntil.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId);
    }
  }
}

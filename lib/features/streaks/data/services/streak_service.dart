import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/streak_model.dart';
import '../../domain/repositories/streak_repository.dart';

@LazySingleton(as: StreakRepository)
class StreakService implements StreakRepository {
  final SupabaseClient _supabase;

  StreakService(this._supabase);

  @override
  Future<StreakModel?> getStreak(String habitId) async {
    try {
      final response = await _supabase
          .from('streaks')
          .select()
          .eq('habit_id', habitId)
          .maybeSingle();

      if (response != null) {
        return StreakModel.fromJson(response);
      }
      return null;
    } catch (e) {
      // Local fallback logic would go here, e.g., read from Hive
      debugPrint('Error fetching streak: $e');
      return null;
    }
  }

  @override
  Future<List<StreakModel>> getAllStreaks(String userId) async {
    try {
      final response = await _supabase
          .from('streaks')
          .select()
          .eq('user_id', userId);

      return (response as List).map((e) => StreakModel.fromJson(e)).toList();
    } catch (e) {
      // Local fallback logic would go here
      return [];
    }
  }

  @override
  Future<void> updateStreak(StreakModel streak) async {
    try {
      await _supabase.from('streaks').upsert(streak.toJson());
    } catch (e) {
      // Offline fallback: save to Hive to sync later
      debugPrint('Error updating streak: $e');
    }
  }

  @override
  Future<void> recalculateStreak(String habitId) async {
    try {
      // Call Edge Function
      await _supabase.functions.invoke(
        'calculate_streak',
        body: {
          'habit_id': habitId,
          'date': DateTime.now().toIso8601String(),
          'action': 'recalculate', // Or whatever action triggered it
        },
      );
    } catch (e) {
      // Local recalculation fallback
      debugPrint('Edge function recalculate failed. Doing local calculation fallback.');
      final currentStreak = await getStreak(habitId);
      if (currentStreak != null) {
        // Apply basic local calculation here
        final newStreak = currentStreak.copyWith(
          currentStreak: currentStreak.currentStreak + 1,
          longestStreak: currentStreak.currentStreak + 1 > currentStreak.longestStreak
              ? currentStreak.currentStreak + 1
              : currentStreak.longestStreak,
          updatedAt: DateTime.now(),
        );
        await updateStreak(newStreak);
      }
    }
  }

  @override
  Future<void> syncOfflineStreaks() async {
    // Implement background sync logic from Hive to Supabase
  }
}

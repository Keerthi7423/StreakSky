import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/core/di/injection.dart';
import '../../domain/models/streak_model.dart';
import '../../domain/models/streak_milestone.dart';
import '../../domain/repositories/streak_repository.dart';

final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  return getIt<StreakRepository>();
});

final streakProvider = FutureProvider.family<StreakModel?, String>((ref, habitId) async {
  final repo = ref.watch(streakRepositoryProvider);
  return await repo.getStreak(habitId);
});

class StreakController extends StateNotifier<AsyncValue<void>> {
  final StreakRepository _repository;
  final Ref _ref;

  StreakController(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> handleCompletion(String habitId, String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentStreak = await _repository.getStreak(habitId);
      
      if (currentStreak == null) {
        // Create initial streak
        final newStreak = StreakModel(
          id: '', // Supabase will generate UUID
          habitId: habitId,
          userId: userId,
          currentStreak: 1,
          longestStreak: 1,
          lastActive: DateTime.now(),
          shieldsHeld: 0,
          updatedAt: DateTime.now(),
        );
        await _repository.updateStreak(newStreak);
      } else {
        // Update existing streak
        int newStreakCount = currentStreak.currentStreak + 1;
        int newLongestStreak = newStreakCount > currentStreak.longestStreak 
            ? newStreakCount 
            : currentStreak.longestStreak;
        
        int newShields = currentStreak.shieldsHeld;
        // Task 37: Earn 1 shield per 7-day run, Max 3
        if (newStreakCount % 7 == 0 && newShields < 3) {
          newShields++;
        }

        final updatedStreak = currentStreak.copyWith(
          currentStreak: newStreakCount,
          longestStreak: newLongestStreak,
          lastActive: DateTime.now(),
          shieldsHeld: newShields,
          updatedAt: DateTime.now(),
        );
        
        await _repository.updateStreak(updatedStreak);
        
        // Task 39: Milestone check (optional: could trigger animation/notification)
        final milestone = StreakMilestone.fromDays(newStreakCount);
        if (milestone != StreakMilestone.none && newStreakCount == milestone.days) {
          // Trigger milestone celebration event
          // For now we just log it, but in a real app this would trigger a UI event
          print('Milestone reached: ${milestone.label} ${milestone.emoji}');
        }
      }
      
      // Invalidate streak provider for this habit
      _ref.invalidate(streakProvider(habitId));
    });
  }

  Future<void> useShield(String habitId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentStreak = await _repository.getStreak(habitId);
      if (currentStreak != null && currentStreak.shieldsHeld > 0) {
        final updatedStreak = currentStreak.copyWith(
          shieldsHeld: currentStreak.shieldsHeld - 1,
          updatedAt: DateTime.now(),
        );
        await _repository.updateStreak(updatedStreak);
        _ref.invalidate(streakProvider(habitId));
      }
    });
  }
}

final streakControllerProvider = StateNotifierProvider<StreakController, AsyncValue<void>>((ref) {
  final repo = ref.watch(streakRepositoryProvider);
  return StreakController(repo, ref);
});

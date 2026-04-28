import '../models/streak_model.dart';

abstract class StreakRepository {
  Future<StreakModel?> getStreak(String habitId);
  Future<List<StreakModel>> getAllStreaks(String userId);
  Future<void> updateStreak(StreakModel streak);
  Future<void> recalculateStreak(String habitId);
  Future<void> syncOfflineStreaks();
}

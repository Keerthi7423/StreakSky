import 'package:flutter_test/flutter_test.dart';
import 'package:streaksky/core/utils/streak_date_utils.dart';
import 'package:streaksky/features/streaks/domain/models/streak_milestone.dart';

void main() {
  group('Task 47: Streak Freeze (Midnight Grace Period)', () {
    test('Should return previous day when current time is 00:15', () {
      final now = DateTime(2026, 5, 10, 0, 15); // May 10th, 12:15 AM
      final effectiveDate = StreakDateUtils.getEffectiveDate(now);
      
      expect(effectiveDate.day, 9);
      expect(effectiveDate.month, 5);
      expect(effectiveDate.year, 2026);
      expect(effectiveDate.hour, 23);
    });

    test('Should return current day when current time is 01:15', () {
      final now = DateTime(2026, 5, 10, 1, 15); // May 10th, 1:15 AM
      final effectiveDate = StreakDateUtils.getEffectiveDate(now);
      
      expect(effectiveDate.day, 10);
      expect(effectiveDate.hour, 1);
    });

    test('Should format date correctly as YYYY-MM-DD', () {
      final date = DateTime(2026, 5, 6);
      expect(StreakDateUtils.formatDate(date), '2026-05-06');
    });
  });

  group('Task 39 & 46: Streak Milestones', () {
    test('Milestone detection for various streak lengths', () {
      expect(StreakMilestone.fromDays(0), StreakMilestone.none);
      expect(StreakMilestone.fromDays(6), StreakMilestone.none);
      expect(StreakMilestone.fromDays(7), StreakMilestone.seedling);
      expect(StreakMilestone.fromDays(20), StreakMilestone.sprout); // 14-20 is sprout
      expect(StreakMilestone.fromDays(21), StreakMilestone.tree);
      expect(StreakMilestone.fromDays(30), StreakMilestone.onFire);
      expect(StreakMilestone.fromDays(100), StreakMilestone.unstoppable);
      expect(StreakMilestone.fromDays(365), StreakMilestone.diamond);
      expect(StreakMilestone.fromDays(1000), StreakMilestone.legend);
    });
  });

  group('Streak Engine Logic Stress Test Simulation', () {
    test('Simulating a 30-day streak with shield earning', () {
      int currentStreak = 0;
      int shields = 0;
      int milestonesReached = 0;

      for (int day = 1; day <= 30; day++) {
        currentStreak++;
        
        // Shield earning logic (Task 37)
        if (currentStreak % 7 == 0 && shields < 3) {
          shields++;
        }

        // Milestone logic (Task 39)
        final milestone = StreakMilestone.fromDays(currentStreak);
        if (milestone != StreakMilestone.none && currentStreak == milestone.days) {
          milestonesReached++;
        }
      }

      expect(currentStreak, 30);
      expect(shields, 3); // Earned at day 7, 14, 21. Max 3 reached.
      expect(milestonesReached, 4); // 7 (seedling), 14 (sprout), 21 (tree), 30 (onFire)
    });
  });
}

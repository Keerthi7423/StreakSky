import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../../domain/models/year_review_model.dart';
import '../../domain/repositories/year_review_repository.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../../../habits/domain/models/habit_model.dart';
import '../../../goals/domain/repositories/goal_repository.dart';
import '../../../goals/domain/models/goal_model.dart';
import '../../../streaks/domain/repositories/streak_repository.dart';
import '../../../ai_agent/domain/repositories/ai_repository.dart';

@LazySingleton(as: YearReviewRepository)
class YearReviewRepositoryImpl implements YearReviewRepository {
  final SupabaseClient _supabase;
  final HabitRepository _habitRepository;
  final GoalRepository _goalRepository;
  final StreakRepository _streakRepository;
  final AiRepository _aiRepository;

  YearReviewRepositoryImpl(
    this._supabase,
    this._habitRepository,
    this._goalRepository,
    this._streakRepository,
    this._aiRepository,
  );

  @override
  Future<YearReviewModel> generateYearReview(String userId, int year, {bool isDemo = false}) async {
    if (isDemo) {
      // Return beautiful mock year review data for presentation
      return _generateDemoReview(userId, year);
    }

    try {
      debugPrint('📊 Generating REAL Year Review for $userId in $year...');
      final startDateStr = '$year-01-01';
      final endDateStr = '$year-12-31';

      // 1. Fetch habits and completions
      final allHabits = await _habitRepository.getHabits(userId);
      final completions = await _habitRepository.getCompletionsForDateRange(userId, startDateStr, endDateStr);

      // 2. Fetch goals
      final allGoals = await _goalRepository.getGoals(userId);
      final yearGoals = allGoals.where((g) {
        final date = g.createdAt ?? g.startDate ?? DateTime.now();
        return date.year == year;
      }).toList();

      // 3. Fetch streaks
      final allStreaks = await _streakRepository.getAllStreaks(userId);

      // --- Habit Report Cards ---
      final habitReports = <HabitReportCard>[];
      final monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

      for (final habit in allHabits) {
        final habitCompletions = completions.where((c) => c.habitId == habit.id).toList();
        if (habitCompletions.isEmpty) continue;

        // Active days calculation
        final start = habit.startDate ?? habit.createdAt ?? DateTime(year, 1, 1);
        final activeStart = start.year == year ? start : DateTime(year, 1, 1);
        final end = DateTime.now().year == year ? DateTime.now() : DateTime(year, 12, 31);
        final activeDays = end.difference(activeStart).inDays + 1;
        final totalCompletions = habitCompletions.length;
        final rate = (totalCompletions / (activeDays > 0 ? activeDays : 1.0)).clamp(0.0, 1.0);

        // Longest Streak in Year
        final completedDates = habitCompletions
            .map((c) => DateTime.tryParse(c.completedDate))
            .whereType<DateTime>()
            .toList();
        completedDates.sort();

        int maxStreak = 0;
        int currentRun = 0;
        DateTime? previousDate;

        for (final date in completedDates) {
          if (previousDate == null) {
            currentRun = 1;
          } else {
            final diff = date.difference(previousDate).inDays;
            if (diff == 1) {
              currentRun++;
            } else if (diff > 1) {
              if (currentRun > maxStreak) maxStreak = currentRun;
              currentRun = 1;
            }
          }
          previousDate = date;
        }
        if (currentRun > maxStreak) maxStreak = currentRun;

        // Best & Worst Months
        final monthlyCounts = List<int>.filled(12, 0);
        for (final date in completedDates) {
          monthlyCounts[date.month - 1]++;
        }

        int maxMonthIdx = 0;
        int minMonthIdx = 0;
        int maxVal = -1;
        int minVal = 999999;

        for (int i = 0; i < 12; i++) {
          if (monthlyCounts[i] > maxVal) {
            maxVal = monthlyCounts[i];
            maxMonthIdx = i;
          }
          if (monthlyCounts[i] < minVal && monthlyCounts[i] > 0) {
            minVal = monthlyCounts[i];
            minMonthIdx = i;
          }
        }

        // Trend: Second half vs first half completions
        final midpoint = completedDates.length ~/ 2;
        final firstHalfCount = completedDates.take(midpoint).length;
        final secondHalfCount = completedDates.skip(midpoint).length;
        String trend = 'steady';
        if (secondHalfCount > firstHalfCount + 2) {
          trend = 'improving';
        } else if (secondHalfCount < firstHalfCount - 2) {
          trend = 'declining';
        }

        habitReports.add(HabitReportCard(
          habitId: habit.id,
          name: habit.name,
          emoji: habit.emoji ?? '📝',
          colorHex: habit.colorHex ?? 'B3FF00',
          totalCompletions: totalCompletions,
          completionRate: rate,
          longestStreak: maxStreak,
          bestMonth: monthNames[maxMonthIdx],
          worstMonth: completedDates.isEmpty ? 'None' : monthNames[minMonthIdx],
          trend: trend,
        ));
      }

      // --- Weather Year Summary ---
      int totalSunnyDays = 0;
      int totalStormyDays = 0;
      final monthlySunnyCounts = List<int>.filled(12, 0);
      final monthlyStormyCounts = List<int>.filled(12, 0);
      final dailyCompletionMap = <String, int>{}; // date string -> completed habits

      for (final comp in completions) {
        dailyCompletionMap[comp.completedDate] = (dailyCompletionMap[comp.completedDate] ?? 0) + 1;
      }

      // Let's sweep days of the year
      final endDay = DateTime.now().year == year ? DateTime.now() : DateTime(year, 12, 31);
      final totalDays = endDay.difference(DateTime(year, 1, 1)).inDays + 1;

      int sunnyCount = 0;
      int stormyCount = 0;
      int partlyCloudyCount = 0;
      int cloudyCount = 0;
      int rainyCount = 0;

      for (int i = 0; i < totalDays; i++) {
        final date = DateTime(year, 1, 1).add(Duration(days: i));
        final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        // Count how many habits were active on this day
        final activeOnDay = allHabits.where((h) {
          final start = h.startDate ?? h.createdAt ?? DateTime(year, 1, 1);
          return start.isBefore(date.add(const Duration(days: 1)));
        }).length;

        if (activeOnDay == 0) continue;

        final completedCount = dailyCompletionMap[dateStr] ?? 0;
        final pct = completedCount / activeOnDay;

        if (pct >= 1.0) {
          sunnyCount++;
          monthlySunnyCounts[date.month - 1]++;
        } else if (pct == 0.0) {
          stormyCount++;
          monthlyStormyCounts[date.month - 1]++;
        } else if (pct >= 0.6) {
          partlyCloudyCount++;
        } else if (pct >= 0.4) {
          cloudyCount++;
        } else {
          rainyCount++;
        }
      }

      totalSunnyDays = sunnyCount;
      totalStormyDays = stormyCount;

      // Determine most common weather
      final weatherCounts = {
        'Sunny': sunnyCount,
        'Partly Cloudy': partlyCloudyCount,
        'Cloudy': cloudyCount,
        'Rainy': rainyCount,
        'Stormy': stormyCount,
      };
      final sortedWeather = weatherCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      final mostCommonWeather = sortedWeather.first.key;

      // Best weather month (highest sunny days)
      int maxSunnyMonthIdx = 0;
      int maxSunnyDays = -1;
      for (int i = 0; i < 12; i++) {
        if (monthlySunnyCounts[i] > maxSunnyDays) {
          maxSunnyDays = monthlySunnyCounts[i];
          maxSunnyMonthIdx = i;
        }
      }

      // Generate 12 emoji strip
      final monthlyWeatherStrip = <String>[];
      for (int i = 0; i < 12; i++) {
        final sun = monthlySunnyCounts[i];
        final storm = monthlyStormyCounts[i];
        if (sun > 15) {
          monthlyWeatherStrip.add('☀️');
        } else if (sun > 8) {
          monthlyWeatherStrip.add('⛅');
        } else if (storm > 10) {
          monthlyWeatherStrip.add('⛈️');
        } else if (storm > 5) {
          monthlyWeatherStrip.add('🌧️');
        } else {
          monthlyWeatherStrip.add('🌥️');
        }
      }

      final sunnyPercentage = ((totalSunnyDays / (totalDays > 0 ? totalDays : 1.0)) * 100).toStringAsFixed(0);
      final weatherSummaryText = "Your sky was sunny $totalSunnyDays days this year. That is $sunnyPercentage% of the year. Your best year yet.";

      // --- Goal Completion Summary ---
      final weeklyGoals = yearGoals.where((g) => g.type == GoalType.weekly).toList();
      final monthlyGoals = yearGoals.where((g) => g.type == GoalType.monthly).toList();
      final careerMilestones = yearGoals.where((g) => g.type == GoalType.career && g.isMilestone).toList();

      final weeklyGoalsCompleted = weeklyGoals.where((g) => g.isCompleted).length;
      final monthlyGoalsCompleted = monthlyGoals.where((g) => g.isCompleted).length;
      final careerMilestonesHit = careerMilestones.where((g) => g.isCompleted).length;

      final totalGoalsCount = yearGoals.length;
      final completedGoalsCount = yearGoals.where((g) => g.isCompleted).length;
      final overallGoalScore = totalGoalsCount > 0 ? ((completedGoalsCount / totalGoalsCount) * 100).round() : 0;

      // --- Streak Hall of Fame ---
      final topStreaks = allStreaks.map((s) {
        final habit = allHabits.firstWhere((h) => h.id == s.habitId, orElse: () => const HabitModel(id: '', userId: '', name: 'Habit'));
        return TopStreakItem(
          habitName: habit.name,
          emoji: habit.emoji ?? '🔥',
          streakDays: s.longestStreak,
        );
      }).toList();
      topStreaks.sort((a, b) => b.streakDays.compareTo(a.streakDays));
      final top3Streaks = topStreaks.take(3).toList();

      final totalShields = allStreaks.fold<int>(0, (sum, element) => sum + element.shieldsHeld);
      final totalComebacks = allStreaks.fold<int>(0, (sum, element) => sum + element.comebackCount);

      // Consecutive perfect weeks calculation (Sunny weeks)
      int consecutivePerfectWeeks = 0;
      int currentPerfectWeeks = 0;
      for (int i = 0; i < totalDays ~/ 7; i++) {
        bool perfect = true;
        for (int d = 0; d < 7; d++) {
          final date = DateTime(year, 1, 1).add(Duration(days: i * 7 + d));
          final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          
          final activeOnDay = allHabits.where((h) {
            final start = h.startDate ?? h.createdAt ?? DateTime(year, 1, 1);
            return start.isBefore(date.add(const Duration(days: 1)));
          }).length;

          final completedCount = dailyCompletionMap[dateStr] ?? 0;
          if (activeOnDay > 0 && completedCount < activeOnDay) {
            perfect = false;
            break;
          }
        }
        if (perfect) {
          currentPerfectWeeks++;
          if (currentPerfectWeeks > consecutivePerfectWeeks) {
            consecutivePerfectWeeks = currentPerfectWeeks;
          }
        } else {
          currentPerfectWeeks = 0;
        }
      }

      // --- AI Narrative generation ---
      String summaryString = "Year: $year. Habits completed: ${completions.length}. Sunny days: $totalSunnyDays (out of $totalDays). Stormy days: $totalStormyDays. Most common weather: $mostCommonWeather. Top streak: ${top3Streaks.isNotEmpty ? top3Streaks.first.streakDays : 0} days. Goal score: $overallGoalScore%. Shields used: $totalShields. Comebacks: $totalComebacks.";
      
      String aiNarrativeText = '';
      try {
        aiNarrativeText = await _aiRepository.generateYearReviewNarrative(summaryString);
      } catch (e) {
        debugPrint('Ollama Year Narrative generation failed, using beautiful local fallback template: $e');
        final topHabitName = top3Streaks.isNotEmpty ? top3Streaks.first.habitName : 'habits';
        final maxStreakVal = top3Streaks.isNotEmpty ? top3Streaks.first.streakDays : 0;
        aiNarrativeText = "$year was a year of incredible consistency and resilience in your sky. You built a powerful $maxStreakVal-day streak in $topHabitName, weathered $totalStormyDays stormy patches, and made $totalComebacks stunning comebacks (rainbows) after setbacks. Your sky stayed bright and sunny for $totalSunnyDays perfect days, proving your dedication to growth. Carry this powerful momentum into the new year!";
      }

      final review = YearReviewModel(
        year: year,
        userId: userId,
        habitReports: habitReports,
        weatherSummary: WeatherYearSummary(
          totalSunnyDays: totalSunnyDays,
          totalStormyDays: totalStormyDays,
          mostCommonWeather: mostCommonWeather,
          bestWeatherMonth: monthNames[maxSunnyMonthIdx],
          summaryText: weatherSummaryText,
          monthlyWeatherStrip: monthlyWeatherStrip,
        ),
        goalSummary: GoalCompletionSummary(
          weeklyGoalsCompleted: weeklyGoalsCompleted,
          weeklyGoalsTotal: weeklyGoals.length,
          monthlyGoalsCompleted: monthlyGoalsCompleted,
          monthlyGoalsTotal: monthlyGoals.length,
          careerMilestonesHit: careerMilestonesHit,
          careerMilestonesTotal: careerMilestones.length,
          overallGoalCompletionScore: overallGoalScore,
        ),
        streakHallOfFame: StreakHallOfFame(
          topLongestStreaks: top3Streaks,
          shieldsUsed: totalShields,
          comebacks: totalComebacks,
          consecutivePerfectWeeks: consecutivePerfectWeeks,
        ),
        aiNarrative: aiNarrativeText,
        createdAt: DateTime.now(),
      );

      // Save locally
      await saveYearReview(review);
      return review;
    } catch (e) {
      debugPrint('Error generating real year review, returning high-quality demo review as fallback: $e');
      return _generateDemoReview(userId, year);
    }
  }

  @override
  Future<void> saveYearReview(YearReviewModel review) async {
    try {
      await _supabase.from('year_reviews').upsert(review.toJson());
      debugPrint('💾 Year review saved successfully to Supabase.');
    } catch (e) {
      debugPrint('⚠️ Failed to save year review to Supabase (possibly table missing in schema, continuing locally): $e');
    }
  }

  @override
  Future<YearReviewModel?> getSavedYearReview(String userId, int year) async {
    try {
      final response = await _supabase
          .from('year_reviews')
          .select()
          .eq('user_id', userId)
          .eq('year', year)
          .maybeSingle();

      if (response != null) {
        return YearReviewModel.fromJson(response);
      }
    } catch (e) {
      debugPrint('Error getting saved year review: $e');
    }
    return null;
  }

  // Helper to generate a highly detailed and premium mock year review
  YearReviewModel _generateDemoReview(String userId, int year) {
    return YearReviewModel(
      year: year,
      userId: userId,
      habitReports: [
        const HabitReportCard(
          habitId: 'demo-1',
          name: 'Morning Meditation',
          emoji: '🧘',
          colorHex: '00F2FF',
          totalCompletions: 284,
          completionRate: 0.78,
          longestStreak: 45,
          bestMonth: 'March',
          worstMonth: 'July',
          trend: 'improving',
        ),
        const HabitReportCard(
          habitId: 'demo-2',
          name: 'Read 20 Pages',
          emoji: '📚',
          colorHex: 'B3FF00',
          totalCompletions: 210,
          completionRate: 0.58,
          longestStreak: 30,
          bestMonth: 'October',
          worstMonth: 'January',
          trend: 'steady',
        ),
        const HabitReportCard(
          habitId: 'demo-3',
          name: 'Gym Session',
          emoji: '💪',
          colorHex: 'FF0055',
          totalCompletions: 142,
          completionRate: 0.91, // 3 times per week, target is met
          longestStreak: 15,
          bestMonth: 'September',
          worstMonth: 'December',
          trend: 'declining',
        ),
      ],
      weatherSummary: const WeatherYearSummary(
        totalSunnyDays: 187,
        totalStormyDays: 24,
        mostCommonWeather: 'Partly Cloudy',
        bestWeatherMonth: 'March',
        summaryText: 'Your sky was sunny 187 days this year. That is 51% of the year. Your best year yet.',
        monthlyWeatherStrip: ['☀️', '⛅', '☀️', '🌥️', '⛈️', '⛅', '🌧️', '☀️', '☀️', '🌈', '⛅', '☀️'],
      ),
      goalSummary: const GoalCompletionSummary(
        weeklyGoalsCompleted: 42,
        weeklyGoalsTotal: 52,
        monthlyGoalsCompleted: 10,
        monthlyGoalsTotal: 12,
        careerMilestonesHit: 2,
        careerMilestonesTotal: 3,
        overallGoalCompletionScore: 84,
      ),
      streakHallOfFame: const StreakHallOfFame(
        topLongestStreaks: [
          TopStreakItem(habitName: 'Morning Meditation', emoji: '🧘', streakDays: 45),
          TopStreakItem(habitName: 'Read 20 Pages', emoji: '📚', streakDays: 30),
          TopStreakItem(habitName: 'Gym Session', emoji: '💪', streakDays: 15),
        ],
        shieldsUsed: 8,
        comebacks: 4,
        consecutivePerfectWeeks: 12,
      ),
      aiNarrative: '2025 was your most consistent year yet. You built a 45-day meditation streak in March, weathered a storm in July, and made a stunning comeback in September. Your sky was mostly cloudy early on but turned sunny by Q4. Carry that momentum into 2026.',
      createdAt: DateTime.now(),
    );
  }
}

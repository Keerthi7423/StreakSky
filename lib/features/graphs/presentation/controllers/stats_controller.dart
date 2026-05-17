import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/streak_date_utils.dart';
import '../../../heatmap/presentation/controllers/heatmap_controller.dart';
import '../../../streaks/presentation/controllers/streak_controller.dart';
import 'package:intl/intl.dart';
import '../../../habits/presentation/controllers/habit_controller.dart';
import '../../../habits/data/services/habit_local_service.dart';
import '../../../../core/di/injection.dart';
import '../../../habits/domain/models/habit_model.dart';
import '../../../habits/domain/models/habit_completion_model.dart';

class StatsSummary {
  final int totalHabitsDone;
  final int currentStreak;
  final int bestStreak;
  final double completionRate;
  final List<double> weeklyTrend; // Last 7 days completion counts
  final List<double> monthlyTrend; // Last 30 days completion counts
  final List<double> careerTrend; // Last 12 months completion counts (or similar)
  final String? keystoneHabit;
  final double keystoneCorrelation;
  final List<List<double>> miniWaveforms; // One for each stat card
  final List<RecentHabitLog> recentHabits;

  StatsSummary({
    required this.totalHabitsDone,
    required this.currentStreak,
    required this.bestStreak,
    required this.completionRate,
    required this.weeklyTrend,
    required this.monthlyTrend,
    required this.careerTrend,
    this.keystoneHabit,
    this.keystoneCorrelation = 0.0,
    required this.miniWaveforms,
    required this.recentHabits,
  });
}

class RecentHabitLog {
  final String habitName;
  final String emoji;
  final String colorHex;
  final String completedAt;

  RecentHabitLog({
    required this.habitName,
    required this.emoji,
    required this.colorHex,
    required this.completedAt,
  });
}

final statsProvider = Provider<StatsSummary>((ref) {
  final heatmapState = ref.watch(heatmapControllerProvider);
  final leaderboard = ref.watch(leaderboardProvider).asData?.value ?? [];
  
  // Calculate total habits done
  int totalDone = 0;
  heatmapState.dailyCompletionCounts.forEach((_, count) => totalDone += count.toInt());

  // Best streak from leaderboard
  int bestStreak = 0;
  int currentStreak = 0;
  if (leaderboard.isNotEmpty) {
    bestStreak = leaderboard.fold(0, (max, s) => s.longestStreak > max ? s.longestStreak : max);
    currentStreak = leaderboard.fold(0, (max, s) => s.currentStreak > max ? s.currentStreak : max);
  }

  // Weekly trend (Last 7 days)
  final List<double> weeklyTrend = [];
  final now = DateTime.now();
  for (int i = 6; i >= 0; i--) {
    final date = now.subtract(Duration(days: i));
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    weeklyTrend.add((heatmapState.dailyCompletionCounts[dateStr] ?? 0).toDouble());
  }

  // Monthly trend (Last 30 days)
  final List<double> monthlyTrend = [];
  for (int i = 29; i >= 0; i--) {
    final date = now.subtract(Duration(days: i));
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    monthlyTrend.add((heatmapState.dailyCompletionCounts[dateStr] ?? 0).toDouble());
  }

  // Career trend (Last 6 months - summarized)
  final List<double> careerTrend = [120, 150, 180, 140, 210, 195]; // Mocked monthly totals

  // Keystone Habit Logic (Mocked for now as we don't have per-habit historical data easily accessible here)
  // In a real app, you'd analyze which habit's completion most often predicts other completions.
  final keystoneHabit = "Early Rising";
  final keystoneCorrelation = 0.85;

  // Completion rate (Total completed / Total possible)
  final activeDays = heatmapState.dailyCompletionCounts.values.where((c) => c > 0).length;
  final dayOfYear = int.parse(DateFormat('D').format(now));
  final completionRate = dayOfYear > 0 ? activeDays / dayOfYear : 0.0;

  // Mock waveforms for mini charts
  final List<List<double>> miniWaveforms = [
    [0.2, 0.5, 0.4, 0.8, 0.6, 0.9, 0.7], // Habits Done
    [0.1, 0.3, 0.2, 0.5, 0.4, 0.6, 0.5], // Streak
    [0.5, 0.4, 0.6, 0.3, 0.7, 0.5, 0.8], // Completion Rate
    [0.3, 0.6, 0.4, 0.7, 0.5, 0.8, 0.6], // Best Streak
  ];

  // Fetch recent habits (Task 77)
  final localService = getIt<HabitLocalService>();
  final List<HabitCompletionModel> recentCompletions = localService.getRecentCompletions(3);
  final allHabits = ref.watch(habitsListProvider).asData?.value ?? [];
  
  print('StatsProvider: recentCompletions count: ${recentCompletions.length}');
  print('StatsProvider: allHabits count: ${allHabits.length}');
  
  try {
    final List<RecentHabitLog> recentHabits = recentCompletions.map<RecentHabitLog>((c) {
      final habit = allHabits.firstWhere((h) => h.id == c.habitId, orElse: () => HabitModel(
        id: 'unknown', userId: '', name: 'Unknown Habit', emoji: '❓', colorHex: '808080'
      ));
      return RecentHabitLog(
        habitName: habit.name,
        emoji: habit.emoji ?? '✨',
        colorHex: habit.colorHex ?? 'B3FF00',
        completedAt: c.completedAt != null 
            ? DateFormat('MMM d, HH:mm').format(c.completedAt!)
            : (c.completedDate.isNotEmpty 
                ? DateFormat('MMM d').format(DateTime.tryParse(c.completedDate) ?? DateTime.now())
                : 'Recent'),
      );
    }).toList();

    print('StatsProvider: recentHabits processed, count: ${recentHabits.length}');

    final summary = StatsSummary(
      totalHabitsDone: totalDone,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      completionRate: completionRate,
      weeklyTrend: weeklyTrend,
      monthlyTrend: monthlyTrend,
      careerTrend: careerTrend,
      keystoneHabit: keystoneHabit,
      keystoneCorrelation: keystoneCorrelation,
      miniWaveforms: miniWaveforms,
      recentHabits: recentHabits,
    );
    print('StatsProvider: Successfully created StatsSummary');
    return summary;
  } catch (e, stack) {
    print('StatsProvider ERROR: $e');
    print('StatsProvider STACK: $stack');
    // Return a default summary to avoid red screen
    return StatsSummary(
      totalHabitsDone: 0,
      currentStreak: 0,
      bestStreak: 0,
      completionRate: 0,
      weeklyTrend: [],
      monthlyTrend: [],
      careerTrend: [],
      miniWaveforms: [[], [], [], []],
      recentHabits: [],
    );
  }
});

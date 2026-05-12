import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/streak_date_utils.dart';
import '../../../heatmap/presentation/controllers/heatmap_controller.dart';
import '../../../streaks/presentation/controllers/streak_controller.dart';
import 'package:intl/intl.dart';

class StatsSummary {
  final int totalHabitsDone;
  final int currentStreak;
  final int bestStreak;
  final double completionRate;
  final List<double> weeklyTrend; // Last 7 days completion counts
  final List<List<double>> miniWaveforms; // One for each stat card

  StatsSummary({
    required this.totalHabitsDone,
    required this.currentStreak,
    required this.bestStreak,
    required this.completionRate,
    required this.weeklyTrend,
    required this.miniWaveforms,
  });
}

final statsProvider = Provider<StatsSummary>((ref) {
  final heatmapState = ref.watch(heatmapControllerProvider);
  final leaderboard = ref.watch(leaderboardProvider).asData?.value ?? [];
  
  // Calculate total habits done
  int totalDone = 0;
  heatmapState.dailyCompletionCounts.forEach((_, count) => totalDone += count);

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

  // Completion rate (Total completed / Total possible)
  // For simplicity, we'll use active days / total days in year so far
  final activeDays = heatmapState.dailyCompletionCounts.values.where((c) => c > 0).length;
  final dayOfYear = int.parse(DateFormat('D').format(now));
  final completionRate = dayOfYear > 0 ? activeDays / dayOfYear : 0.0;

  // Mock waveforms for mini charts (Task 72)
  // In a real app, these would be based on historical data for each specific metric
  final List<List<double>> miniWaveforms = [
    [0.2, 0.5, 0.4, 0.8, 0.6, 0.9, 0.7], // Habits Done
    [0.1, 0.3, 0.2, 0.5, 0.4, 0.6, 0.5], // Streak
    [0.5, 0.4, 0.6, 0.3, 0.7, 0.5, 0.8], // Completion Rate
    [0.3, 0.6, 0.4, 0.7, 0.5, 0.8, 0.6], // Best Streak
  ];

  return StatsSummary(
    totalHabitsDone: totalDone,
    currentStreak: currentStreak,
    bestStreak: bestStreak,
    completionRate: completionRate,
    weeklyTrend: weeklyTrend,
    miniWaveforms: miniWaveforms,
  );
});

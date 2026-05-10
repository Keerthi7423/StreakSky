import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../../../habits/domain/models/habit_completion_model.dart';
import '../../../../core/services/analytics_service.dart';
import 'package:streaksky/core/di/injection.dart';
import 'package:streaksky/features/auth/presentation/controllers/auth_controller.dart';
import 'package:streaksky/features/habits/presentation/controllers/habit_controller.dart';
import '../../../../core/utils/streak_date_utils.dart';

class HeatmapState {
  final int selectedYear;
  final Map<String, int> dailyCompletionCounts; // date -> count
  final Map<String, double> dailyCompletionPercentages; // date -> %
  final Set<String> comebackDates;
  final bool isLoading;

  HeatmapState({
    required this.selectedYear,
    required this.dailyCompletionCounts,
    required this.dailyCompletionPercentages,
    required this.comebackDates,
    this.isLoading = false,
  });

  HeatmapState copyWith({
    int? selectedYear,
    Map<String, int>? dailyCompletionCounts,
    Map<String, double>? dailyCompletionPercentages,
    Set<String>? comebackDates,
    bool? isLoading,
  }) {
    return HeatmapState(
      selectedYear: selectedYear ?? this.selectedYear,
      dailyCompletionCounts: dailyCompletionCounts ?? this.dailyCompletionCounts,
      dailyCompletionPercentages: dailyCompletionPercentages ?? this.dailyCompletionPercentages,
      comebackDates: comebackDates ?? this.comebackDates,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final heatmapControllerProvider = StateNotifierProvider<HeatmapController, HeatmapState>((ref) {
  final repo = ref.watch(habitRepositoryProvider);
  return HeatmapController(repo, ref);
});

class HeatmapController extends StateNotifier<HeatmapState> {
  final HabitRepository _habitRepository;
  final Ref _ref;

  HeatmapController(this._habitRepository, this._ref)
      : super(HeatmapState(
          selectedYear: DateTime.now().year,
          dailyCompletionCounts: {},
          dailyCompletionPercentages: {},
          comebackDates: {},
        )) {
    loadHeatmapData();
  }

  void changeYear(int year) {
    state = state.copyWith(selectedYear: year, isLoading: true);
    loadHeatmapData();
  }

  Future<void> loadHeatmapData() async {
    final user = _ref.read(authStateProvider).asData?.value;
    final isDemo = _ref.read(demoLoggedInProvider);
    
    if (user == null && !isDemo) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final userId = user?.uid ?? 'demo-user';
    state = state.copyWith(isLoading: true);
    
    try {
      final startDate = '${state.selectedYear}-01-01';
      final endDate = '${state.selectedYear}-12-31';
      
      final habits = await _habitRepository.getHabits(userId);
      final completions = await _habitRepository.getCompletionsForDateRange(userId, startDate, endDate);
      
      // Group completions by date
      final Map<String, int> counts = {};
      for (var comp in completions) {
        counts[comp.completedDate] = (counts[comp.completedDate] ?? 0) + 1;
      }
      
      // Calculate percentages based on active habits for each day
      final Map<String, double> percentages = {};
      final Set<String> comebacks = {};
      
      final totalHabits = habits.length;
      if (totalHabits > 0) {
        for (var date in counts.keys) {
          percentages[date] = counts[date]! / totalHabits;
        }
      }

      // Detect comebacks (100% after a 0% day)
      bool previousWasZero = false;
      final firstDay = DateTime(state.selectedYear, 1, 1);
      final lastDay = DateTime(state.selectedYear, 12, 31);
      
      for (int i = 0; i <= lastDay.difference(firstDay).inDays; i++) {
        final currentDay = firstDay.add(Duration(days: i));
        final dateStr = StreakDateUtils.formatDate(currentDay);
        
        final count = counts[dateStr] ?? 0;
        final percentage = totalHabits > 0 ? count / totalHabits : 0.0;
        
        if (percentage >= 1.0 && previousWasZero) {
          comebacks.add(dateStr);
        }
        
        previousWasZero = (count == 0);
      }

      state = state.copyWith(
        dailyCompletionCounts: counts,
        dailyCompletionPercentages: percentages,
        comebackDates: comebacks,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('Error loading heatmap data: $e');
    }
  }
}

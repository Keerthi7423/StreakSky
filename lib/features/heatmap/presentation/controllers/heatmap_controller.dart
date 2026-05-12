import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../../../habits/domain/models/habit_completion_model.dart';
import '../../../habits/domain/models/habit_model.dart';
import '../../../../core/services/analytics_service.dart';
import 'package:streaksky/core/di/injection.dart';
import 'package:streaksky/features/auth/presentation/controllers/auth_controller.dart';
import 'package:streaksky/features/habits/presentation/controllers/habit_controller.dart';
import '../../../../core/utils/streak_date_utils.dart';

class HeatmapState {
  final int selectedYear;
  final String? selectedHabitId;
  final bool isMultiYearView;
  final List<HabitModel> habits;
  final Map<String, int> dailyCompletionCounts; // date -> count
  final Map<String, double> dailyCompletionPercentages; // date -> %
  final Set<String> comebackDates;
  final Map<int, Map<String, double>> multiYearPercentages; // year -> (date -> %)
  final bool isLoading;

  HeatmapState({
    required this.selectedYear,
    this.selectedHabitId,
    this.isMultiYearView = false,
    this.habits = const [],
    required this.dailyCompletionCounts,
    required this.dailyCompletionPercentages,
    required this.comebackDates,
    this.multiYearPercentages = const {},
    this.isLoading = false,
  });

  HeatmapState copyWith({
    int? selectedYear,
    String? selectedHabitId,
    bool? isMultiYearView,
    List<HabitModel>? habits,
    Map<String, int>? dailyCompletionCounts,
    Map<String, double>? dailyCompletionPercentages,
    Set<String>? comebackDates,
    Map<int, Map<String, double>>? multiYearPercentages,
    bool? isLoading,
  }) {
    return HeatmapState(
      selectedYear: selectedYear ?? this.selectedYear,
      selectedHabitId: selectedHabitId, // Allow null to clear selection
      isMultiYearView: isMultiYearView ?? this.isMultiYearView,
      habits: habits ?? this.habits,
      dailyCompletionCounts: dailyCompletionCounts ?? this.dailyCompletionCounts,
      dailyCompletionPercentages: dailyCompletionPercentages ?? this.dailyCompletionPercentages,
      comebackDates: comebackDates ?? this.comebackDates,
      multiYearPercentages: multiYearPercentages ?? this.multiYearPercentages,
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

  void selectHabit(String? habitId) {
    state = state.copyWith(selectedHabitId: habitId, isLoading: true);
    loadHeatmapData();
  }

  void toggleMultiYearView() {
    state = state.copyWith(isMultiYearView: !state.isMultiYearView, isLoading: true);
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
    
    try {
      final habits = await _habitRepository.getHabits(userId);
      
      if (state.isMultiYearView) {
        await _loadMultiYearData(userId, habits);
      } else {
        await _loadSingleYearData(userId, habits, state.selectedYear);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('Error loading heatmap data: $e');
    }
  }

  Future<void> _loadSingleYearData(String userId, List<HabitModel> habits, int year) async {
    final startDate = '$year-01-01';
    final endDate = '$year-12-31';
    
    final completions = await _habitRepository.getCompletionsForDateRange(userId, startDate, endDate);
    
    // Filter completions by selected habit if applicable
    final filteredCompletions = state.selectedHabitId != null
        ? completions.where((c) => c.habitId == state.selectedHabitId).toList()
        : completions;

    // Group completions by date
    final Map<String, int> counts = {};
    for (var comp in filteredCompletions) {
      counts[comp.completedDate] = (counts[comp.completedDate] ?? 0) + 1;
    }
    
    // Calculate percentages
    final Map<String, double> percentages = {};
    final Set<String> comebacks = {};
    
    // If filtering by habit, total is 1. If global, total is number of active habits.
    final totalDenominator = state.selectedHabitId != null ? 1 : habits.length;
    
    if (totalDenominator > 0) {
      for (var date in counts.keys) {
        percentages[date] = counts[date]! / totalDenominator;
      }
    }

    // Detect comebacks (100% after a 0% day)
    bool previousWasZero = false;
    final firstDay = DateTime(year, 1, 1);
    final lastDay = DateTime(year, 12, 31);
    
    for (int i = 0; i <= lastDay.difference(firstDay).inDays; i++) {
      final currentDay = firstDay.add(Duration(days: i));
      final dateStr = StreakDateUtils.formatDate(currentDay);
      
      final count = counts[dateStr] ?? 0;
      final percentage = totalDenominator > 0 ? count / totalDenominator : 0.0;
      
      if (percentage >= 1.0 && previousWasZero) {
        comebacks.add(dateStr);
      }
      
      previousWasZero = (count == 0);
    }

    state = state.copyWith(
      habits: habits,
      dailyCompletionCounts: counts,
      dailyCompletionPercentages: percentages,
      comebackDates: comebacks,
      isLoading: false,
    );
  }

  Future<void> _loadMultiYearData(String userId, List<HabitModel> habits) async {
    final years = [2024, 2025, 2026];
    final Map<int, Map<String, double>> allYearPercentages = {};
    
    for (var year in years) {
      final startDate = '$year-01-01';
      final endDate = '$year-12-31';
      final completions = await _habitRepository.getCompletionsForDateRange(userId, startDate, endDate);
      
      final filteredCompletions = state.selectedHabitId != null
          ? completions.where((c) => c.habitId == state.selectedHabitId).toList()
          : completions;

      final Map<String, int> counts = {};
      for (var comp in filteredCompletions) {
        counts[comp.completedDate] = (counts[comp.completedDate] ?? 0) + 1;
      }

      final Map<String, double> percentages = {};
      final totalDenominator = state.selectedHabitId != null ? 1 : habits.length;
      
      if (totalDenominator > 0) {
        for (var date in counts.keys) {
          percentages[date] = counts[date]! / totalDenominator;
        }
      }
      allYearPercentages[year] = percentages;
    }

    state = state.copyWith(
      habits: habits,
      multiYearPercentages: allYearPercentages,
      isLoading: false,
    );
  }
}

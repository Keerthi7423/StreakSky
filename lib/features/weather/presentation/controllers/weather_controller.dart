import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/core/di/injection.dart';
import 'package:streaksky/features/auth/presentation/controllers/auth_controller.dart';
import 'package:streaksky/features/habits/data/services/habit_local_service.dart';
import 'package:streaksky/features/habits/domain/repositories/habit_repository.dart';
import 'package:streaksky/features/habits/presentation/controllers/habit_controller.dart';
import 'package:streaksky/features/streaks/presentation/controllers/streak_controller.dart';
import '../../domain/models/weather_model.dart';

final weatherProvider = FutureProvider<WeatherModel>((ref) async {
  final habits = await ref.watch(todaysHabitsProvider.future);
  final completions = await ref.watch(habitCompletionsProvider.future);
  final user = ref.watch(authStateProvider).asData?.value;
  final isDemo = ref.watch(demoLoggedInProvider);

  if (habits.isEmpty) {
    return WeatherModel(
      type: WeatherType.sunny,
      completionRate: 1.0,
      date: DateTime.now(),
      message: 'No habits scheduled for today. Enjoy the sun!',
    );
  }

  final completionRate = completions.length / habits.length;
  
  // Fetch historical data for Storm and Rainbow logic
  final localService = getIt<HabitLocalService>();
  final allHabits = await ref.watch(habitsListProvider.future);
  final now = DateTime.now();
  
  final pastRates = <double>[];
  for (int i = 1; i <= 3; i++) {
    final date = now.subtract(Duration(days: i));
    final dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final habitsDue = allHabits.where((h) => h.isDue(date)).toList();
    if (habitsDue.isEmpty) {
      pastRates.add(1.0); // Assume sunny if no habits due
    } else {
      final doneCount = localService.getCompletionsForDate(dateStr).length;
      pastRates.add(doneCount / habitsDue.length);
    }
  }

  // Check for Storm (Task 45: 0% for 3+ days)
  // PRD 7.5: Storm — 0% for 3+ days. 
  // We check if today is 0% and the last 2 days were also 0%.
  bool isStorm = completionRate == 0 && pastRates.take(2).every((r) => r == 0);
  
  // Check for Rainbow (Task 43: First flawless day after 0% storm)
  // Rainbow: 100% today and the previous period was a storm (0% for 3 days).
  bool wasStormy = pastRates.every((r) => r == 0);
  bool isRainbow = completionRate == 1.0 && wasStormy;

  // Check for Tornado (Task 44: Longest streak broken today)
  // Tornado: Any habit's longest streak was broken today.
  bool isTornado = false;
  if (!isDemo && user != null) {
    final streakRepo = ref.watch(streakRepositoryProvider);
    final allStreaks = await streakRepo.getAllStreaks(user.uid);
    
    final yesterday = now.subtract(const Duration(days: 1));
    isTornado = allStreaks.any((s) => 
      s.currentStreak == 0 && 
      s.longestStreak > 0 && 
      s.lastActive != null &&
      s.lastActive!.year == yesterday.year &&
      s.lastActive!.month == yesterday.month &&
      s.lastActive!.day == yesterday.day
    );
  }

  final type = WeatherType.fromCompletionRate(
    completionRate,
    isStorm: isStorm,
    isRainbow: isRainbow,
    isTornado: isTornado,
  );

  return WeatherModel(
    type: type,
    completionRate: completionRate,
    date: DateTime.now(),
    message: type.description,
  );
});

final weatherForecastProvider = FutureProvider<List<WeatherModel>>((ref) async {
  final user = ref.watch(authStateProvider).asData?.value;
  final isDemo = ref.watch(demoLoggedInProvider);
  
  if (user == null && !isDemo) return [];

  final habits = await ref.watch(habitsListProvider.future);
  if (habits.isEmpty) return [];

  final repository = ref.watch(habitRepositoryProvider);
  final localService = getIt<HabitLocalService>();
  
  final now = DateTime.now();
  final forecast = <WeatherModel>[];

  // Look back 7 days
  for (int i = 0; i < 7; i++) {
    final date = now.subtract(Duration(days: i));
    final dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    
    final habitsDue = habits.where((h) => h.isDue(date)).toList();
    if (habitsDue.isEmpty) {
      forecast.add(WeatherModel(
        type: WeatherType.sunny,
        completionRate: 1.0,
        date: date,
      ));
      continue;
    }

    Set<String> completions;
    if (isDemo) {
      // For demo, we just use the same completions or randomize
      completions = i == 0 ? ref.watch(demoCompletionsProvider) : {};
    } else {
      final localCompletions = localService.getCompletionsForDate(dateStr);
      // Ideally we'd fetch from remote if not in local, but for forecast we stick to local/cached
      completions = localCompletions;
    }

    final rate = completions.length / habitsDue.length;
    forecast.add(WeatherModel(
      type: WeatherType.fromCompletionRate(rate),
      completionRate: rate,
      date: date,
    ));
  }

  return forecast.reversed.toList();
});

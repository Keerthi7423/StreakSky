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

  if (habits.isEmpty) {
    return WeatherModel(
      type: WeatherType.sunny,
      completionRate: 1.0,
      date: DateTime.now(),
      message: 'No habits scheduled for today. Enjoy the sun!',
    );
  }

  final completionRate = completions.length / habits.length;
  
  // Check for Tornado (Task 44: Longest streak broken today)
  // For simplicity, we check if any streak was broken today.
  // In a real app, this would be more complex.
  bool isTornado = false; // Placeholder for Task 44 logic
  
  // Check for Storm (Task 45: 0% for 3+ days)
  bool isStorm = false; // Placeholder for Task 45 logic
  
  // Check for Rainbow (Task 43: First flawless day after 0% storm)
  bool isRainbow = false; // Placeholder for Task 43 logic

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

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:streaksky/core/di/injection.dart';
import 'package:streaksky/features/auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/habit_model.dart';
import '../../domain/models/habit_frequency.dart';
import '../../domain/repositories/habit_repository.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return getIt<HabitRepository>();
});

final demoHabitsProvider = StateProvider<List<HabitModel>>((ref) {
  return [
    HabitModel(
      id: 'demo-1',
      userId: 'demo-user',
      name: 'Morning Meditation',
      emoji: '🧘',
      colorHex: '00F2FF', // Neon Blue
      category: 'Health',
      frequency: const HabitFrequency(type: FrequencyType.daily),
      createdAt: DateTime.now(),
    ),
    HabitModel(
      id: 'demo-2',
      userId: 'demo-user',
      name: 'Read 20 Pages',
      emoji: '📚',
      colorHex: 'B3FF00', // Neon Green
      category: 'Learning',
      frequency: const HabitFrequency(type: FrequencyType.daily),
      createdAt: DateTime.now(),
    ),
    HabitModel(
      id: 'demo-3',
      userId: 'demo-user',
      name: 'Gym Session',
      emoji: '💪',
      colorHex: 'FF0055', // Neon Pink
      category: 'Work',
      frequency: const HabitFrequency(type: FrequencyType.custom, timesPerWeek: 3),
      createdAt: DateTime.now(),
    ),
  ];
});

final habitsListProvider = FutureProvider<List<HabitModel>>((ref) async {
  final isDemo = ref.watch(demoLoggedInProvider);
  
  if (isDemo) {
    return ref.watch(demoHabitsProvider);
  }

  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) {
    debugPrint('HabitListProvider: User is null, returning empty list');
    return [];
  }

  try {
    final repo = ref.watch(habitRepositoryProvider);
    final habits = await repo.getHabits(user.uid);
    debugPrint('HabitListProvider: Fetched ${habits.length} habits for ${user.uid}');
    return habits;
  } catch (e) {
    debugPrint('HabitListProvider Error: $e');
    rethrow;
  }
});

final demoCompletionsProvider = StateProvider<Set<String>>((ref) => {'demo-1'});

final habitCompletionsProvider = FutureProvider<Set<String>>((ref) async {
  final isDemo = ref.watch(demoLoggedInProvider);
  if (isDemo) return ref.watch(demoCompletionsProvider);

  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) return {};

  final supabase = getIt<SupabaseClient>();
  final today = DateTime.now();
  final dateStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

  final response = await supabase
      .from('habit_completions')
      .select('habit_id')
      .eq('user_id', user.uid)
      .eq('completed_date', dateStr);

  return (response as List).map((row) => row['habit_id'] as String).toSet();
});

class HabitController extends StateNotifier<AsyncValue<void>> {
  final HabitRepository _repository;
  final Ref _ref;

  HabitController(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> addHabit({
    required String name,
    required String emoji,
    required String colorHex,
    required HabitFrequency frequency,
    String? category,
  }) async {
    final user = _ref.read(authStateProvider).asData?.value;
    final isDemo = _ref.read(demoLoggedInProvider);
    
    if (user == null && !isDemo) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final habit = HabitModel(
        id: isDemo ? 'demo-${DateTime.now().millisecondsSinceEpoch}' : '',
        userId: user?.uid ?? 'demo-user',
        name: name,
        emoji: emoji,
        colorHex: colorHex,
        frequency: frequency,
        category: category,
        startDate: DateTime.now(),
      );

      if (!isDemo) {
        await _repository.createHabit(habit);
      } else {
        // Update local demo state
        _ref.read(demoHabitsProvider.notifier).update((state) => [...state, habit]);
      }
      
      _ref.invalidate(habitsListProvider);
    });
  }

  Future<void> deleteHabit(String habitId) async {
    final isDemo = _ref.read(demoLoggedInProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (!isDemo) {
        await _repository.deleteHabit(habitId);
      }
      _ref.invalidate(habitsListProvider);
    });
  }
  
  Future<void> toggleCompletion(String habitId, DateTime date) async {
    final isDemo = _ref.read(demoLoggedInProvider);
    final user = _ref.read(authStateProvider).asData?.value;
    
    if (user == null && !isDemo) return;

    // Local update optimization would be better, but for now we just toggle and invalidate
    final currentCompletions = _ref.read(habitCompletionsProvider).asData?.value ?? {};
    final isCurrentlyCompleted = currentCompletions.contains(habitId);

    state = await AsyncValue.guard(() async {
      if (!isDemo) {
        final supabase = getIt<SupabaseClient>();
        final dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

        if (isCurrentlyCompleted) {
          await supabase
              .from('habit_completions')
              .delete()
              .eq('habit_id', habitId)
              .eq('completed_date', dateStr);
        } else {
          await supabase.from('habit_completions').insert({
            'habit_id': habitId,
            'user_id': user!.uid,
            'completed_date': dateStr,
          });
        }
      } else {
        // Update local demo state
        _ref.read(demoCompletionsProvider.notifier).update((state) {
          final newState = Set<String>.from(state);
          if (isCurrentlyCompleted) {
            newState.remove(habitId);
          } else {
            newState.add(habitId);
          }
          return newState;
        });
      }
      
      _ref.invalidate(habitCompletionsProvider);
    });
  }
}

final habitControllerProvider = StateNotifierProvider<HabitController, AsyncValue<void>>((ref) {
  final repo = ref.watch(habitRepositoryProvider);
  return HabitController(repo, ref);
});

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:streaksky/core/di/injection.dart';
import 'package:streaksky/features/auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/habit_model.dart';
import '../../domain/models/habit_completion_model.dart';
import '../../domain/models/habit_frequency.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../data/services/habit_local_service.dart';
import '../../data/services/sync_service.dart';

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
    return ref.watch(demoHabitsProvider).where((h) => !h.isArchived).toList();
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
    return habits.where((h) => !h.isArchived).toList();
  } catch (e) {
    debugPrint('HabitListProvider Error: $e');
    rethrow;
  }
});

final todaysHabitsProvider = FutureProvider<List<HabitModel>>((ref) async {
  final habits = await ref.watch(habitsListProvider.future);
  final today = DateTime.now();
  
  // For simple frequencies (daily, weekdays, custom days), we can filter directly
  // For 'times per week', it's always 'due' until the count is met for the week.
  // We'll need to fetch this week's completions to be precise.
  
  return habits.where((h) => h.isDue(today)).toList();
});

final demoCompletionsProvider = StateProvider<Set<String>>((ref) => {'demo-1'});

final firestoreRealtimeProvider = StreamProvider<Set<String>>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) return Stream.value({});

  return fs.FirebaseFirestore.instance
      .collection('sync')
      .doc(user.uid)
      .snapshots()
      .handleError((error) {
        debugPrint('Firestore Stream Error: $error');
      })
      .map((snapshot) {
    if (!snapshot.exists) return {};
    final data = snapshot.data() as Map<String, dynamic>;
    final completions = data['habit_completions'] as List<dynamic>?;
    return completions?.map((e) => e.toString()).toSet() ?? {};
  });
});

final habitCompletionsProvider = FutureProvider<Set<String>>((ref) async {
  final isDemo = ref.watch(demoLoggedInProvider);
  if (isDemo) return ref.watch(demoCompletionsProvider);

  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) return {};

  // Watch realtime Firestore updates
  final realtimeCompletions = ref.watch(firestoreRealtimeProvider).asData?.value ?? {};

  final supabase = getIt<SupabaseClient>();
  final localService = getIt<HabitLocalService>();
  final today = DateTime.now();
  final dateStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

  // 1. Get from local storage first (Offline-first)
  final localCompletions = localService.getCompletionsForDate(dateStr);
  
  // Combine with realtime Firestore data for cross-device sync
  final combinedCompletions = localCompletions.union(realtimeCompletions);

  // 2. Fetch from remote and update local if online
  try {
    final response = await supabase
        .from('habit_completions')
        .select('habit_id')
        .eq('user_id', user.uid)
        .eq('completed_date', dateStr);

    final remoteHabitIds = (response as List).map((row) => row['habit_id'] as String).toSet();
    
    // Simple reconciliation: remote wins for simplicity, but we could do better
    for (final id in remoteHabitIds) {
      if (!localCompletions.contains(id)) {
        await localService.saveCompletion(HabitCompletionModel(
          id: '', // Will be updated on next sync or left as is
          habitId: id,
          userId: user.uid,
          completedDate: dateStr,
          synced: true,
        ));
      }
    }
    
    return remoteHabitIds.union(combinedCompletions);
  } catch (e) {
    debugPrint('HabitCompletionsProvider: Offline mode or error: $e');
    return combinedCompletions;
  }
});

final habitHistoryProvider = FutureProvider.family<List<HabitCompletionModel>, String>((ref, habitId) async {
  final isDemo = ref.watch(demoLoggedInProvider);
  if (isDemo) return []; // Demo history not implemented for now

  final repo = ref.watch(habitRepositoryProvider);
  return await repo.getHabitCompletions(habitId);
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

  Future<void> updateHabit(HabitModel habit) async {
    final isDemo = _ref.read(demoLoggedInProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (!isDemo) {
        await _repository.updateHabit(habit);
      } else {
        _ref.read(demoHabitsProvider.notifier).update((state) => 
          state.map((h) => h.id == habit.id ? habit : h).toList()
        );
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
      } else {
        _ref.read(demoHabitsProvider.notifier).update((state) => state.where((h) => h.id != habitId).toList());
      }
      _ref.invalidate(habitsListProvider);
    });
  }

  Future<void> archiveHabit(String habitId) async {
    final isDemo = _ref.read(demoLoggedInProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (!isDemo) {
        await _repository.archiveHabit(habitId);
      } else {
        _ref.read(demoHabitsProvider.notifier).update((state) => 
          state.map((h) => h.id == habitId ? h.copyWith(isArchived: true) : h).toList()
        );
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
      final dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      if (isCurrentlyCompleted) {
        if (!isDemo) {
          await getIt<HabitLocalService>().removeCompletion(habitId, dateStr);
          // Delete from remote if online, otherwise sync will handle it? 
          // Actually, my sync service only handles insertions for now.
          // For simplicity, we delete from remote immediately if possible.
          try {
            final supabase = getIt<SupabaseClient>();
            await supabase
                .from('habit_completions')
                .delete()
                .eq('habit_id', habitId)
                .eq('completed_date', dateStr);
          } catch (_) {}
        } else {
          _ref.read(demoCompletionsProvider.notifier).update((state) {
            final newState = Set<String>.from(state);
            newState.remove(habitId);
            return newState;
          });
        }
      } else {
        if (!isDemo) {
          final completion = HabitCompletionModel(
            id: '',
            habitId: habitId,
            userId: user!.uid,
            completedDate: dateStr,
            synced: false,
          );
          await getIt<HabitLocalService>().saveCompletion(completion);
          
          // Trigger background sync
          getIt<SyncService>().syncCompletions();
        } else {
          _ref.read(demoCompletionsProvider.notifier).update((state) {
            final newState = Set<String>.from(state);
            newState.add(habitId);
            return newState;
          });
        }
      }
      
      _ref.invalidate(habitCompletionsProvider);
    });
  }

  Future<void> reorderHabits(int oldIndex, int newIndex) async {
    final habitsAsync = _ref.read(habitsListProvider);
    if (habitsAsync is! AsyncData<List<HabitModel>>) return;

    final habits = List<HabitModel>.from(habitsAsync.value);
    
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = habits.removeAt(oldIndex);
    habits.insert(newIndex, item);

    // Update sort order for all items
    final updatedHabits = <HabitModel>[];
    for (int i = 0; i < habits.length; i++) {
      updatedHabits.add(habits[i].copyWith(sortOrder: i));
    }

    // Optimistic update
    // We can't easily update FutureProvider state directly, so we just trigger the repo call
    // and invalidate. A better way would be using a StateNotifier for the list.
    
    final isDemo = _ref.read(demoLoggedInProvider);
    if (isDemo) {
      _ref.read(demoHabitsProvider.notifier).state = updatedHabits;
    } else {
      await _repository.reorderHabits(updatedHabits);
      _ref.invalidate(habitsListProvider);
    }
  }
}

final habitControllerProvider = StateNotifierProvider<HabitController, AsyncValue<void>>((ref) {
  final repo = ref.watch(habitRepositoryProvider);
  return HabitController(repo, ref);
});

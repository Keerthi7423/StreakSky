import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/core/di/injection.dart';
import 'package:streaksky/features/auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/goal_model.dart';
import '../../domain/repositories/goal_repository.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return getIt<GoalRepository>();
});

final demoGoalsProvider = StateProvider<List<GoalModel>>((ref) {
  return [
    GoalModel(
      id: 'demo-goal-1',
      userId: 'demo-user',
      type: GoalType.weekly,
      title: 'Weekly Warrior',
      description: 'Complete 5 habits this week.',
      targetValue: 5,
      currentValue: 2,
      linkedHabits: ['demo-1', 'demo-2'],
      createdAt: DateTime.now(),
    ),
    GoalModel(
      id: 'demo-goal-2',
      userId: 'demo-user',
      type: GoalType.career,
      title: 'Master of Routine',
      description: 'Reach a 100-day total across all habits.',
      targetValue: 100,
      currentValue: 45,
      linkedHabits: ['demo-1', 'demo-2', 'demo-3'],
      createdAt: DateTime.now(),
    ),
  ];
});

final goalsListProvider = FutureProvider.family<List<GoalModel>, GoalType?>((ref, type) async {
  final isDemo = ref.watch(demoLoggedInProvider);
  if (isDemo) {
    final allDemoGoals = ref.watch(demoGoalsProvider);
    if (type == null) return allDemoGoals;
    return allDemoGoals.where((g) => g.type == type).toList();
  }

  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) return [];

  final repo = ref.watch(goalRepositoryProvider);
  return await repo.getGoals(user.uid, type: type);
});

class GoalController extends StateNotifier<AsyncValue<void>> {
  final GoalRepository _repository;
  final Ref _ref;

  GoalController(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> addGoal({
    required String title,
    required GoalType type,
    String? description,
    int? targetValue,
    List<String> linkedHabits = const [],
  }) async {
    final user = _ref.read(authStateProvider).asData?.value;
    final isDemo = _ref.read(demoLoggedInProvider);
    if (user == null && !isDemo) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final goal = GoalModel(
        id: isDemo ? 'demo-${DateTime.now().millisecondsSinceEpoch}' : '',
        userId: user?.uid ?? 'demo-user',
        title: title,
        type: type,
        description: description,
        targetValue: targetValue,
        linkedHabits: linkedHabits,
        startDate: DateTime.now(),
      );

      if (!isDemo) {
        await _repository.createGoal(goal);
      } else {
        _ref.read(demoGoalsProvider.notifier).update((state) => [...state, goal]);
      }
      _ref.invalidate(goalsListProvider);
    });
  }

  Future<void> updateGoalProgress(String goalId, int newValue) async {
    final isDemo = _ref.read(demoLoggedInProvider);
    state = await AsyncValue.guard(() async {
      if (!isDemo) {
        await _repository.updateGoalProgress(goalId, newValue);
      } else {
        _ref.read(demoGoalsProvider.notifier).update((state) => 
          state.map((g) => g.id == goalId ? g.copyWith(currentValue: newValue) : g).toList()
        );
      }
      _ref.invalidate(goalsListProvider);
    });
  }

  Future<void> deleteGoal(String goalId) async {
    final isDemo = _ref.read(demoLoggedInProvider);
    state = await AsyncValue.guard(() async {
      if (!isDemo) {
        await _repository.deleteGoal(goalId);
      } else {
        _ref.read(demoGoalsProvider.notifier).update((state) => state.where((g) => g.id != goalId).toList());
      }
      _ref.invalidate(goalsListProvider);
    });
  }
  
  Future<void> handleHabitCompletion(String habitId, bool completed) async {
    final user = _ref.read(authStateProvider).asData?.value;
    final isDemo = _ref.read(demoLoggedInProvider);
    if (user == null && !isDemo) return;

    try {
      List<GoalModel> linkedGoals;
      if (!isDemo) {
        linkedGoals = await _repository.getGoalsByHabitId(user!.uid, habitId);
      } else {
        linkedGoals = _ref.read(demoGoalsProvider).where((g) => g.linkedHabits.contains(habitId)).toList();
      }
      
      for (final goal in linkedGoals) {
        final delta = completed ? 1 : -1;
        final newValue = (goal.currentValue + delta).clamp(0, goal.targetValue ?? 999999);
        final wasCompleted = goal.isCompleted;
        final isNowCompleted = newValue >= (goal.targetValue ?? 999999);
        
        if (newValue == goal.currentValue && wasCompleted == isNowCompleted) continue;
        
        final updatedGoal = goal.copyWith(
          currentValue: newValue,
          isCompleted: isNowCompleted,
        );
        
        if (!isDemo) {
          await _repository.updateGoal(updatedGoal);
        } else {
          _ref.read(demoGoalsProvider.notifier).update((state) => 
            state.map((g) => g.id == goal.id ? updatedGoal : g).toList()
          );
        }
      }
      
      if (linkedGoals.isNotEmpty) {
        _ref.invalidate(goalsListProvider);
      }
    } catch (e) {
      debugPrint('Error in Goal Cascade: $e');
    }
  }
}

final goalControllerProvider = StateNotifierProvider<GoalController, AsyncValue<void>>((ref) {
  final repo = ref.watch(goalRepositoryProvider);
  return GoalController(repo, ref);
});

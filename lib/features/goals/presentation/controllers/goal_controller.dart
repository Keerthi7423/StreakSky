import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/core/di/injection.dart';
import 'package:streaksky/core/services/analytics_service.dart';
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
    GoalModel(
      id: 'career-1',
      userId: 'demo-user',
      type: GoalType.career,
      title: 'FOUNDATION',
      description: 'Master the basics of consistency.',
      targetValue: 30,
      currentValue: 30,
      isCompleted: true,
      phase: 1,
      isMilestone: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    GoalModel(
      id: 'career-2',
      userId: 'demo-user',
      type: GoalType.career,
      title: 'ROUTINE ARCHITECT',
      description: 'Design and sustain 3 complex habits.',
      targetValue: 90,
      currentValue: 45,
      phase: 2,
      isMilestone: false,
      rolledOver: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    GoalModel(
      id: 'career-3',
      userId: 'demo-user',
      type: GoalType.career,
      title: 'LEGACY BUILDER',
      description: 'Complete 365 days of total logs.',
      targetValue: 365,
      currentValue: 120,
      phase: 3,
      isMilestone: true,
      createdAt: DateTime.now(),
    ),
  ];
});

final goalsListProvider = FutureProvider.family<List<GoalModel>, GoalType?>((ref, type) async {
  final isDemo = ref.watch(demoLoggedInProvider);
  debugPrint('🔄 Fetching goals for type: $type (isDemo: $isDemo)');

  if (isDemo) {
    final allDemoGoals = ref.watch(demoGoalsProvider);
    final filtered = type == null ? allDemoGoals : allDemoGoals.where((g) => g.type == type).toList();
    debugPrint('✅ Found ${filtered.length} demo goals');
    return filtered;
  }

  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) {
    debugPrint('⚠️ No user logged in, returning empty goals');
    return [];
  }

  final repo = ref.watch(goalRepositoryProvider);
  final goals = await repo.getGoals(user.uid, type: type);
  debugPrint('✅ Found ${goals.length} real goals from repository');
  return goals;
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
    int? phase,
    bool isMilestone = false,
    List<String> linkedHabits = const [],
  }) async {
    final user = _ref.read(authStateProvider).asData?.value;
    final isDemo = _ref.read(demoLoggedInProvider);
    if (user == null && !isDemo) {
      debugPrint('⚠️ addGoal: User is null and not in demo mode');
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Ensure goals are current before adding new one
      await checkAndResetGoals();

      final goal = GoalModel(
        id: isDemo ? 'demo-${DateTime.now().millisecondsSinceEpoch}' : '',
        userId: user?.uid ?? 'demo-user',
        title: title,
        type: type,
        description: description,
        targetValue: targetValue,
        phase: phase,
        isMilestone: isMilestone,
        linkedHabits: linkedHabits,
        startDate: DateTime.now(),
        createdAt: DateTime.now(),
      );

      if (!isDemo) {
        debugPrint('📤 Creating goal in Supabase...');
        await _repository.createGoal(goal);
      } else {
        debugPrint('💾 Adding goal to Demo state...');
        _ref.read(demoGoalsProvider.notifier).update((state) => [...state, goal]);
      }
      
      // Log Analytics
      _ref.read(analyticsServiceProvider).logGoalCreated(goal);
      
      _ref.invalidate(goalsListProvider);
      debugPrint('✅ Goal added and provider invalidated');
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
      // First check for any pending resets
      await checkAndResetGoals();
      
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
        
        // Log Analytics for the first linked goal found (simplified)
        if (linkedGoals.isNotEmpty) {
          final goal = linkedGoals.first;
          final newValue = (goal.currentValue + (completed ? 1 : -1)).clamp(0, goal.targetValue ?? 999999);
          _ref.read(analyticsServiceProvider).logGoalProgress(goal, newValue);
          
          if (newValue >= (goal.targetValue ?? 999999)) {
            _ref.read(analyticsServiceProvider).logGoalCompletion(goal);
          }
        }
      }
    } catch (e) {
      debugPrint('Error in Goal Cascade: $e');
    }
  }

  Future<void> checkAndResetGoals() async {
    final isDemo = _ref.read(demoLoggedInProvider);
    final user = _ref.read(authStateProvider).asData?.value;
    if (user == null && !isDemo) return;

    List<GoalModel> goals;
    if (isDemo) {
      goals = _ref.read(demoGoalsProvider);
    } else {
      goals = await _repository.getGoals(user!.uid);
    }

    final now = DateTime.now();
    bool updated = false;
    final newGoals = <GoalModel>[];

    for (var goal in goals) {
      bool resetNeeded = false;
      DateTime? newResetDate;

      if (goal.type == GoalType.weekly) {
        // Reset every Monday at 00:00 (Timezone safe comparison)
        final lastReset = (goal.lastResetAt ?? goal.createdAt ?? goal.startDate ?? now).toLocal();
        final startOfToday = DateTime(now.year, now.month, now.day);
        final lastMonday = startOfToday.subtract(Duration(days: startOfToday.weekday - 1));
        
        if (lastReset.isBefore(lastMonday)) {
          resetNeeded = true;
          newResetDate = lastMonday;
        }
      } else if (goal.type == GoalType.monthly) {
        // Reset on the 1st of every month (Timezone safe comparison)
        final lastReset = (goal.lastResetAt ?? goal.createdAt ?? goal.startDate ?? now).toLocal();
        final startOfThisMonth = DateTime(now.year, now.month, 1);
        
        if (lastReset.isBefore(startOfThisMonth)) {
          resetNeeded = true;
          newResetDate = startOfThisMonth;
        }
      }

      if (resetNeeded) {
        final resetGoal = goal.copyWith(
          currentValue: 0,
          isCompleted: false,
          lastResetAt: newResetDate ?? now,
          rolledOver: true,
        );
        newGoals.add(resetGoal);
        updated = true;
        
        if (!isDemo) {
          await _repository.updateGoal(resetGoal);
        }
        
        // Log Analytics for reset
        _ref.read(analyticsServiceProvider).logGoalReset(goal);
      } else {
        newGoals.add(goal);
      }
    }

    if (updated) {
      if (isDemo) {
        _ref.read(demoGoalsProvider.notifier).state = newGoals;
      }
      _ref.invalidate(goalsListProvider);
    }
  }
}

final goalControllerProvider = StateNotifierProvider<GoalController, AsyncValue<void>>((ref) {
  final repo = ref.watch(goalRepositoryProvider);
  return GoalController(repo, ref);
});

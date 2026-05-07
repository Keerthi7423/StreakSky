import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/core/di/injection.dart';
import 'package:streaksky/features/auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/goal_model.dart';
import '../../domain/repositories/goal_repository.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return getIt<GoalRepository>();
});

final goalsListProvider = FutureProvider.family<List<GoalModel>, GoalType?>((ref, type) async {
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
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final goal = GoalModel(
        id: '',
        userId: user.uid,
        title: title,
        type: type,
        description: description,
        targetValue: targetValue,
        linkedHabits: linkedHabits,
        startDate: DateTime.now(),
      );

      await _repository.createGoal(goal);
      _ref.invalidate(goalsListProvider);
    });
  }

  Future<void> updateGoalProgress(String goalId, int newValue) async {
    state = await AsyncValue.guard(() async {
      await _repository.updateGoalProgress(goalId, newValue);
      _ref.invalidate(goalsListProvider);
    });
  }

  Future<void> deleteGoal(String goalId) async {
    state = await AsyncValue.guard(() async {
      await _repository.deleteGoal(goalId);
      _ref.invalidate(goalsListProvider);
    });
  }
}

final goalControllerProvider = StateNotifierProvider<GoalController, AsyncValue<void>>((ref) {
  final repo = ref.watch(goalRepositoryProvider);
  return GoalController(repo, ref);
});

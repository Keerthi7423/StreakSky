import '../models/goal_model.dart';

abstract class GoalRepository {
  Future<List<GoalModel>> getGoals(String userId, {GoalType? type});
  Future<GoalModel> createGoal(GoalModel goal);
  Future<GoalModel> updateGoal(GoalModel goal);
  Future<void> deleteGoal(String goalId);
  Future<void> updateGoalProgress(String goalId, int newValue);
  Future<List<GoalModel>> getGoalsByHabitId(String userId, String habitId);
}

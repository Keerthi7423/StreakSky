import '../models/goal_model.dart';
import '../repositories/goal_repository.dart';

class GoalRolloverService {
  final GoalRepository _goalRepository;

  GoalRolloverService({required GoalRepository goalRepository})
    : _goalRepository = goalRepository;

  /// Checks if the year has changed and rolls over incomplete career goals.
  /// Typically called during app startup or via a scheduled background task (Jan 1, 00:05).
  Future<void> executeYearStartRollover(String userId) async {
    // In a real implementation, this would check against a last_run_timestamp
    // in local SharedPreferences or a remote config to ensure it only runs once per year.

    final currentYear = DateTime.now().year;

    // Fetch all goals for the user
    final allGoals = await _goalRepository.getGoals(userId);

    // Filter out career goals that were created in a previous year and are NOT completed
    final eligibleGoals = allGoals.where((g) {
      final isCareer = g.type == GoalType.career;
      final isIncomplete = !g.isCompleted;

      // If we don't have a creation date, assume it's old enough to check.
      // Usually, you'd check if it was created < currentYear
      final isFromPreviousYear =
          g.createdAt == null || g.createdAt!.year < currentYear;

      // Don't roll over something that has already been rolled over this year
      final notRolledOverYet = !g.rolledOver;

      return isCareer && isIncomplete && isFromPreviousYear && notRolledOverYet;
    }).toList();

    for (var goal in eligibleGoals) {
      // Create a duplicate goal with rolledOver flag = true
      final rolledOverGoal = goal.copyWith(
        id: '', // Will be assigned by repository
        rolledOver: true,
        lastResetAt: DateTime.now(),
        createdAt: DateTime.now(),
      );

      // Save the new goal
      await _goalRepository.createGoal(rolledOverGoal);

      // We might optionally mark the old one as archived or leave it as history.
      // For this system, we leave the old one as uncompleted for historical tracking,
      // but in the UI we would query for the most recent uncompleted one.
    }
  }
}

import '../models/habit_model.dart';
import '../models/habit_completion_model.dart';

abstract class HabitRepository {
  Future<List<HabitModel>> getHabits(String userId);
  Future<HabitModel> createHabit(HabitModel habit);
  Future<HabitModel> updateHabit(HabitModel habit);
  Future<void> deleteHabit(String habitId);
  Future<void> archiveHabit(String habitId);
  Future<void> reorderHabits(List<HabitModel> habits);
  Future<List<HabitCompletionModel>> getHabitCompletions(String habitId);
}

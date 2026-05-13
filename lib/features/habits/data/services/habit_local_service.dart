import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../domain/models/habit_completion_model.dart';

@lazySingleton
class HabitLocalService {
  static const String _completionBoxName = 'habit_completions';

  Future<void> init() async {
    await Hive.openBox(_completionBoxName);
  }

  Box get _completionBox => Hive.box(_completionBoxName);

  Future<void> saveCompletion(HabitCompletionModel completion) async {
    await _completionBox.put('${completion.habitId}_${completion.completedDate}', completion.toJson());
  }

  Future<void> removeCompletion(String habitId, String date) async {
    await _completionBox.delete('${habitId}_$date');
  }

  List<HabitCompletionModel> getUnsyncedCompletions() {
    return _completionBox.values
        .map((json) => HabitCompletionModel.fromJson(Map<String, dynamic>.from(json)))
        .where((c) => !c.synced)
        .toList();
  }

  Future<void> markAsSynced(String habitId, String date) async {
    final key = '${habitId}_$date';
    final json = _completionBox.get(key);
    if (json != null) {
      final completion = HabitCompletionModel.fromJson(Map<String, dynamic>.from(json))
          .copyWith(synced: true);
      await _completionBox.put(key, completion.toJson());
    }
  }

  Set<String> getCompletionsForDate(String date) {
    return _completionBox.values
        .map((json) => HabitCompletionModel.fromJson(Map<String, dynamic>.from(json)))
        .where((c) => c.completedDate == date)
        .map((c) => c.habitId)
        .toSet();
  }

  List<HabitCompletionModel> getCompletionsForDateRange(String startDate, String endDate) {
    return _completionBox.values
        .map((json) => HabitCompletionModel.fromJson(Map<String, dynamic>.from(json)))
        .where((c) => c.completedDate.compareTo(startDate) >= 0 && c.completedDate.compareTo(endDate) <= 0)
        .toList();
  }

  List<HabitCompletionModel> getRecentCompletions(int limit) {
    final completions = _completionBox.values
        .where((json) => json != null)
        .map((json) => HabitCompletionModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
    
    // Sort by completedAt descending, fallback to completedDate
    completions.sort((a, b) {
      final dateA = a.completedAt ?? DateTime.tryParse(a.completedDate) ?? DateTime.now();
      final dateB = b.completedAt ?? DateTime.tryParse(b.completedDate) ?? DateTime.now();
      return dateB.compareTo(dateA);
    });
    
    return completions.take(limit).toList();
  }
}

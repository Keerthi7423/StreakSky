import '../../domain/models/goal_model.dart';

class GoalProjectionData {
  final List<double> idealPoints;
  final List<double> actualPoints;
  final List<String> labels;

  GoalProjectionData({
    required this.idealPoints,
    required this.actualPoints,
    required this.labels,
  });
}

class GoalProjectionService {
  static GoalProjectionData generateProjection(GoalModel goal) {
    final now = DateTime.now();
    DateTime start;
    DateTime end;
    int totalDays;
    int currentDayIndex;

    if (goal.type == GoalType.weekly) {
      final lastMonday = now.subtract(Duration(days: now.weekday - 1));
      start = DateTime(lastMonday.year, lastMonday.month, lastMonday.day);
      end = start.add(const Duration(days: 6));
      totalDays = 7;
      currentDayIndex = now.weekday - 1;
      
      final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
      return _generate(goal, totalDays, currentDayIndex, labels);
    } else if (goal.type == GoalType.monthly) {
      start = DateTime(now.year, now.month, 1);
      final nextMonth = DateTime(now.year, now.month + 1, 1);
      end = nextMonth.subtract(const Duration(days: 1));
      totalDays = end.day;
      currentDayIndex = now.day - 1;
      
      final labels = List.generate(totalDays, (i) => (i + 1).toString());
      return _generate(goal, totalDays, currentDayIndex, labels);
    } else {
      // Career goals: Use 12 month projection or similar
      totalDays = 12;
      currentDayIndex = 0; // Simplified for now
      final labels = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
      return _generate(goal, totalDays, currentDayIndex, labels);
    }
  }

  static GoalProjectionData _generate(GoalModel goal, int totalDays, int currentDayIndex, List<String> labels) {
    final target = goal.targetValue?.toDouble() ?? 100.0;
    final current = goal.currentValue.toDouble();
    
    final idealPoints = <double>[];
    final actualPoints = <double>[];

    for (int i = 0; i < totalDays; i++) {
      // Ideal: Linear progression
      idealPoints.add((target / (totalDays - 1)) * i);
      
      // Actual: We only know current value at current day
      // For projection, we can show actual up to today, and then a dashed line?
      // Or just a single line showing growth so far.
      if (i <= currentDayIndex) {
        // Linear interpolation from 0 to current for simplicity if history is missing
        actualPoints.add((current / currentDayIndex.clamp(1, 999)) * i);
      }
    }

    return GoalProjectionData(
      idealPoints: idealPoints,
      actualPoints: actualPoints,
      labels: labels,
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:streaksky/features/goals/domain/models/goal_model.dart';
import 'package:streaksky/features/goals/domain/services/goal_projection_service.dart';

void main() {
  group('Task 118: Goal Progression Logic (Goal Projection Service)', () {
    test('Should generate 7-day projection for Weekly Goals', () {
      final weeklyGoal = GoalModel(
        id: '1',
        title: 'Read Books',
        type: GoalType.weekly,
        targetValue: 100.0,
        currentValue: 50.0,
        createdAt: DateTime.now(),
      );

      final projection = GoalProjectionService.generateProjection(weeklyGoal);

      expect(projection.labels.length, 7);
      expect(projection.idealPoints.length, 7);
      expect(projection.actualPoints.length, lessThanOrEqualTo(7));

      // Ensure ideal linear progression targets exactly the target value at the end
      expect(projection.idealPoints.last, 100.0);
    });

    test('Should generate multi-day projection for Monthly Goals', () {
      final monthlyGoal = GoalModel(
        id: '2',
        title: 'Run Marathon',
        type: GoalType.monthly,
        targetValue: 300.0,
        currentValue: 150.0,
        createdAt: DateTime.now(),
      );

      final projection = GoalProjectionService.generateProjection(monthlyGoal);

      expect(projection.labels.length, greaterThanOrEqualTo(28));
      expect(projection.labels.length, lessThanOrEqualTo(31));
      expect(projection.idealPoints.last, 300.0);
    });

    test('Should generate 12-month projection for Career Goals', () {
      final careerGoal = GoalModel(
        id: '3',
        title: 'Senior Developer',
        type: GoalType.career,
        targetValue: 10.0,
        currentValue: 5.0,
        createdAt: DateTime.now(),
      );

      final projection = GoalProjectionService.generateProjection(careerGoal);

      expect(projection.labels.length, 12);
      expect(projection.labels, [
        'J',
        'F',
        'M',
        'A',
        'M',
        'J',
        'J',
        'A',
        'S',
        'O',
        'N',
        'D',
      ]);
      expect(projection.idealPoints.last, 10.0);
    });
  });
}

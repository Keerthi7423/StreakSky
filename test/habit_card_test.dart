import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/features/habits/domain/models/habit_model.dart';
import 'package:streaksky/features/habits/domain/models/habit_frequency.dart';
import 'package:streaksky/features/habits/presentation/widgets/habit_card.dart';

void main() {
  group('Task 119: Widget Tests for Habit Card', () {
    late HabitModel testHabit;

    setUp(() {
      testHabit = HabitModel(
        id: 'habit_1',
        userId: 'user_1',
        name: 'Drink Water',
        emoji: '💧',
        category: 'Health',
        colorHex: '00BFFF',
        frequency: const HabitFrequency(type: FrequencyType.daily),
        createdAt: DateTime.now(),
      );
    });

    testWidgets(
      'Should display habit details correctly (Emoji, Name, Category)',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: HabitCard(habit: testHabit, isCompleted: false),
              ),
            ),
          ),
        );

        // Verify the emoji is rendered
        expect(find.text('💧'), findsOneWidget);

        // Verify the habit name is rendered
        expect(find.text('Drink Water'), findsOneWidget);

        // Verify the category is rendered in uppercase
        expect(find.text('HEALTH'), findsOneWidget);

        // Verify checkbox does not show check mark when incomplete
        expect(find.byIcon(Icons.check), findsNothing);
      },
    );

    testWidgets('Should display check mark when habit is completed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HabitCard(habit: testHabit, isCompleted: true),
            ),
          ),
        ),
      );

      // Verify the check icon is present
      expect(find.byIcon(Icons.check), findsOneWidget);

      // The text should still be present
      expect(find.text('Drink Water'), findsOneWidget);
    });
  });
}

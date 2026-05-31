import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/features/weather/presentation/widgets/weather_hero_card.dart';

void main() {
  group('Task 119: Widget Tests for Weather Hero Card', () {
    testWidgets('Should display loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: WeatherHeroCard(),
            ),
          ),
        ),
      );

      // The widget uses a FutureProvider, so it should initially be in the loading state.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

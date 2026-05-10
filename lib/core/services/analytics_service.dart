import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:streaksky/core/di/injection.dart';
import '../../features/goals/domain/models/goal_model.dart';

@lazySingleton
class AnalyticsService {
  FirebaseAnalytics? _analytics;

  AnalyticsService() {
    try {
      _analytics = FirebaseAnalytics.instance;
    } catch (e) {
      debugPrint('⚠️ Analytics: Firebase not initialized: $e');
    }
  }

  Future<void> logGoalCreated(GoalModel goal) async {
    debugPrint('📊 Analytics: Goal Created - ${goal.title} (${goal.type.name})');
    try {
      await _analytics?.logEvent(
        name: 'goal_created',
        parameters: {
          'goal_id': goal.id,
          'goal_type': goal.type.name,
          'goal_title': goal.title,
          'target_value': goal.targetValue ?? 0,
        },
      );
    } catch (e) {
      debugPrint('⚠️ Analytics Error: $e');
    }
  }

  Future<void> logGoalCompletion(GoalModel goal) async {
    debugPrint('📊 Analytics: Goal Completed - ${goal.title}');
    try {
      await _analytics?.logEvent(
        name: 'goal_completed',
        parameters: {
          'goal_id': goal.id,
          'goal_type': goal.type.name,
          'goal_title': goal.title,
        },
      );
    } catch (e) {
      debugPrint('⚠️ Analytics Error: $e');
    }
  }

  Future<void> logGoalProgress(GoalModel goal, int newValue) async {
    debugPrint('📊 Analytics: Goal Progress - ${goal.title}: $newValue/${goal.targetValue}');
    try {
      await _analytics?.logEvent(
        name: 'goal_progress_updated',
        parameters: {
          'goal_id': goal.id,
          'new_value': newValue,
          'target_value': goal.targetValue ?? 0,
          'completion_percentage': goal.targetValue != null ? (newValue / goal.targetValue! * 100).round() : 0,
        },
      );
    } catch (e) {
      debugPrint('⚠️ Analytics Error: $e');
    }
  }

  Future<void> logGoalReset(GoalModel goal) async {
    debugPrint('📊 Analytics: Goal Reset - ${goal.title}');
    try {
      await _analytics?.logEvent(
        name: 'goal_reset',
        parameters: {
          'goal_id': goal.id,
          'goal_type': goal.type.name,
        },
      );
    } catch (e) {
      debugPrint('⚠️ Analytics Error: $e');
    }
  }
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return getIt<AnalyticsService>();
});

class YearReviewModel {
  final int year;
  final String userId;
  final List<HabitReportCard> habitReports;
  final WeatherYearSummary weatherSummary;
  final GoalCompletionSummary goalSummary;
  final StreakHallOfFame streakHallOfFame;
  final String aiNarrative;
  final DateTime createdAt;

  const YearReviewModel({
    required this.year,
    required this.userId,
    required this.habitReports,
    required this.weatherSummary,
    required this.goalSummary,
    required this.streakHallOfFame,
    required this.aiNarrative,
    required this.createdAt,
  });

  factory YearReviewModel.fromJson(Map<String, dynamic> json) {
    return YearReviewModel(
      year: json['year'] as int? ?? DateTime.now().year,
      userId: json['user_id'] as String? ?? '',
      habitReports: (json['habit_reports'] as List?)
              ?.map((e) => HabitReportCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weatherSummary: WeatherYearSummary.fromJson(
          json['weather_summary'] as Map<String, dynamic>? ?? {}),
      goalSummary: GoalCompletionSummary.fromJson(
          json['goal_summary'] as Map<String, dynamic>? ?? {}),
      streakHallOfFame: StreakHallOfFame.fromJson(
          json['streak_hall_of_fame'] as Map<String, dynamic>? ?? {}),
      aiNarrative: json['ai_narrative'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'user_id': userId,
      'habit_reports': habitReports.map((e) => e.toJson()).toList(),
      'weather_summary': weatherSummary.toJson(),
      'goal_summary': goalSummary.toJson(),
      'streak_hall_of_fame': streakHallOfFame.toJson(),
      'ai_narrative': aiNarrative,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class HabitReportCard {
  final String habitId;
  final String name;
  final String emoji;
  final String colorHex;
  final int totalCompletions;
  final double completionRate; // 0.0 - 1.0
  final int longestStreak;
  final String bestMonth;
  final String worstMonth;
  final String trend; // 'improving' | 'declining' | 'steady'

  const HabitReportCard({
    required this.habitId,
    required this.name,
    required this.emoji,
    required this.colorHex,
    required this.totalCompletions,
    required this.completionRate,
    required this.longestStreak,
    required this.bestMonth,
    required this.worstMonth,
    required this.trend,
  });

  factory HabitReportCard.fromJson(Map<String, dynamic> json) {
    return HabitReportCard(
      habitId: json['habit_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '📝',
      colorHex: json['color_hex'] as String? ?? 'B3FF00',
      totalCompletions: json['total_completions'] as int? ?? 0,
      completionRate: (json['completion_rate'] as num?)?.toDouble() ?? 0.0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      bestMonth: json['best_month'] as String? ?? 'None',
      worstMonth: json['worst_month'] as String? ?? 'None',
      trend: json['trend'] as String? ?? 'steady',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'habit_id': habitId,
      'name': name,
      'emoji': emoji,
      'color_hex': colorHex,
      'total_completions': totalCompletions,
      'completion_rate': completionRate,
      'longest_streak': longestStreak,
      'best_month': bestMonth,
      'worst_month': worstMonth,
      'trend': trend,
    };
  }
}

class WeatherYearSummary {
  final int totalSunnyDays;
  final int totalStormyDays;
  final String mostCommonWeather;
  final String bestWeatherMonth;
  final String summaryText;
  final List<String> monthlyWeatherStrip; // list of 12 emojis

  const WeatherYearSummary({
    required this.totalSunnyDays,
    required this.totalStormyDays,
    required this.mostCommonWeather,
    required this.bestWeatherMonth,
    required this.summaryText,
    required this.monthlyWeatherStrip,
  });

  factory WeatherYearSummary.fromJson(Map<String, dynamic> json) {
    return WeatherYearSummary(
      totalSunnyDays: json['total_sunny_days'] as int? ?? 0,
      totalStormyDays: json['total_stormy_days'] as int? ?? 0,
      mostCommonWeather: json['most_common_weather'] as String? ?? 'Cloudy',
      bestWeatherMonth: json['best_weather_month'] as String? ?? 'None',
      summaryText: json['summary_text'] as String? ?? '',
      monthlyWeatherStrip: (json['monthly_weather_strip'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_sunny_days': totalSunnyDays,
      'total_stormy_days': totalStormyDays,
      'most_common_weather': mostCommonWeather,
      'best_weather_month': bestWeatherMonth,
      'summary_text': summaryText,
      'monthly_weather_strip': monthlyWeatherStrip,
    };
  }
}

class GoalCompletionSummary {
  final int weeklyGoalsCompleted;
  final int weeklyGoalsTotal;
  final int monthlyGoalsCompleted;
  final int monthlyGoalsTotal;
  final int careerMilestonesHit;
  final int careerMilestonesTotal;
  final int overallGoalCompletionScore; // 0 - 100

  const GoalCompletionSummary({
    required this.weeklyGoalsCompleted,
    required this.weeklyGoalsTotal,
    required this.monthlyGoalsCompleted,
    required this.monthlyGoalsTotal,
    required this.careerMilestonesHit,
    required this.careerMilestonesTotal,
    required this.overallGoalCompletionScore,
  });

  factory GoalCompletionSummary.fromJson(Map<String, dynamic> json) {
    return GoalCompletionSummary(
      weeklyGoalsCompleted: json['weekly_goals_completed'] as int? ?? 0,
      weeklyGoalsTotal: json['weekly_goals_total'] as int? ?? 0,
      monthlyGoalsCompleted: json['monthly_goals_completed'] as int? ?? 0,
      monthlyGoalsTotal: json['monthly_goals_total'] as int? ?? 0,
      careerMilestonesHit: json['career_milestones_hit'] as int? ?? 0,
      careerMilestonesTotal: json['career_milestones_total'] as int? ?? 0,
      overallGoalCompletionScore: json['overall_goal_completion_score'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekly_goals_completed': weeklyGoalsCompleted,
      'weekly_goals_total': weeklyGoalsTotal,
      'monthly_goals_completed': monthlyGoalsCompleted,
      'monthly_goals_total': monthlyGoalsTotal,
      'career_milestones_hit': careerMilestonesHit,
      'career_milestones_total': careerMilestonesTotal,
      'overall_goal_completion_score': overallGoalCompletionScore,
    };
  }
}

class StreakHallOfFame {
  final List<TopStreakItem> topLongestStreaks;
  final int shieldsUsed;
  final int comebacks;
  final int consecutivePerfectWeeks;

  const StreakHallOfFame({
    required this.topLongestStreaks,
    required this.shieldsUsed,
    required this.comebacks,
    required this.consecutivePerfectWeeks,
  });

  factory StreakHallOfFame.fromJson(Map<String, dynamic> json) {
    return StreakHallOfFame(
      topLongestStreaks: (json['top_longest_streaks'] as List?)
              ?.map((e) => TopStreakItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      shieldsUsed: json['shields_used'] as int? ?? 0,
      comebacks: json['comebacks'] as int? ?? 0,
      consecutivePerfectWeeks: json['consecutive_perfect_weeks'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top_longest_streaks': topLongestStreaks.map((e) => e.toJson()).toList(),
      'shields_used': shieldsUsed,
      'comebacks': comebacks,
      'consecutive_perfect_weeks': consecutivePerfectWeeks,
    };
  }
}

class TopStreakItem {
  final String habitName;
  final String emoji;
  final int streakDays;

  const TopStreakItem({
    required this.habitName,
    required this.emoji,
    required this.streakDays,
  });

  factory TopStreakItem.fromJson(Map<String, dynamic> json) {
    return TopStreakItem(
      habitName: json['habit_name'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '🔥',
      streakDays: json['streak_days'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'habit_name': habitName,
      'emoji': emoji,
      'streak_days': streakDays,
    };
  }
}

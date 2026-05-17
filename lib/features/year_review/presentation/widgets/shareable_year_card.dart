import 'package:flutter/material.dart';
import '../../domain/models/year_review_model.dart';

class ShareableYearCard extends StatelessWidget {
  final YearReviewModel review;
  final VoidCallback? onExport;

  const ShareableYearCard({
    super.key,
    required this.review,
    this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final topHabit = review.streakHallOfFame.topLongestStreaks.isNotEmpty
        ? review.streakHallOfFame.topLongestStreaks.first
        : const TopStreakItem(habitName: 'Consistency', emoji: '🌱', streakDays: 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF141414), Color(0xFF070707)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFB3FF00).withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB3FF00).withValues(alpha: 0.05),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branding Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STREAKSKY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: const Color(0xFFB3FF00).withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Year in Review',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFB3FF00).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFFB3FF00).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${review.year}',
                  style: const TextStyle(
                    color: Color(0xFFB3FF00),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Central Hero: Sunny Days
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  '☀️',
                  style: TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 8),
                Text(
                  '${review.weatherSummary.totalSunnyDays}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'SUNNY DAYS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  review.weatherSummary.summaryText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Side-by-side stats
          Row(
            children: [
              Expanded(
                child: _buildMiniStat(
                  title: 'LONGEST STREAK',
                  value: '${topHabit.streakDays} Days',
                  subtitle: '${topHabit.emoji} ${topHabit.habitName}',
                  accentColor: const Color(0xFF00F2FF), // Neon Blue
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniStat(
                  title: 'GOAL SCORE',
                  value: '${review.goalSummary.overallGoalCompletionScore}%',
                  subtitle: '${review.goalSummary.weeklyGoalsCompleted}/${review.goalSummary.weeklyGoalsTotal} Weekly Goals',
                  accentColor: const Color(0xFFFF0055), // Neon Pink
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 12-Month Weather Strip
          const Text(
            '12-MONTH WEATHER SKYLINE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.01),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(12, (index) {
                final emoji = review.weatherSummary.monthlyWeatherStrip.length > index
                    ? review.weatherSummary.monthlyWeatherStrip[index]
                    : '☀️';
                final monthName = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'][index];

                return Column(
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      monthName,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 24),

          // Footer Quote / Branding
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '“Your habits. Your weather. Your legacy.”',
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Image.network(
                'https://api.placeholder.com/20x20', // just a mock logo asset placeholder
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB3FF00),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required String title,
    required String value,
    required String subtitle,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

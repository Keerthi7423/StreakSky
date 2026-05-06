import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/core/constants/app_colors.dart';
import 'package:streaksky/features/habits/presentation/controllers/habit_controller.dart';
import '../controllers/streak_controller.dart';

class StreakLeaderboard extends ConsumerWidget {
  const StreakLeaderboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final habitsAsync = ref.watch(habitsListProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '🏆',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Bests',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Your all-time top streaks',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          leaderboardAsync.when(
            data: (streaks) {
              if (streaks.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No streaks yet. Start your journey!',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                );
              }

              return Column(
                children: streaks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final streak = entry.value;
                  
                  return habitsAsync.when(
                    data: (habits) {
                      final habit = habits.firstWhere(
                        (h) => h.id == streak.habitId,
                        orElse: () => habits.first,
                      );
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _getRankColor(index).withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _getRankColor(index),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: _getRankColor(index),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              habit.emoji ?? '🔥',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                habit.name,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${streak.longestStreak} days',
                                  style: const TextStyle(
                                    color: AppColors.primaryAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (streak.currentStreak > 0)
                                  Text(
                                    'Active 🔥',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryAccent),
            ),
            error: (err, stack) => Center(
              child: Text(
                'Error loading leaderboard',
                style: TextStyle(color: AppColors.storm),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // Gold
      case 1:
        return const Color(0xFFC0C0C0); // Silver
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.textSecondary;
    }
  }
}

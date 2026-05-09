import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import 'package:intl/intl.dart';
import '../../domain/models/goal_model.dart';
import './goal_projection_chart.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback? onTap;

  const GoalCard({
    super.key,
    required this.goal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal.progress;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: goal.isCompleted 
              ? AppColors.primaryAccent.withOpacity(0.5) 
              : AppColors.divider,
          width: goal.isCompleted ? 1.5 : 1.0,
        ),
        boxShadow: goal.isCompleted ? [
          BoxShadow(
            color: AppColors.primaryAccent.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 1,
          )
        ] : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.type.name.toUpperCase(),
                            style: AppTypography.micro.copyWith(
                              color: AppColors.primaryAccent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            goal.title.toUpperCase(),
                            style: AppTypography.h3.copyWith(letterSpacing: 1.1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (goal.isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'COMPLETED',
                          style: AppTypography.micro.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      const Icon(Icons.flag_outlined, color: AppColors.textTertiary, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                if (goal.description != null && goal.description!.isNotEmpty) ...[
                  Text(
                    goal.description!,
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PROGRESS',
                      style: AppTypography.micro.copyWith(letterSpacing: 1.0, color: AppColors.textTertiary),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: AppTypography.micro.copyWith(
                        color: goal.isCompleted ? AppColors.primaryAccent : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.elevatedSurface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 8,
                      width: MediaQuery.of(context).size.width * progress * 0.8, // Approximation for the card width
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryAccent.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (goal.type != GoalType.career) ...[
                  Text(
                    'PROJECTION',
                    style: AppTypography.micro.copyWith(letterSpacing: 1.0, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 8),
                  GoalProjectionChart(goal: goal),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    const Icon(Icons.sync, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      '${goal.currentValue} / ${goal.targetValue ?? '∞'}',
                      style: AppTypography.micro.copyWith(color: AppColors.textSecondary),
                    ),
                    const Spacer(),
                    if (goal.type != GoalType.career)
                      _buildResetIndicator(goal),
                    if (goal.linkedHabits.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.divider),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${goal.linkedHabits.length} HABITS',
                          style: AppTypography.micro.copyWith(color: AppColors.textTertiary),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetIndicator(GoalModel goal) {
    final now = DateTime.now();
    String resetText = '';
    
    if (goal.type == GoalType.weekly) {
      final daysToMonday = (8 - now.weekday) % 7;
      final nextMonday = now.add(Duration(days: daysToMonday == 0 ? 7 : daysToMonday));
      final daysLeft = nextMonday.difference(now).inDays;
      resetText = 'RESETS IN $daysLeft DAYS';
    } else if (goal.type == GoalType.monthly) {
      final nextMonth = DateTime(now.year, now.month + 1, 1);
      final daysLeft = nextMonth.difference(now).inDays;
      resetText = 'RESETS IN $daysLeft DAYS';
    }

    return Text(
      resetText,
      style: AppTypography.micro.copyWith(
        color: AppColors.primaryAccent.withOpacity(0.7),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

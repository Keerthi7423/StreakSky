import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/models/goal_model.dart';

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

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      goal.title.toUpperCase(),
                      style: AppTypography.h3.copyWith(letterSpacing: 1.1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (goal.isCompleted)
                    const Icon(Icons.check_circle, color: AppColors.primaryAccent, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              if (goal.description != null && goal.description!.isNotEmpty) ...[
                Text(
                  goal.description!,
                  style: AppTypography.caption,
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
                    style: AppTypography.micro.copyWith(letterSpacing: 1.0),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTypography.micro.copyWith(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.elevatedSurface,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.sync, size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(
                    '${goal.currentValue} / ${goal.targetValue ?? '∞'}',
                    style: AppTypography.micro,
                  ),
                  const Spacer(),
                  if (goal.linkedHabits.isNotEmpty)
                    Text(
                      '${goal.linkedHabits.length} HABITS LINKED',
                      style: AppTypography.micro.copyWith(color: AppColors.textSecondary),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

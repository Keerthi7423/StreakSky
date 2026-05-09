import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/models/goal_model.dart';

class CareerTimeline extends StatelessWidget {
  final List<GoalModel> goals;

  const CareerTimeline({
    super.key,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    // Sort goals by phase, then by creation date
    final sortedGoals = List<GoalModel>.from(goals)
      ..sort((a, b) {
        if (a.phase != null && b.phase != null) {
          return a.phase!.compareTo(b.phase!);
        }
        if (a.phase != null) return -1;
        if (b.phase != null) return 1;
        return (a.createdAt ?? DateTime.now()).compareTo(b.createdAt ?? DateTime.now());
      });

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.horizontalPadding,
        vertical: 24,
      ),
      itemCount: sortedGoals.length,
      itemBuilder: (context, index) {
        final goal = sortedGoals[index];
        final isLast = index == sortedGoals.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline Column
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    // Dot
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: goal.isCompleted ? AppColors.primaryAccent : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryAccent,
                          width: 2,
                        ),
                        boxShadow: goal.isCompleted ? [
                          BoxShadow(
                            color: AppColors.primaryAccent.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          )
                        ] : [],
                      ),
                    ),
                    // Line
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: AppColors.divider,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                  ],
                ),
              ),
              // Content Column
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: goal.isMilestone 
                                  ? AppColors.primaryAccent.withOpacity(0.1)
                                  : AppColors.elevatedSurface,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: goal.isMilestone 
                                    ? AppColors.primaryAccent.withOpacity(0.3)
                                    : AppColors.divider,
                              ),
                            ),
                            child: Text(
                              goal.isMilestone ? 'MILESTONE' : 'MISSION',
                              style: AppTypography.micro.copyWith(
                                color: goal.isMilestone ? AppColors.primaryAccent : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                              ),
                            ),
                          ),
                          if (goal.rolledOver) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.partlyCloudy.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.partlyCloudy.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.history, size: 8, color: AppColors.partlyCloudy),
                                  const SizedBox(width: 2),
                                  Text(
                                    'ROLLED OVER',
                                    style: AppTypography.micro.copyWith(
                                      color: AppColors.partlyCloudy,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const Spacer(),
                          if (goal.phase != null)
                            Text(
                              'PHASE ${goal.phase}',
                              style: AppTypography.micro.copyWith(color: AppColors.textTertiary),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        goal.title.toUpperCase(),
                        style: AppTypography.h3.copyWith(
                          color: goal.isCompleted ? AppColors.primaryAccent : AppColors.textPrimary,
                        ),
                      ),
                      if (goal.description != null && goal.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          goal.description!,
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                      const SizedBox(height: 12),
                      // Progress Mini Bar
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.elevatedSurface,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: goal.progress,
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: goal.isCompleted ? AppColors.primaryAccent : AppColors.textSecondary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${(goal.progress * 100).toInt()}%',
                            style: AppTypography.micro.copyWith(
                              color: goal.isCompleted ? AppColors.primaryAccent : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

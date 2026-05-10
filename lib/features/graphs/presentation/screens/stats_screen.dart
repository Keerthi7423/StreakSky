import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/core/constants/app_colors.dart';
import 'package:streaksky/core/constants/app_typography.dart';
import '../../../streaks/presentation/widgets/streak_leaderboard.dart';
import '../../../heatmap/presentation/controllers/heatmap_controller.dart';
import '../../../heatmap/presentation/widgets/heatmap_grid.dart';
import '../../../heatmap/presentation/widgets/heatmap_year_selector.dart';
import 'package:intl/intl.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heatmapState = ref.watch(heatmapControllerProvider);
    final heatmapNotifier = ref.read(heatmapControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Statistics',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StreakLeaderboard(),
            const SizedBox(height: 24),
            
            const Text('Consistency Heatmap', style: AppTypography.h3),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    HeatmapYearSelector(
                      selectedYear: heatmapState.selectedYear,
                      years: const [2024, 2025, 2026],
                      onYearSelected: (year) => heatmapNotifier.changeYear(year),
                    ),
                    const SizedBox(height: 16),
                    if (heatmapState.isLoading)
                      const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      HeatmapGrid(
                        year: heatmapState.selectedYear,
                        percentages: heatmapState.dailyCompletionPercentages,
                        comebackDates: heatmapState.comebackDates,
                        onCellTap: (date) => _showDayDetails(context, date, heatmapState),
                      ),
                    const SizedBox(height: 12),
                    _buildLegend(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            
            // Placeholder for other stats (Task 71, 72 etc.)
            const Text('Insights', style: AppTypography.h3),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  _buildStatRow('Active Days', heatmapState.dailyCompletionCounts.values.where((c) => c > 0).length.toString()),
                  const Divider(height: 24),
                  _buildStatRow('Comebacks', heatmapState.comebackDates.length.toString()),
                  const Divider(height: 24),
                  const Text(
                    'More analytics coming soon...',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.body),
        Text(value, style: AppTypography.h3.copyWith(color: AppColors.primaryAccent)),
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Less', style: TextStyle(color: Colors.grey, fontSize: 8)),
            const SizedBox(width: 4),
            _legendBox(AppColors.heatmapEmpty),
            _legendBox(AppColors.heatmapLevel1),
            _legendBox(AppColors.heatmapLevel2),
            _legendBox(AppColors.heatmapLevel3),
            _legendBox(AppColors.heatmapLevel4),
            const SizedBox(width: 4),
            const Text('More', style: TextStyle(color: Colors.grey, fontSize: 8)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _legendBox(AppColors.rainbow),
            const Text(' Comeback', style: TextStyle(color: Colors.grey, fontSize: 8)),
          ],
        ),
      ],
    );
  }

  Widget _legendBox(Color color) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  void _showDayDetails(BuildContext context, DateTime date, HeatmapState state) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final count = state.dailyCompletionCounts[dateStr] ?? 0;
    final percentage = state.dailyCompletionPercentages[dateStr] ?? 0.0;
    final isComeback = state.comebackDates.contains(dateStr);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d').format(date),
                  style: AppTypography.h2,
                ),
                if (isComeback)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.rainbow.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.rainbow),
                    ),
                    child: const Text(
                      'COMEBACK!',
                      style: TextStyle(color: AppColors.rainbow, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_outline, color: AppColors.primaryAccent),
              title: const Text('Habits Completed'),
              trailing: Text(
                count.toString(),
                style: AppTypography.h3.copyWith(color: AppColors.primaryAccent),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.analytics_outlined, color: AppColors.textSecondary),
              title: const Text('Completion Rate'),
              trailing: Text(
                '${(percentage * 100).toInt()}%',
                style: AppTypography.h3,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

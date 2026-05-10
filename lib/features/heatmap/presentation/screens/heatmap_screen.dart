import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../controllers/heatmap_controller.dart';
import '../widgets/heatmap_grid.dart';
import '../widgets/heatmap_year_selector.dart';

class HeatmapScreen extends ConsumerWidget {
  const HeatmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(heatmapControllerProvider);
    final notifier = ref.read(heatmapControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Heatmap'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yearly Progress',
                    style: AppTypography.h2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Consistency visualization over time',
                    style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          HeatmapYearSelector(
                            selectedYear: state.selectedYear,
                            years: const [2024, 2025, 2026],
                            onYearSelected: (year) => notifier.changeYear(year),
                          ),
                          const SizedBox(height: 24),
                          HeatmapGrid(
                            year: state.selectedYear,
                            percentages: state.dailyCompletionPercentages,
                            comebackDates: state.comebackDates,
                            onCellTap: (date) => _showDayDetails(context, date, state),
                          ),
                          const SizedBox(height: 16),
                          _buildLegend(),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  _buildStatsSection(state),
                ],
              ),
            ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Less', style: TextStyle(color: Colors.grey, fontSize: 10)),
        const SizedBox(width: 4),
        _legendBox(AppColors.heatmapEmpty),
        _legendBox(AppColors.heatmapLevel1),
        _legendBox(AppColors.heatmapLevel2),
        _legendBox(AppColors.heatmapLevel3),
        _legendBox(AppColors.heatmapLevel4),
        const SizedBox(width: 4),
        const Text('More', style: TextStyle(color: Colors.grey, fontSize: 10)),
        const SizedBox(width: 12),
        _legendBox(AppColors.rainbow),
        const Text(' Comeback', style: TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _legendBox(Color color) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildStatsSection(HeatmapState state) {
    final totalDays = state.dailyCompletionCounts.length;
    final activeDays = state.dailyCompletionCounts.values.where((c) => c > 0).length;
    final consistency = totalDays > 0 ? (activeDays / 365 * 100).toStringAsFixed(1) : '0.0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Insights', style: AppTypography.h3),
        const SizedBox(height: 16),
        Row(
          children: [
            _statCard('Active Days', activeDays.toString()),
            const SizedBox(width: 12),
            _statCard('Yearly Pace', '$consistency%'),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    return Expanded(
      child: Card(
        color: AppColors.elevatedSurface,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.sectionLabel),
              const SizedBox(height: 8),
              Text(value, style: AppTypography.display.copyWith(fontSize: 24)),
            ],
          ),
        ),
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

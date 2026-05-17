import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../controllers/heatmap_controller.dart';
import '../widgets/heatmap_grid.dart';
import '../widgets/heatmap_year_selector.dart';

class HeatmapScreen extends ConsumerStatefulWidget {
  const HeatmapScreen({super.key});

  @override
  ConsumerState<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends ConsumerState<HeatmapScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(heatmapControllerProvider);
    final notifier = ref.read(heatmapControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Heatmap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _exportHeatmap(context),
            tooltip: 'Export Heatmap',
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(state),
                  const SizedBox(height: 20),
                  _buildHabitFilters(state, notifier),
                  const SizedBox(height: 24),
                  
                  Screenshot(
                    controller: _screenshotController,
                    child: Container(
                      color: AppColors.background,
                      child: Column(
                        children: [
                          if (state.isMultiYearView)
                            _buildMultiYearGrids(state)
                          else
                            _buildSingleYearCard(state, notifier),
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

  Widget _buildHeader(HeatmapState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yearly Progress',
              style: AppTypography.h2,
            ),
            const SizedBox(height: 4),
            Text(
              'Consistency visualization over time',
              style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Multi-year', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Switch(
              value: state.isMultiYearView,
              onChanged: (_) => ref.read(heatmapControllerProvider.notifier).toggleMultiYearView(),
              activeThumbColor: AppColors.primaryAccent,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHabitFilters(HeatmapState state, HeatmapController notifier) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('All Habits'),
              selected: state.selectedHabitId == null,
              onSelected: (selected) => notifier.selectHabit(null),
              selectedColor: AppColors.primaryAccent,
              labelStyle: TextStyle(
                color: state.selectedHabitId == null ? AppColors.background : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...state.habits.map((habit) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(habit.name),
              selected: state.selectedHabitId == habit.id,
              onSelected: (selected) => notifier.selectHabit(selected ? habit.id : null),
              selectedColor: AppColors.primaryAccent,
              labelStyle: TextStyle(
                color: state.selectedHabitId == habit.id ? AppColors.background : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSingleYearCard(HeatmapState state, HeatmapController notifier) {
    return Card(
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
    );
  }

  Widget _buildMultiYearGrids(HeatmapState state) {
    final years = [2024, 2025, 2026];
    return Column(
      children: years.map((year) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$year', style: AppTypography.h3.copyWith(color: AppColors.primaryAccent)),
                const SizedBox(height: 16),
                HeatmapGrid(
                  year: year,
                  percentages: state.multiYearPercentages[year] ?? {},
                  comebackDates: const {}, // Comebacks not shown in multi-year for simplicity
                  onCellTap: (date) => _showDayDetails(context, date, state),
                ),
              ],
            ),
          ),
        ),
      )).toList(),
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
    final totalDays = state.isMultiYearView ? 365 * 3 : state.dailyCompletionPercentages.length;
    final activeDays = state.isMultiYearView 
        ? state.multiYearPercentages.values.fold(0, (sum, yearData) => sum + yearData.values.where((v) => v > 0).length)
        : state.dailyCompletionPercentages.values.where((v) => v > 0).length;
    
    final consistency = totalDays > 0 ? (activeDays / (state.isMultiYearView ? 1095 : 365) * 100).toStringAsFixed(1) : '0.0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Insights', style: AppTypography.h3),
        const SizedBox(height: 16),
        Row(
          children: [
            _statCard('Active Days', activeDays.toString()),
            const SizedBox(width: 12),
            _statCard(state.isMultiYearView ? 'Overall Pace' : 'Yearly Pace', '$consistency%'),
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

  Future<void> _exportHeatmap(BuildContext context) async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/heatmap_export.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      await SharePlus.instance.share(
        ShareParams(
          text: 'Check out my Habit Heatmap on StreakSky! 🚀 #StreakSky #HabitTracker',
          files: [XFile(imagePath)],
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export heatmap: $e')),
        );
      }
    }
  }

  void _showDayDetails(BuildContext context, DateTime date, HeatmapState state) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    
    double percentage = 0.0;
    if (state.isMultiYearView) {
      percentage = state.multiYearPercentages[date.year]?[dateStr] ?? 0.0;
    } else {
      percentage = state.dailyCompletionPercentages[dateStr] ?? 0.0;
    }
    
    final isComeback = !state.isMultiYearView && state.comebackDates.contains(dateStr);

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
                  DateFormat('EEEE, MMMM d, yyyy').format(date),
                  style: AppTypography.h2,
                ),
                if (isComeback)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.rainbow.withValues(alpha: 0.2),
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
              leading: const Icon(Icons.analytics_outlined, color: AppColors.primaryAccent),
              title: const Text('Completion Rate'),
              trailing: Text(
                '${(percentage * 100).toInt()}%',
                style: AppTypography.h3.copyWith(color: AppColors.primaryAccent),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.elevatedSurface,
                  foregroundColor: AppColors.textPrimary,
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

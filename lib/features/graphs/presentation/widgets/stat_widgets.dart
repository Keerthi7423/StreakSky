import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:streaksky/core/constants/app_colors.dart';
import 'package:streaksky/core/constants/app_typography.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final List<double> waveformData;
  final Color accentColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.waveformData,
    this.accentColor = AppColors.primaryAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 30,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (waveformData.length - 1).toDouble(),
                minY: 0,
                maxY: 1,
                lineBarsData: [
                  LineChartBarData(
                    spots: waveformData.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList(),
                    isCurved: true,
                    color: accentColor,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: accentColor.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyTrendChart extends StatelessWidget {
  final List<double> data;

  const WeeklyTrendChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Trend', style: AppTypography.h3),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (data.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.surface,
                    tooltipBorderRadius: BorderRadius.circular(8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toInt().toString(),
                        const TextStyle(
                          color: AppColors.primaryAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        final index = value.toInt();
                        if (index < 0 || index >= 7) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            days[index],
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: data.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        color: AppColors.primaryAccent,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: (data.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
                          color: AppColors.divider.withValues(alpha: 0.05),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailedLineChart extends StatelessWidget {
  final List<double> data;
  final String title;
  final Color accentColor;
  final bool showTooltips;

  const DetailedLineChart({
    super.key,
    required this.data,
    required this.title,
    this.accentColor = AppColors.primaryAccent,
    this.showTooltips = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.fromLTRB(16, 24, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.h3),
          const SizedBox(height: 32),
          Expanded(
            child: RepaintBoundary(
              child: LineChart(
                _getOptimizedLineChartData(),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _getOptimizedLineChartData() {
    // Task 78: Optimize chart rendering for long historical data sets
    // Downsampling logic for large data sets
    List<FlSpot> spots = [];
    if (data.length > 50) {
      final int step = (data.length / 50).ceil();
      for (int i = 0; i < data.length; i += step) {
        spots.add(FlSpot(i.toDouble(), data[i]));
      }
    } else {
      spots = data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
    }

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: showTooltips,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppColors.surface,
          tooltipBorderRadius: BorderRadius.circular(12),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                spot.y.toInt().toString(),
                TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) => FlLine(
          color: AppColors.divider.withValues(alpha: 0.05),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: data.length > 10 ? (data.length / 5).toDouble() : 1,
            getTitlesWidget: (value, meta) {
              if (value % 1 != 0) return const SizedBox();
              final index = value.toInt();
              if (index < 0 || index >= data.length) return const SizedBox();
              
              String text = '';
              if (data.length <= 7) {
                text = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index];
              } else if (data.length <= 31) {
                if (index % 5 == 0) text = '${index + 1}';
              } else {
                text = 'M${index + 1}';
              }

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (data.length - 1).toDouble(),
      minY: 0,
      maxY: (data.reduce((a, b) => a > b ? a : b) * 1.2).toDouble() + 1,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: accentColor,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: data.length <= 7,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
              radius: 4,
              color: AppColors.background,
              strokeWidth: 2,
              strokeColor: accentColor,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                accentColor.withValues(alpha: 0.3),
                accentColor.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}

class KeystoneHabitCard extends StatelessWidget {
  final String habitName;
  final double correlation;

  const KeystoneHabitCard({
    super.key,
    required this.habitName,
    required this.correlation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryAccent.withValues(alpha: 0.15),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.primaryAccent, size: 20),
              ),
              const SizedBox(width: 16),
              const Text('Keystone Habit', style: AppTypography.h3),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Your success is driven by:',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(habitName, style: AppTypography.h2),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Correlation Strength',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: correlation,
                        backgroundColor: AppColors.divider.withValues(alpha: 0.1),
                        valueColor: const AlwaysStoppedAnimation(AppColors.primaryAccent),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Text(
                '${(correlation * 100).toInt()}%',
                style: AppTypography.h2.copyWith(color: AppColors.primaryAccent),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Completing this habit increases your overall daily success by ${(correlation * 100).toInt()}%.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class ActivityCalendarStrip extends StatelessWidget {
  const ActivityCalendarStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Get the start of the week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACTIVITY CALENDAR',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final day = startOfWeek.add(Duration(days: index));
            final isToday = day.day == now.day && day.month == now.month && day.year == now.year;
            final dayName = ['S', 'M', 'T', 'W', 'T', 'F', 'S'][day.weekday % 7];
            
            return Column(
              children: [
                Text(
                  dayName,
                  style: TextStyle(
                    color: isToday ? AppColors.primaryAccent : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isToday ? AppColors.primaryAccent : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isToday ? AppColors.primaryAccent : AppColors.divider.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: isToday ? Colors.black : AppColors.textPrimary,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class RecentHabitCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String date;
  final Color color;

  const RecentHabitCard({
    super.key,
    required this.emoji,
    required this.name,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
          const Spacer(),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

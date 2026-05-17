import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/models/goal_model.dart';
import '../../domain/services/goal_projection_service.dart';

class GoalProjectionChart extends StatelessWidget {
  final GoalModel goal;

  const GoalProjectionChart({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final data = GoalProjectionService.generateProjection(goal);
    
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.labels.length && index % (data.labels.length ~/ 4 + 1) == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        data.labels[index],
                        style: AppTypography.micro.copyWith(color: AppColors.textTertiary),
                      ),
                    );
                  }
                  return const SizedBox();
                },
                reservedSize: 20,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            // Ideal Path
            LineChartBarData(
              spots: data.idealPoints.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: false,
              color: AppColors.textTertiary.withValues(alpha: 0.3),
              barWidth: 1,
              dotData: const FlDotData(show: false),
              dashArray: [5, 5],
            ),
            // Actual Path
            LineChartBarData(
              spots: data.actualPoints.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              color: AppColors.primaryAccent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryAccent.withValues(alpha: 0.2),
                    AppColors.primaryAccent.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

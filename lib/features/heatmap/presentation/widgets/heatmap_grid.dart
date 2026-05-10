import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/streak_date_utils.dart';
import './heatmap_cell.dart';

class HeatmapGrid extends StatelessWidget {
  final int year;
  final Map<String, double> percentages;
  final Set<String> comebackDates;
  final Function(DateTime date)? onCellTap;

  const HeatmapGrid({
    super.key,
    required this.year,
    required this.percentages,
    required this.comebackDates,
    this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfYear = DateTime(year, 1, 1);
    final lastDayOfYear = DateTime(year, 12, 31);
    
    // Calculate how many days to show. GitHub usually shows a bit of the previous year 
    // to fill the first week, but here we'll just show the year's days.
    // GitHub style: Rows = Days of week (Mon-Sun), Columns = Weeks
    
    // Adjust start to the beginning of the week (Monday)
    // DateTime.monday = 1
    final int startPadding = firstDayOfYear.weekday - 1;
    final totalDays = lastDayOfYear.difference(firstDayOfYear).inDays + 1;
    final totalCells = totalDays + startPadding;
    final totalWeeks = (totalCells / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthLabels(totalWeeks),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeekdayLabels(),
            const SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 100, // 7 cells + spacing
                  width: totalWeeks * 14.0, // 12px cell + 2px spacing
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 1,
                    ),
                    itemCount: totalCells,
                    itemBuilder: (context, index) {
                      if (index < startPadding) {
                        return const SizedBox.shrink();
                      }
                      
                      final currentDay = firstDayOfYear.add(Duration(days: index - startPadding));
                      final dateStr = StreakDateUtils.formatDate(currentDay);
                      
                      return HeatmapCell(
                        percentage: percentages[dateStr] ?? 0.0,
                        isComeback: comebackDates.contains(dateStr),
                        onTap: () => onCellTap?.call(currentDay),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    final labels = ['Mon', '', 'Wed', '', 'Fri', '', 'Sun'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.map((label) => SizedBox(
        height: 12,
        child: Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
      )).toList(),
    );
  }

  Widget _buildMonthLabels(int totalWeeks) {
    return const Padding(
      padding: EdgeInsets.only(left: 32.0), // Match weekday labels width
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Jan', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('Mar', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('Jun', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('Sep', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('Dec', style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class HeatmapYearSelector extends StatelessWidget {
  final int selectedYear;
  final List<int> years;
  final Function(int year) onYearSelected;

  const HeatmapYearSelector({
    super.key,
    required this.selectedYear,
    required this.years,
    required this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: years.map((year) {
        final isSelected = year == selectedYear;
        return ChoiceChip(
          label: Text(
            year.toString(),
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) onYearSelected(year);
          },
          selectedColor: AppColors.primaryAccent,
          backgroundColor: AppColors.surface,
          showCheckmark: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
    );
  }
}

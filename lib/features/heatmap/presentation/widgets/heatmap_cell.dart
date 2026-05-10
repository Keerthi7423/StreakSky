import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class HeatmapCell extends StatelessWidget {
  final double percentage;
  final bool isComeback;
  final VoidCallback? onTap;

  const HeatmapCell({
    super.key,
    required this.percentage,
    this.isComeback = false,
    this.onTap,
  });

  Color _getCellColor() {
    if (isComeback) return AppColors.rainbow;
    if (percentage == 0) return AppColors.heatmapEmpty;
    if (percentage <= 0.25) return AppColors.heatmapLevel1;
    if (percentage <= 0.50) return AppColors.heatmapLevel2;
    if (percentage <= 0.75) return AppColors.heatmapLevel3;
    return AppColors.heatmapLevel4;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _getCellColor(),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

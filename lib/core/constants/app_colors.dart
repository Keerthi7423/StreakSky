import 'package:flutter/material.dart';

class AppColors {
  // Primary Backgrounds
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color elevatedSurface = Color(0xFF242424);
  static const Color divider = Color(0xFF2E2E2E);

  // Accent - Neon Green
  static const Color primaryAccent = Color(0xFFB3FF00);
  static const Color accentHover = Color(0xFF99DD00);
  static const Color accentGlow = Color(0x33B3FF00); // 20% opacity
  static const Color accentSubtle = Color(0x15B3FF00); // 8% opacity

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color textTertiary = Color(0xFF5A5A5A);
  static const Color textAccent = Color(0xFFB3FF00);

  // Status Colors (Weather System)
  static const Color sunny = Color(0xFFB3FF00);
  static const Color partlyCloudy = Color(0xFFFFD600);
  static const Color cloudy = Color(0xFFFF8C00);
  static const Color rainy = Color(0xFF4A9EFF);
  static const Color storm = Color(0xFFFF3B3B);
  static const Color rainbow = Color(0xFFB44FFF);
  static const Color tornado = Color(0xFFFF6B00);

  // Heatmap Levels
  static const Color heatmapEmpty = Color(0xFF1E1E1E);
  static const Color heatmapLevel1 = Color(0xFF3A5A1A);
  static const Color heatmapLevel2 = Color(0xFF5A8C28);
  static const Color heatmapLevel3 = Color(0xFF7DC033);
  static const Color heatmapLevel4 = Color(0xFFB3FF00);

  // Streak Badges
  static const Color streakActive = Color(0xFFB3FF00);
  static const Color streakBroken = Color(0xFF5A5A5A);
  static const Color shieldActive = Color(0xFF4A9EFF);
  static const Color legendary = Color(0xFFFFD600);
  static const Color diamond = Color(0xFF00E5FF);
}

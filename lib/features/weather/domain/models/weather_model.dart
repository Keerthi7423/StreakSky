import 'package:flutter/material.dart';
import 'package:streaksky/core/constants/app_colors.dart';

enum WeatherType {
  sunny(
    label: 'Sunny',
    emoji: '☀️',
    gradientColors: [AppColors.sunny, Color(0xFF8DC000)],
    description: 'Perfect consistency. All habits complete.',
  ),
  partlyCloudy(
    label: 'Partly Cloudy',
    emoji: '⛅',
    gradientColors: [AppColors.partlyCloudy, AppColors.sunny],
    description: 'Great progress. Keep pushing for that clear sky.',
  ),
  cloudy(
    label: 'Cloudy',
    emoji: '🌥️',
    gradientColors: [AppColors.cloudy, Color(0xFFFFB033)],
    description: 'Balanced day. A few clouds but you are still moving.',
  ),
  rainy(
    label: 'Rainy',
    emoji: '🌧️',
    gradientColors: [AppColors.rainy, Color(0xFF0056B3)],
    description: 'Tough day. Rain is just liquid sunshine, keep going.',
  ),
  storm(
    label: 'Storm',
    emoji: '⛈️',
    gradientColors: [AppColors.storm, Color(0xFF8B0000)],
    description: 'Rough patch. Storms don\'t last forever.',
  ),
  rainbow(
    label: 'Rainbow',
    emoji: '🌈',
    gradientColors: [AppColors.rainbow, Color(0xFF5856D6), AppColors.rainy],
    description: 'Stunning comeback! You broke the storm.',
  ),
  tornado(
    label: 'Tornado',
    emoji: '🌪️',
    gradientColors: [AppColors.tornado, Color(0xFF333333)],
    description: 'Streak broken. Rebuild stronger from the debris.',
  );

  final String label;
  final String emoji;
  final List<Color> gradientColors;
  final String description;

  const WeatherType({
    required this.label,
    required this.emoji,
    required this.gradientColors,
    required this.description,
  });

  static WeatherType fromCompletionRate(double rate, {bool isStorm = false, bool isRainbow = false, bool isTornado = false}) {
    if (isTornado) return WeatherType.tornado;
    if (isRainbow) return WeatherType.rainbow;
    if (isStorm) return WeatherType.storm;
    
    if (rate >= 1.0) return WeatherType.sunny;
    if (rate >= 0.6) return WeatherType.partlyCloudy;
    if (rate >= 0.4) return WeatherType.cloudy;
    return WeatherType.rainy;
  }
}

class WeatherModel {
  final WeatherType type;
  final double completionRate;
  final DateTime date;
  final String? message;

  WeatherModel({
    required this.type,
    required this.completionRate,
    required this.date,
    this.message,
  });
}

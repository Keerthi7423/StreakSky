import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/core/constants/app_colors.dart';
import 'package:streaksky/core/constants/app_spacing.dart';
import 'package:streaksky/core/constants/app_typography.dart';
import '../controllers/weather_controller.dart';
import '../../domain/models/weather_model.dart';

class WeatherHeroCard extends ConsumerWidget {
  const WeatherHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    final forecastAsync = ref.watch(weatherForecastProvider);

    return weatherAsync.when(
      data: (weather) => _buildCard(context, weather, forecastAsync.asData?.value ?? []),
      loading: () => _buildLoading(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(BuildContext context, WeatherModel weather, List<WeatherModel> forecast) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius * 1.5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: weather.type.gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: weather.type.gradientColors.first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TODAY\'S SKY',
                            style: AppTypography.sectionLabel.copyWith(
                              color: Colors.white.withOpacity(0.8),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            weather.type.label.toUpperCase(),
                            style: AppTypography.display.copyWith(
                              color: Colors.white,
                              fontSize: 32,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      weather.type.emoji,
                      style: const TextStyle(fontSize: 64),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  weather.message ?? weather.type.description,
                  style: AppTypography.body.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Forecast Strip
                if (forecast.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: forecast.map((f) => Expanded(child: _buildForecastItem(f))).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastItem(WeatherModel weather) {
    final isToday = weather.date.day == DateTime.now().day;
    
    return Column(
      children: [
        Text(
          _getDayName(weather.date),
          style: AppTypography.micro.copyWith(
            color: isToday ? Colors.white : Colors.white.withOpacity(0.6),
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          weather.type.emoji,
          style: const TextStyle(fontSize: 18),
        ),
        if (isToday)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  String _getDayName(DateTime date) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[date.weekday - 1];
  }

  Widget _buildLoading() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primaryAccent),
      ),
    );
  }
}

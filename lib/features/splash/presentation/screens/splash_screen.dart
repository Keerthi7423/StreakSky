import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streaksky/features/auth/presentation/controllers/auth_controller.dart';
import 'package:streaksky/features/habits/presentation/controllers/habit_controller.dart';
import 'package:streaksky/core/utils/haptic_service.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    // Small delay to allow initial setup
    await Future.delayed(const Duration(milliseconds: 500));

    // Try to pre-fetch habits to determine status
    try {
      final habits = await ref.read(todaysHabitsProvider.future);
      final completions = await ref.read(habitCompletionsProvider.future);
      
      if (habits.isNotEmpty) {
        final allCompleted = habits.every((h) => completions.contains(h.id));
        if (allCompleted) {
          // Slow pulse = on track
          HapticService.slowPulse();
        } else {
          // Fast pulse = behind today
          HapticService.fastPulse();
        }
      }
    } catch (e) {
      debugPrint('Heartbeat Error: $e');
    }

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      final user = ref.read(authStateProvider).asData?.value;
      if (user != null) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with neon pulse effect
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB3FF00).withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.cloud_queue,
                size: 100,
                color: Color(0xFFB3FF00),
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.1, 1.1),
                  duration: 2.seconds,
                  curve: Curves.easeInOut,
                )
                .shimmer(
                  duration: 3.seconds,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
            const SizedBox(height: 40),
            // Title with neon glow
            const Text(
              'STREAKSKY',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: 4.0,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Color(0xFFB3FF00),
                    blurRadius: 20,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 10),
            // Particles/Progress indicator
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFB3FF00),
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .scale(
                      duration: 600.ms,
                      delay: (index * 200).ms,
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.2, 1.2),
                    )
                    .fadeOut(
                      duration: 600.ms,
                      delay: (index * 200).ms,
                    );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

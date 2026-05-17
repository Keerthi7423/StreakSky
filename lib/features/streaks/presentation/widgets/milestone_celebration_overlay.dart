import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/streak_controller.dart';

class MilestoneCelebrationOverlay extends ConsumerWidget {
  const MilestoneCelebrationOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milestone = ref.watch(milestoneCelebrationProvider);

    if (milestone == null) return const SizedBox.shrink();

    return Stack(
      children: [
        // Dim background
        GestureDetector(
          onTap: () => ref.read(milestoneCelebrationProvider.notifier).state = null,
          child: Container(
            color: Colors.black.withValues(alpha: 0.8),
          ).animate().fadeIn(duration: 400.ms),
        ),
        
        // Celebration Content
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Badge/Emoji with Spring Animation
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0D0D0D),
                  border: Border.all(
                    color: const Color(0xFFB3FF00), // Neon Green
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB3FF00).withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    milestone.emoji,
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
              )
              .animate()
              .scale(
                duration: 600.ms,
                curve: Curves.elasticOut,
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
              )
              .shimmer(delay: 800.ms, duration: 1200.ms, color: Colors.white24),

              const SizedBox(height: 32),

              // Title
              Text(
                'MILESTONE REACHED!',
                style: TextStyle(
                  color: const Color(0xFFB3FF00),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  shadows: [
                    Shadow(
                      color: const Color(0xFFB3FF00).withValues(alpha: 0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms)
              .slideY(begin: 0.5, end: 0),

              const SizedBox(height: 8),

              // Milestone Name
              Text(
                milestone.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              )
              .animate()
              .fadeIn(delay: 500.ms)
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),

              const SizedBox(height: 16),

              // Days count
              Text(
                '${milestone.days} DAY STREAK',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              )
              .animate()
              .fadeIn(delay: 700.ms),

              const SizedBox(height: 48),

              // Continue Button
              ElevatedButton(
                onPressed: () => ref.read(milestoneCelebrationProvider.notifier).state = null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB3FF00),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'KEEP GOING',
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
              )
              .animate()
              .fadeIn(delay: 900.ms)
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
            ],
          ),
        ),
      ],
    );
  }
}

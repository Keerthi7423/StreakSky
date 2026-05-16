import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/ai_controller.dart';

class AiNudgeCard extends ConsumerWidget {
  const AiNudgeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiState = ref.watch(aiControllerProvider);
    final nudge = aiState.dailyNudge;

    if (nudge == null) {
      // Trigger fetch if not available
      // In a real app, we'd pass actual yesterday's data here
      Future.microtask(() => 
        ref.read(aiControllerProvider.notifier).fetchDailyNudge("4/5 habits completed yesterday. Streak: 12 days.")
      );
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFB3FF00).withOpacity(0.15),
            const Color(0xFFB3FF00).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB3FF00).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFB3FF00).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: Color(0xFFB3FF00), size: 18),
          ).animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 2.seconds, color: const Color(0xFFB3FF00).withOpacity(0.4)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SKY COACH',
                  style: TextStyle(
                    color: const Color(0xFFB3FF00).withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nudge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 500.ms).slideX(begin: 0.1, end: 0);
  }
}

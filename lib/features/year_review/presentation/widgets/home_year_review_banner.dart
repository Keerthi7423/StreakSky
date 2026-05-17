import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeYearReviewBanner extends StatelessWidget {
  const HomeYearReviewBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFB3FF00).withValues(alpha: 0.06),
            const Color(0xFF00F2FF).withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB3FF00).withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB3FF00).withValues(alpha: 0.02),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFB3FF00).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFB3FF00).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '$currentYear ANNUAL',
                  style: const TextStyle(
                    color: Color(0xFFB3FF00),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const Spacer(),
              const Text('✨', style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Your Year in Review is Ready!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Relive your consistency journey, analyze your Weather Skyline, and unlock your Sky AI Agent story summary.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/year-review?year=$currentYear');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB3FF00),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'REVEAL YOUR SKYLINE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.auto_awesome, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

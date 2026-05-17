import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/ai_controller.dart';

class PatternRecognitionCard extends ConsumerStatefulWidget {
  const PatternRecognitionCard({super.key});

  @override
  ConsumerState<PatternRecognitionCard> createState() => _PatternRecognitionCardState();
}

class _PatternRecognitionCardState extends ConsumerState<PatternRecognitionCard> {
  String? _analysis;
  bool _isAnalyzing = false;

  void _analyze() async {
    setState(() => _isAnalyzing = true);
    // Simulate fetching last 30 days data
    const historicalData = "Habit A: 80% completion, Habit B: 40% completion. Misses on weekends.";
    final result = await ref.read(aiControllerProvider.notifier).analyzeUserPatterns(historicalData);
    setState(() {
      _analysis = result;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1A1A),
            const Color(0xFF0D0D0D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFB3FF00).withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB3FF00).withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFB3FF00).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.analytics_outlined, color: Color(0xFFB3FF00), size: 20),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Pattern Recognition',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Unlocked after 30 days of data',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_analysis != null)
            Text(
              _analysis!,
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            ).animate().fadeIn().slideY(begin: 0.1, end: 0)
          else
            const Text(
              'Analyzing your habits to find hidden growth opportunities...',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isAnalyzing ? null : _analyze,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB3FF00),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _isAnalyzing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                    )
                  : const Text('Analyze My Sky', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

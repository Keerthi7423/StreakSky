import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streaksky/features/weather/presentation/controllers/weather_controller.dart';
import 'package:streaksky/features/streaks/presentation/controllers/streak_controller.dart';
import '../../domain/models/quote_model.dart';

class QuoteShareSheet extends ConsumerStatefulWidget {
  final QuoteModel quote;

  const QuoteShareSheet({super.key, required this.quote});

  @override
  ConsumerState<QuoteShareSheet> createState() => _QuoteShareSheetState();
}

class _QuoteShareSheetState extends ConsumerState<QuoteShareSheet> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(weatherProvider);
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Share Quote',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Screenshot(
            controller: _screenshotController,
            child: _buildSharePreview(weatherAsync.asData?.value.type.emoji ?? '☀️', 
                leaderboardAsync.asData?.value.firstOrNull?.currentStreak ?? 0),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _shareImage,
            icon: const Icon(Icons.share_rounded, color: Colors.black),
            label: const Text('Export & Share', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB3FF00),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSharePreview(String weatherEmoji, int streak) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB3FF00).withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'STREAKSKY',
                    style: TextStyle(
                      color: Color(0xFFB3FF00),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    weatherEmoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '🔥 $streak',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Icon(Icons.format_quote_rounded, color: Color(0xFFB3FF00), size: 40),
          const SizedBox(height: 24),
          Text(
            widget.quote.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '— ${widget.quote.author}',
            style: const TextStyle(
              color: Color(0xFFB3FF00),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _shareImage() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/streaksky_quote.png').create();
      await imagePath.writeAsBytes(image);

      await SharePlus.instance.share(
        ShareParams(
          text: 'Check out this quote from StreakSky! 🚀',
          files: [XFile(imagePath.path)],
        ),
      );
    }
  }
}

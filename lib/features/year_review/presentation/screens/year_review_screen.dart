import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/year_review_model.dart';
import '../controllers/year_review_controller.dart';
import '../widgets/shareable_year_card.dart';

class YearReviewScreen extends ConsumerStatefulWidget {
  final int year;

  const YearReviewScreen({
    super.key,
    required this.year,
  });

  @override
  ConsumerState<YearReviewScreen> createState() => _YearReviewScreenState();
}

class _YearReviewScreenState extends ConsumerState<YearReviewScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalSlides = 6;
  bool _showShareSuccess = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Generate/load review data on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(yearReviewControllerProvider.notifier).generateReview(widget.year);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalSlides - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(yearReviewControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: state.when(
          data: (review) {
            if (review == null) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFB3FF00)),
              );
            }
            return Stack(
              children: [
                // Background Glows
                Positioned(
                  top: -100,
                  left: -100,
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFB3FF00).withValues(alpha: 0.03),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  right: -100,
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00F2FF).withValues(alpha: 0.03),
                        ),
                      ),
                    ),
                  ),
                ),

                // Main Content PageView
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 12),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      _buildIntroSlide(review),
                      _buildHabitsSlide(review),
                      _buildWeatherSlide(review),
                      _buildGoalsSlide(review),
                      _buildAiNarrativeSlide(review),
                      _buildShareSlide(review),
                    ],
                  ),
                ),

                // Top Progress Indicators
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: List.generate(_totalSlides, (index) {
                      return Expanded(
                        child: Container(
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: index <= _currentPage
                                ? const Color(0xFFB3FF00)
                                : Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Top Row Controls (Close button)
                Positioned(
                  top: 24,
                  right: 16,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 28,
                    ),
                    onPressed: () => context.pop(),
                  ),
                ),

                // Left/Right Tap Overlays to navigate (Instagram story style)
                Positioned.fill(
                  child: Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _previousPage,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _nextPage,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Navigation controls (Next / Done buttons)
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: _currentPage == _totalSlides - 1
                      ? SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => context.pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB3FF00),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 8,
                              shadowColor: const Color(0xFFB3FF00).withValues(alpha: 0.3),
                            ),
                            child: const Text(
                              'FINISH REVIEW',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                _pageController.animateToPage(
                                  _totalSlides - 1,
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOutCubic,
                                );
                              },
                              child: Text(
                                'SKIP',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Color(0xFFB3FF00),
                                size: 28,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFB3FF00).withValues(alpha: 0.1),
                                padding: const EdgeInsets.all(12),
                                side: const BorderSide(color: Color(0xFFB3FF00), width: 1),
                              ),
                              onPressed: _nextPage,
                            ),
                          ],
                        ),
                ),

                // Success celebration popup
                if (_showShareSuccess)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.85),
                      child: Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, val, child) {
                            return Transform.scale(
                              scale: val,
                              child: Opacity(
                                opacity: val,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(32),
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: const Color(0xFF161616),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFFB3FF00), width: 1.5),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '✨',
                                  style: TextStyle(fontSize: 64),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'YEAR CARD SAVED!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your annual reflection has been exported to your photos gallery. Share your streak with the world!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.7),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _showShareSuccess = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFB3FF00),
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('AWESOME'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFFB3FF00)),
                SizedBox(height: 24),
                Text(
                  'Reading your skyline...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Summarizing streaks and weather patterns',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          error: (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⛈️', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to generate Year Review',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    err.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => ref.read(yearReviewControllerProvider.notifier).generateReview(widget.year),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB3FF00), foregroundColor: Colors.black),
                    child: const Text('TRY AGAIN'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // SLIDE 1: Intro Screen
  Widget _buildIntroSlide(YearReviewModel review) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🌟',
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 32),
          Text(
            'YOUR ${review.year} IN REVIEW',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 3.0,
              color: Color(0xFFB3FF00),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'A Year in the Clouds',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Let\'s take a journey back through the habits you built, the weather you braved, and the milestones you hit this year.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withValues(alpha: 0.6),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 48),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 1),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('👉  Tappable story controls  ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  Icon(Icons.touch_app_outlined, color: const Color(0xFFB3FF00).withValues(alpha: 0.8), size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SLIDE 2: Habit Report Card List
  Widget _buildHabitsSlide(YearReviewModel review) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📝',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          const Text(
            'HABIT REPORT CARD',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Color(0xFFB3FF00),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your Core Engines',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: review.habitReports.length,
            itemBuilder: (context, index) {
              final report = review.habitReports[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
                child: Row(
                  children: [
                    // Icon Bubble
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(int.parse('FF${report.colorHex}', radix: 16)).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(int.parse('FF${report.colorHex}', radix: 16)).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          report.emoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Title & Completions
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${report.totalCompletions} completions • Streak: ${report.longestStreak}d',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Completion Rate & Trend Badge
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(report.completionRate * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(int.parse('FF${report.colorHex}', radix: 16)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: report.trend == 'improving'
                                ? Colors.green.withValues(alpha: 0.1)
                                : report.trend == 'declining'
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                report.trend == 'improving'
                                    ? Icons.arrow_upward
                                    : report.trend == 'declining'
                                        ? Icons.arrow_downward
                                        : Icons.trending_flat,
                                size: 10,
                                color: report.trend == 'improving'
                                    ? Colors.green
                                    : report.trend == 'declining'
                                        ? Colors.red
                                        : Colors.white54,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                report.trend.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: report.trend == 'improving'
                                      ? Colors.green
                                      : report.trend == 'declining'
                                          ? Colors.red
                                          : Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // SLIDE 3: Weather Year Summary
  Widget _buildWeatherSlide(YearReviewModel review) {
    final ws = review.weatherSummary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '☀️',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          const Text(
            'HABIT WEATHER SYSTEM',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Color(0xFFB3FF00),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your Yearly Skyline',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 36),

          // Glowing Sun Circle & Sunny Days count
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glowing background
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFB700).withValues(alpha: 0.15),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.02),
                    border: Border.all(
                      color: const Color(0xFFFFB700).withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '☀️',
                        style: TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${ws.totalSunnyDays}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'SUNNY DAYS',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Weather Summary Details
          Text(
            ws.summaryText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Grid breakdown
          Row(
            children: [
              Expanded(
                child: _buildWeatherMiniBadge(
                  title: 'STORMY DAYS',
                  value: '${ws.totalStormyDays}',
                  emoji: '⛈️',
                  accentColor: Colors.deepPurpleAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWeatherMiniBadge(
                  title: 'BEST MONTH',
                  value: ws.bestWeatherMonth,
                  emoji: '👑',
                  accentColor: const Color(0xFFB3FF00),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherMiniBadge({
    required String title,
    required String value,
    required String emoji,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.01),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.4)),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: accentColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // SLIDE 4: Goals Summary & Streak Hall of Fame
  Widget _buildGoalsSlide(YearReviewModel review) {
    final gs = review.goalSummary;
    final sh = review.streakHallOfFame;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '👑',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          const Text(
            'GOALS & CELEBRATIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Color(0xFFB3FF00),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Streak Hall of Fame',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Overall goal completion score
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFB3FF00).withValues(alpha: 0.05), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFB3FF00).withValues(alpha: 0.15)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Goal Completion Score',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70),
                    ),
                    Text(
                      '${gs.overallGoalCompletionScore}%',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFB3FF00)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: gs.overallGoalCompletionScore / 100,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB3FF00)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildGoalFraction('Weekly', gs.weeklyGoalsCompleted, gs.weeklyGoalsTotal),
                    _buildGoalFraction('Monthly', gs.monthlyGoalsCompleted, gs.monthlyGoalsTotal),
                    _buildGoalFraction('Career', gs.careerMilestonesHit, gs.careerMilestonesTotal),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Streak Hall of Fame items
          const Text(
            'TOP LONG RUNS',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ...List.generate(sh.topLongestStreaks.length, (idx) {
            final item = sh.topLongestStreaks[idx];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.01),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
              ),
              child: Row(
                children: [
                  Text(
                    '#${idx + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: idx == 0
                          ? const Color(0xFFB3FF00)
                          : idx == 1
                              ? const Color(0xFF00F2FF)
                              : const Color(0xFFFF0055),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(item.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.habitName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Text(
                    '${item.streakDays} days',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGoalFraction(String label, int val, int total) {
    return Column(
      children: [
        Text(
          '$val/$total',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.4)),
        ),
      ],
    );
  }

  // SLIDE 5: AI Year Narrative (Sky AI chat narrative)
  Widget _buildAiNarrativeSlide(YearReviewModel review) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🤖',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          const Text(
            'SKY AI YEAR ANALYSIS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Color(0xFF00F2FF),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your Growth Story',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 36),

          // Premium AI Bubble
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF00F2FF).withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF00F2FF).withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Head Row
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00F2FF).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.auto_awesome,
                              color: Color(0xFF00F2FF),
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sky AI Agent',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Weather Coach Persona',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // AI Narrative Text
                    Text(
                      '“${review.aiNarrative}”',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 60), // Space for bottom controls
        ],
      ),
    );
  }

  // SLIDE 6: Share Card & Options
  Widget _buildShareSlide(YearReviewModel review) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '✨',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          const Text(
            'REFLECT & INSPIRES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Color(0xFFB3FF00),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your Year Card',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Embed Share Card
          ShareableYearCard(review: review),
          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      // Trigger download mock animation
                      setState(() {
                        _showShareSuccess = true;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.download, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'DOWNLOAD CARD',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.9)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFB3FF00),
                      side: const BorderSide(color: Color(0xFFB3FF00)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Color(0xFFB3FF00)),
                              SizedBox(width: 12),
                              Text('Link copied! Share it on your socials.'),
                            ],
                          ),
                          backgroundColor: const Color(0xFF161616),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share_outlined, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'SHARE SKY',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 64), // extra buffer
        ],
      ),
    );
  }
}

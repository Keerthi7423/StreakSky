import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/core/router/app_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Track Your Streaks',
      description: 'Keep the fire burning. Track your daily habits and build unstoppable streaks.',
      icon: Icons.local_fire_department_rounded,
      color: const Color(0xFFB3FF00),
    ),
    OnboardingData(
      title: 'AI-Powered Insights',
      description: 'Get personalized nudges and patterns analysis from Sky, your AI habit coach.',
      icon: Icons.psychology_rounded,
      color: const Color(0xFF00E5FF),
    ),
    OnboardingData(
      title: 'Weather Your Journey',
      description: 'Your habits affect your personal weather. Stay consistent to keep it sunny.',
      icon: Icons.wb_sunny_rounded,
      color: const Color(0xFFFFD600),
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    // Update the provider state so the router re-evaluates the redirect logic
    ref.read(onboardingCompletedProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(data: _pages[index]);
            },
          ),
          
          // Navigation UI
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
                TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    'SKIP',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                
                // Indicators
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index 
                            ? const Color(0xFFB3FF00) 
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                
                // Next/Get Started Button
                IconButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _completeOnboarding();
                    }
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB3FF00),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _currentPage == _pages.length - 1 
                          ? Icons.check 
                          : Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon/Illustration Area
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                data.icon,
                size: 120,
                color: data.color,
              ).animate(onPlay: (controller) => controller.repeat())
               .shimmer(duration: 2.seconds, color: Colors.white24)
               .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.1, 1.1), curve: Curves.easeInOut),
            ),
          ).animate().fadeIn(duration: 800.ms).scale(delay: 200.ms),
          
          const SizedBox(height: 60),
          
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
          
          const SizedBox(height: 20),
          
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }
}

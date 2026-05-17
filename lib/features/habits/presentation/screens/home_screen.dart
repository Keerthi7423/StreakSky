import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/habit_model.dart';
import '../controllers/habit_controller.dart';
import '../widgets/add_habit_bottom_sheet.dart';
import '../widgets/habit_card.dart';
import '../../../weather/presentation/widgets/weather_hero_card.dart';
import '../../../ai_agent/presentation/widgets/ai_nudge_card.dart';
import '../../../quotes/presentation/widgets/morning_quote_card.dart';
import '../../../year_review/presentation/widgets/home_year_review_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showAddHabit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddHabitBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(todaysHabitsProvider);
    final completionsAsync = ref.watch(habitCompletionsProvider);

    // Listen for errors in the habit controller (e.g. during creation)
    ref.listen<AsyncValue<void>>(habitControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          const SliverToBoxAdapter(child: WeatherHeroCard()),
          const SliverToBoxAdapter(child: MorningQuoteCard()),
          const SliverToBoxAdapter(child: AiNudgeCard()),
          const SliverToBoxAdapter(child: HomeYearReviewBanner()),
          habitsAsync.when(
            data: (habits) => habits.isEmpty
                ? SliverFillRemaining(child: _buildEmptyState(context))
                : _buildHabitList(habits, completionsAsync.asData?.value ?? {}),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFFB3FF00))),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabit(context),
        backgroundColor: const Color(0xFFB3FF00),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF0D0D0D),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        title: const Text(
          'STREAKSKY',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFB3FF00).withValues(alpha: 0.05),
            ),
            child: const Icon(Icons.auto_awesome, size: 64, color: Color(0xFFB3FF00)),
          ),
          const SizedBox(height: 32),
          const Text(
            'START YOUR LEGACY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'The first step to a great life is a single habit.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () => _showAddHabit(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFB3FF00)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'CREATE FIRST HABIT',
              style: TextStyle(color: Color(0xFFB3FF00), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitList(List<HabitModel> habits, Set<String> completedIds) {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: Consumer(
        builder: (context, ref, child) {
          return SliverReorderableList(
            itemBuilder: (context, index) {
              final habit = habits[index];
              return Padding(
                key: ValueKey(habit.id),
                padding: const EdgeInsets.only(bottom: 16),
                child: HabitCard(
                  habit: habit,
                  isCompleted: completedIds.contains(habit.id),
                ),
              );
            },
            itemCount: habits.length,
            onReorder: (oldIndex, newIndex) {
              ref.read(habitControllerProvider.notifier).reorderHabits(oldIndex, newIndex);
            },
          );
        },
      ),
    );
  }
}

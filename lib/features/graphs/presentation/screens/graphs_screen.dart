import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/core/constants/app_colors.dart';
import 'package:streaksky/core/constants/app_typography.dart';
import '../controllers/stats_controller.dart';
import '../widgets/stat_widgets.dart';

class GraphsScreen extends ConsumerStatefulWidget {
  const GraphsScreen({super.key});

  @override
  ConsumerState<GraphsScreen> createState() => _GraphsScreenState();
}

class _GraphsScreenState extends ConsumerState<GraphsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(statsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Deep Analytics',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Performance Trends', style: AppTypography.h3),
            const SizedBox(height: 16),
            
            // Tab Bar for Timeframes
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primaryAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                unselectedLabelColor: AppColors.textSecondary,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Weekly'),
                  Tab(text: 'Monthly'),
                  Tab(text: 'Career'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Graph Viewport
            SizedBox(
              height: 250,
              child: TabBarView(
                controller: _tabController,
                children: [
                  DetailedLineChart(
                    data: stats.weeklyTrend,
                    title: 'Last 7 Days',
                    accentColor: AppColors.primaryAccent,
                  ),
                  DetailedLineChart(
                    data: stats.monthlyTrend,
                    title: 'Last 30 Days',
                    accentColor: Colors.blueAccent,
                  ),
                  DetailedLineChart(
                    data: stats.careerTrend,
                    title: '6 Month Growth',
                    accentColor: Colors.purpleAccent,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            const Text('Insights & Correlations', style: AppTypography.h3),
            const SizedBox(height: 16),
            
            if (stats.keystoneHabit != null)
              KeystoneHabitCard(
                habitName: stats.keystoneHabit!,
                correlation: stats.keystoneCorrelation,
              ),
            
            const SizedBox(height: 24),
            
            _buildInsightCard(
              icon: Icons.trending_up,
              color: Colors.greenAccent,
              title: 'Best Performance Day',
              subtitle: 'You are 40% more likely to complete habits on Tuesdays.',
            ),
            
            const SizedBox(height: 16),
            
            _buildInsightCard(
              icon: Icons.wb_sunny_outlined,
              color: Colors.orangeAccent,
              title: 'Weather Impact',
              subtitle: 'Sunny days increase your completion rate by 15%.',
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.h3.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

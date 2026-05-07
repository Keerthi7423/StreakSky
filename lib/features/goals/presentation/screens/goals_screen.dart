import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/models/goal_model.dart';
import '../controllers/goal_controller.dart';
import '../widgets/goal_card.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOALS'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryAccent,
          indicatorWeight: 3,
          labelColor: AppColors.primaryAccent,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTypography.h3.copyWith(letterSpacing: 1.2),
          tabs: const [
            Tab(text: 'WEEKLY'),
            Tab(text: 'MONTHLY'),
            Tab(text: 'CAREER'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _GoalsList(type: GoalType.weekly),
          _GoalsList(type: GoalType.monthly),
          _GoalsList(type: GoalType.career),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGoalSheet(context);
        },
        backgroundColor: AppColors.primaryAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.black, size: 28),
      ),
    );
  }

  void _showAddGoalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _AddGoalBottomSheet(),
    );
  }
}

class _GoalsList extends ConsumerWidget {
  final GoalType type;

  const _GoalsList({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsListProvider(type));

    return goalsAsync.when(
      data: (goals) {
        if (goals.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flag_outlined, size: 64, color: AppColors.textTertiary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'NO ${type.name.toUpperCase()} GOALS YET',
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Set a goal to start building your legacy.',
                    style: AppTypography.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.horizontalPadding),
          itemCount: goals.length,
          itemBuilder: (context, index) {
            final goal = goals[index];
            return GoalCard(goal: goal);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryAccent)),
      error: (err, stack) => Center(child: Text('Error: $err', style: AppTypography.caption)),
    );
  }
}

class _AddGoalBottomSheet extends ConsumerStatefulWidget {
  const _AddGoalBottomSheet();

  @override
  ConsumerState<_AddGoalBottomSheet> createState() => _AddGoalBottomSheetState();
}

class _AddGoalBottomSheetState extends ConsumerState<_AddGoalBottomSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _targetController = TextEditingController();
  GoalType _selectedType = GoalType.weekly;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ADD NEW GOAL', style: AppTypography.h2),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'TITLE',
              labelStyle: AppTypography.micro,
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider)),
            ),
            style: AppTypography.bodyLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'DESCRIPTION (OPTIONAL)',
              labelStyle: AppTypography.micro,
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider)),
            ),
            style: AppTypography.bodyLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _targetController,
                  decoration: const InputDecoration(
                    labelText: 'TARGET VALUE',
                    labelStyle: AppTypography.micro,
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider)),
                  ),
                  keyboardType: TextInputType.number,
                  style: AppTypography.bodyLarge,
                ),
              ),
              const SizedBox(width: 20),
              DropdownButton<GoalType>(
                value: _selectedType,
                dropdownColor: AppColors.surface,
                items: GoalType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase(), style: AppTypography.body),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedType = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty) {
                await ref.read(goalControllerProvider.notifier).addGoal(
                  title: _titleController.text,
                  type: _selectedType,
                  description: _descController.text,
                  targetValue: int.tryParse(_targetController.text),
                );
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('CREATE GOAL'),
          ),
        ],
      ),
    );
  }
}

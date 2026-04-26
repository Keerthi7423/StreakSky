import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/habit_model.dart';
import '../controllers/habit_controller.dart';
import '../screens/habit_detail_screen.dart';

class HabitCard extends ConsumerStatefulWidget {
  final HabitModel habit;
  final bool isCompleted;

  const HabitCard({
    super.key,
    required this.habit,
    this.isCompleted = false,
  });

  @override
  ConsumerState<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends ConsumerState<HabitCard> with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(_bounceController);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _handleToggle() {
    HapticFeedback.mediumImpact();
    _bounceController.forward(from: 0.0);
    
    // Toggle completion logic
    ref.read(habitControllerProvider.notifier).toggleCompletion(
      widget.habit.id,
      DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(int.parse('0xFF${widget.habit.colorHex ?? "B3FF00"}'));
    final isCompleted = widget.isCompleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isCompleted ? themeColor.withOpacity(0.15) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border(
          left: BorderSide(color: themeColor, width: 4),
        ),
        boxShadow: isCompleted ? [
          BoxShadow(
            color: themeColor.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          )
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HabitDetailScreen(habit: widget.habit),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Emoji / Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.habit.emoji ?? '🎯',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Habit Name & Category
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.habit.name,
                        style: TextStyle(
                          color: isCompleted ? Colors.white : Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (widget.habit.category != null)
                        Text(
                          widget.habit.category!.toUpperCase(),
                          style: TextStyle(
                            color: themeColor.withOpacity(0.7),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                    ],
                  ),
                ),

                // Animated Checkbox
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: GestureDetector(
                    onTap: _handleToggle,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCompleted ? themeColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCompleted ? themeColor : Colors.white24,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 18, color: Colors.black)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

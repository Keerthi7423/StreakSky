import 'package:flutter/material.dart';

class SuggestedPromptChips extends StatelessWidget {
  final Function(String) onPromptSelected;

  const SuggestedPromptChips({
    super.key,
    required this.onPromptSelected,
  });

  @override
  Widget build(BuildContext context) {
    final prompts = [
      "How's my streak?",
      "Why am I missing morning habits?",
      "Give me a daily nudge.",
      "Analyze my last 30 days.",
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: prompts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final prompt = prompts[index];
          return ActionChip(
            label: Text(
              prompt,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            backgroundColor: Colors.transparent,
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () => onPromptSelected(prompt),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/habit_controller.dart';
import '../../domain/models/habit_frequency.dart';

class AddHabitBottomSheet extends ConsumerStatefulWidget {
  const AddHabitBottomSheet({super.key});

  @override
  ConsumerState<AddHabitBottomSheet> createState() => _AddHabitBottomSheetState();
}

class _AddHabitBottomSheetState extends ConsumerState<AddHabitBottomSheet> {
  final _nameController = TextEditingController();
  String _selectedEmoji = '🎯';
  String _selectedColor = 'B3FF00'; // Default Neon Green
  final String _selectedCategory = 'Health';
  
  final List<String> _emojis = ['🎯', '🧘', '📚', '💪', '💧', '🍎', '🏃', '🎸', '💻', '🌅'];
  final List<Map<String, String>> _colors = [
    {'name': 'Neon Green', 'hex': 'B3FF00'},
    {'name': 'Neon Blue', 'hex': '00F2FF'},
    {'name': 'Neon Pink', 'hex': 'FF0055'},
    {'name': 'Neon Purple', 'hex': 'BC00FF'},
    {'name': 'Neon Orange', 'hex': 'FF9900'},
  ];


  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) return;

    ref.read(habitControllerProvider.notifier).addHabit(
      name: _nameController.text.trim(),
      emoji: _selectedEmoji,
      colorHex: _selectedColor,
      frequency: const HabitFrequency(type: FrequencyType.daily),
      category: _selectedCategory,
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final habitState = ref.watch(habitControllerProvider);
    final isLoading = habitState.isLoading;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'NEW HABIT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Name Input
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'What is your new habit?',
              hintStyle: const TextStyle(color: Colors.white24),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(int.parse('0xFF$_selectedColor'))),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Emoji Picker
          const Text('ICON', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _emojis.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final emoji = _emojis[index];
                final isSelected = _selectedEmoji == emoji;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = emoji),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected ? Color(int.parse('0xFF$_selectedColor')).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected ? Border.all(color: Color(int.parse('0xFF$_selectedColor'))) : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Color Picker
          const Text('THEME COLOR', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _colors.map((color) {
              final isSelected = _selectedColor == color['hex'];
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color['hex']!),
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(int.parse('0xFF${color['hex']}')),
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: Color(int.parse('0xFF${color['hex']}')).withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ] : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(int.parse('0xFF$_selectedColor')),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text(
                      'CREATE HABIT',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../controllers/ai_controller.dart';
import '../../../habits/presentation/controllers/habit_controller.dart';

class VoiceCheckInButton extends ConsumerStatefulWidget {
  const VoiceCheckInButton({super.key});

  @override
  ConsumerState<VoiceCheckInButton> createState() => _VoiceCheckInButtonState();
}

class _VoiceCheckInButtonState extends ConsumerState<VoiceCheckInButton> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and speak';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => debugPrint('onStatus: $val'),
        onError: (val) => debugPrint('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              // Handle completion
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _processTranscript(_text);
    }
  }

  Future<void> _processTranscript(String transcript) async {
    if (transcript.isEmpty || transcript == 'Press the button and speak') return;

    final result = await ref.read(aiControllerProvider.notifier).handleVoiceCheckIn(transcript);
    
    if (result['habit'] != 'unknown') {
      final habitName = result['habit'] as String;
      final status = result['status'] as String? ?? 'done';
      
      // Try to find the habit by name
      final habits = ref.read(habitsListProvider).asData?.value ?? [];
      final habit = habits.firstWhere(
        (h) => h.name.toLowerCase().contains(habitName.toLowerCase()),
        orElse: () => habits.isNotEmpty ? habits.first : throw Exception('No habits found'),
      );

      if (status == 'done') {
        await ref.read(habitControllerProvider.notifier).toggleCompletion(habit.id, DateTime.now());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logged "$habitName" as completed via voice!'),
              backgroundColor: const Color(0xFFB3FF00),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sky couldn't recognize the habit. Try saying 'Done with reading'"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isListening)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _text,
              style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
            ),
          ),
        GestureDetector(
          onLongPressStart: (_) => _listen(),
          onLongPressEnd: (_) => _listen(),
          child: FloatingActionButton(
            onPressed: () {}, // Handled by long press
            backgroundColor: _isListening ? Colors.redAccent : const Color(0xFFB3FF00),
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hold to Speak',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

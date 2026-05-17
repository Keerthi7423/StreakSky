import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/di/injection.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/repositories/ai_repository.dart';
import 'ai_state.dart';

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return getIt<AiRepository>();
});

class AiController extends StateNotifier<AiState> {
  final AiRepository _repository;
  final Ref _ref;
  final _uuid = const Uuid();

  AiController(this._repository, this._ref) : super(const AiState());

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: text,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      final responseText = await _repository.getChatResponse(text, state.messages);
      
      final assistantMessage = ChatMessage(
        id: _uuid.v4(),
        text: responseText,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isLoading: false,
      );
    } catch (e) {
      final errorMessage = ChatMessage(
        id: _uuid.v4(),
        text: "Sorry, I'm having trouble connecting to the sky right now. Please try again later.",
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        isError: true,
      );

      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchDailyNudge(String habitDataSummary) async {
    try {
      final nudge = await _repository.getDailyNudge(habitDataSummary);
      state = state.copyWith(dailyNudge: nudge);
    } catch (e) {
      state = state.copyWith(dailyNudge: "Keep pushing towards the clear skies!");
    }
  }

  Future<String> analyzeUserPatterns(String historicalData) async {
    try {
      return await _repository.analyzePatterns(historicalData);
    } catch (e) {
      return "I need more data to see the patterns in your sky.";
    }
  }

  Future<String> generateHabitCommitMessage(String habitName, String context) async {
    try {
      return await _repository.generateCommitMessage(habitName, context);
    } catch (e) {
      return "feat: completed $habitName";
    }
  }

  Future<Map<String, dynamic>> handleVoiceCheckIn(String transcript) async {
    try {
      return await _repository.parseVoiceCommand(transcript);
    } catch (e) {
      return {'habit': 'unknown'};
    }
  }

  void clearChat() {
    state = state.copyWith(messages: []);
  }

  Future<void> fetchMidYearPaceCheck(String yearDataSummary) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final responseText = await _repository.getMidYearPaceCheck(yearDataSummary);
      final message = ChatMessage(
        id: _uuid.v4(),
        text: responseText,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, message],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to load mid-year pace check.",
      );
    }
  }
}

final aiControllerProvider = StateNotifierProvider<AiController, AiState>((ref) {
  final repo = ref.watch(aiRepositoryProvider);
  return AiController(repo, ref);
});

import '../../domain/models/chat_message.dart';

class AiState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? dailyNudge;
  final String? error;

  const AiState({
    this.messages = const [],
    this.isLoading = false,
    this.dailyNudge,
    this.error,
  });

  AiState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? dailyNudge,
    String? error,
  }) {
    return AiState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      dailyNudge: dailyNudge ?? this.dailyNudge,
      error: error ?? this.error,
    );
  }
}

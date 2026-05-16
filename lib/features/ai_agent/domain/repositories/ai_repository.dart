import '../../domain/models/chat_message.dart';

abstract class AiRepository {
  Future<String> getChatResponse(String prompt, List<ChatMessage> history);
  Future<String> getDailyNudge(String habitDataSummary);
  Future<String> generateCommitMessage(String habitName, String context);
  Future<String> analyzePatterns(String historicalData);
  Future<Map<String, dynamic>> parseVoiceCommand(String transcript);
}

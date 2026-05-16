import '../../domain/models/chat_message.dart';

abstract class AiRepository {
  Future<String> getChatResponse(String prompt, List<ChatMessage> history);
  Future<String> getDailyNudge(String habitDataSummary);
}

import 'package:injectable/injectable.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/ollama_datasource.dart';

@LazySingleton(as: AiRepository)
class AiRepositoryImpl implements AiRepository {
  final OllamaDataSource _remoteDataSource;

  AiRepositoryImpl(this._remoteDataSource);

  @override
  Future<String> getChatResponse(String prompt, List<ChatMessage> history) async {
    final historyMap = history.map((msg) => {
      'role': msg.role.name,
      'content': msg.text,
    }).toList();
    
    return _remoteDataSource.generateResponse(prompt, history: historyMap);
  }

  @override
  Future<String> getDailyNudge(String habitDataSummary) async {
    return _remoteDataSource.generateNudge(habitDataSummary);
  }
}

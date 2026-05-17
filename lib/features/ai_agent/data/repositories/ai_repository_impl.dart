import 'dart:convert';
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

  @override
  Future<String> generateCommitMessage(String habitName, String context) async {
    return _remoteDataSource.generateCommitMessage(habitName, context);
  }

  @override
  Future<String> analyzePatterns(String historicalData) async {
    return _remoteDataSource.generatePatternAnalysis(historicalData);
  }

  @override
  Future<Map<String, dynamic>> parseVoiceCommand(String transcript) async {
    final response = await _remoteDataSource.parseVoiceTranscript(transcript);
    try {
      // Basic extraction if the AI returns extra text around the JSON
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      if (jsonStart != -1 && jsonEnd != -1) {
        final jsonStr = response.substring(jsonStart, jsonEnd);
        return json.decode(jsonStr) as Map<String, dynamic>;
      }
      return {'habit': 'unknown'};
    } catch (e) {
      return {'habit': 'unknown'};
    }
  }

  @override
  Future<String> getMidYearPaceCheck(String yearDataSummary) async {
    return _remoteDataSource.generateMidYearPaceCheck(yearDataSummary);
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OllamaDataSource {
  final Dio _dio;
  final String _baseUrl = dotenv.get('OLLAMA_BASE_URL', fallback: 'http://localhost:11434/api');
  final String _model = dotenv.get('OLLAMA_MODEL', fallback: 'llama3.2:3b');

  OllamaDataSource(this._dio);

  Future<String> generateResponse(String prompt, {List<Map<String, String>>? history}) async {
    try {
      final messages = [
        {'role': 'system', 'content': 'You are Sky, a supportive and weather-themed habit coaching AI agent. Your goal is to provide encouraging nudges and answer habit-related questions with a positive, cosmic vibe.'},
        if (history != null) ...history,
        {'role': 'user', 'content': prompt},
      ];

      final response = await _dio.post(
        '$_baseUrl/chat',
        data: {
          'model': _model,
          'messages': messages,
          'stream': false,
        },
      );

      if (response.statusCode == 200) {
        return response.data['message']['content'] as String;
      } else {
        throw Exception('Failed to generate response: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> generateNudge(String habitDataSummary) async {
    final prompt = "Based on yesterday's habit data: $habitDataSummary. Provide a short, 1-2 sentence supportive nudge for today. Keep it weather-themed.";
    return generateResponse(prompt);
  }
}

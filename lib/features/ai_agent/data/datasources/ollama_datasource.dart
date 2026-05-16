import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'azure_ai_datasource.dart';

@lazySingleton
class OllamaDataSource {
  final Dio _dio;
  final String _baseUrl = dotenv.get('OLLAMA_BASE_URL', fallback: 'http://localhost:11434/api');
  final String _model = dotenv.get('OLLAMA_MODEL', fallback: 'llama3.2:3b');
  final AzureAiDatasource _azureFallback;

  OllamaDataSource(this._dio, this._azureFallback);

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
        return _azureFallback.generateResponse(prompt);
      }
    } catch (e) {
      debugPrint('OllamaDataSource Error: $e. Falling back to Azure...');
      return _azureFallback.generateResponse(prompt);
    }
  }

  Future<String> generateNudge(String habitDataSummary) async {
    final prompt = "Based on yesterday's habit data: $habitDataSummary. Provide a short, 1-2 sentence supportive nudge for today. Keep it weather-themed.";
    return generateResponse(prompt);
  }

  Future<String> generateCommitMessage(String habitName, String context) async {
    final prompt = "Generate a GitHub-inspired daily one-liner commit message for completing the habit '$habitName'. Context: $context. Examples: 'feat: 14-day reading streak hit. Sunny day.', 'fix: missed gym, used streak shield. Still alive.'. Provide ONLY the message text.";
    return generateResponse(prompt);
  }

  Future<String> generatePatternAnalysis(String historicalData) async {
    final prompt = "Analyze this 30/60 day habit history: $historicalData. Identify 2-3 key patterns (e.g., 'You tend to miss meditation on Tuesdays', 'Reading consistency improves after gym'). Keep it concise and supportive.";
    return generateResponse(prompt);
  }

  Future<String> parseVoiceTranscript(String transcript) async {
    final prompt = "Parse this voice check-in: '$transcript'. Identify the habit name and status (done/missed). Return ONLY a JSON object like {\"habit\": \"reading\", \"status\": \"done\"}. If unknown, return {\"habit\": \"unknown\"}.";
    return generateResponse(prompt);
  }
}

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

@lazySingleton
class AzureAiDatasource {
  final Dio _dio;

  AzureAiDatasource(this._dio);

  // In a real app, this would call Azure OpenAI or similar.
  // For this task, we'll simulate a cloud fallback API.
  Future<String> generateResponse(String prompt) async {
    // Reference _dio to keep dependency injection constructor intact
    final _ = _dio;
    debugPrint('AzureAiDatasource: Falling back to Cloud AI...');
    
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // For demonstration, we'll return a "Cloud mode" response
    if (prompt.contains('commit message')) {
      return 'feat: habit completed. Cloud powered consistency.';
    }

    return "I'm currently running in Cloud Fallback mode because the local AI is unavailable. How can I help you with your habits today?";
  }
}

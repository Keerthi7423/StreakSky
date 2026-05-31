import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor to handle Azure API Management (APIM) gateway security.
/// This ensures all requests to our backend (Azure/Supabase) route through
/// the APIM gateway for rate limiting, DDoS protection, and IP filtering.
class AzureApimInterceptor extends Interceptor {
  final String subscriptionKey;

  AzureApimInterceptor({required this.subscriptionKey});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Append the APIM subscription key to every outgoing request.
    // Azure APIM uses 'Ocp-Apim-Subscription-Key' header to identify the client
    // and apply rate-limiting policies (e.g., max 100 requests / minute).
    options.headers['Ocp-Apim-Subscription-Key'] = subscriptionKey;

    // Add additional security headers if necessary
    options.headers['X-Client-Platform'] = defaultTargetPlatform.toString();

    debugPrint("APIM Interceptor: Adding Subscription Key to ${options.path}");
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle specific APIM error codes
    if (err.response?.statusCode == 429) {
      debugPrint("APIM Rate Limit Exceeded: ${err.message}");
      // Trigger a Riverpod state change or UI banner to notify the user
    } else if (err.response?.statusCode == 401) {
      debugPrint("APIM Gateway Security Block: Unauthorized API access");
    }
    super.onError(err, handler);
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:slim30/Core/Network/api_exception.dart';

class ApiClient {
  ApiClient({
    required this.baseUrl,
    required this.defaultHeaders,
    this.authTokenProvider,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final Future<String?> Function()? authTokenProvider;
  final http.Client _httpClient;

  Future<Map<String, dynamic>> get(String path) async {
    return _request('GET', path);
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    return _request('POST', path, body: body);
  }

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body}) async {
    return _request('PUT', path, body: body);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    return _request('DELETE', path);
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final headers = <String, String>{...defaultHeaders};
      if (authTokenProvider != null) {
        final token = await authTokenProvider!();
        if (token != null && token.trim().isNotEmpty) {
          headers['Authorization'] = 'Bearer ${token.trim()}';
        }
      }
      http.Response response;

      if (method == 'GET') {
        response = await _httpClient
            .get(uri, headers: headers)
            .timeout(const Duration(seconds: 12));
      } else if (method == 'POST') {
        response = await _httpClient
            .post(uri, headers: headers, body: jsonEncode(body ?? <String, dynamic>{}))
            .timeout(const Duration(seconds: 12));
      } else if (method == 'PUT') {
        response = await _httpClient
            .put(uri, headers: headers, body: jsonEncode(body ?? <String, dynamic>{}))
            .timeout(const Duration(seconds: 12));
      } else if (method == 'DELETE') {
        response = await _httpClient
            .delete(uri, headers: headers)
            .timeout(const Duration(seconds: 12));
      } else {
        throw ApiException('Unsupported request method');
      }

      return _parseEnvelope(response);
    } on ApiException {
      rethrow;
    } on FormatException {
      throw ApiException('Invalid server response');
    } on Exception {
      throw ApiException('Network error');
    }
  }

  Map<String, dynamic> _parseEnvelope(http.Response response) {
    final payloadText = response.body.trim();
    if (payloadText.isEmpty) {
      return <String, dynamic>{};
    }

    final dynamic body = jsonDecode(payloadText);
    if (body is! Map<String, dynamic>) {
      throw ApiException('Unexpected response format', statusCode: response.statusCode);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = (body['error'] is String && (body['error'] as String).isNotEmpty)
          ? body['error'] as String
          : 'Request failed';
      throw ApiException(message, statusCode: response.statusCode);
    }

    final success = body['success'] == true;
    if (!success) {
      final message = (body['error'] is String && (body['error'] as String).isNotEmpty)
          ? body['error'] as String
          : 'Request failed';
      throw ApiException(message, statusCode: response.statusCode);
    }

    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw ApiException('Invalid data payload', statusCode: response.statusCode);
    }

    return data;
  }
}

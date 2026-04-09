import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:slim30/Core/Network/api_exception.dart';

class ApiClient {
  ApiClient({
    required this.baseUrl,
    required this.defaultHeaders,
    this.authTokenProvider,
    this.localeCodeProvider,
    this.onUnauthorized,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final Future<String?> Function()? authTokenProvider;
  final Future<String?> Function()? localeCodeProvider;
  final Future<void> Function()? onUnauthorized;
  final http.Client _httpClient;

  Future<Map<String, dynamic>> get(String path) async {
    return _request('GET', path);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    return _request('POST', path, body: body);
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    Map<String, String>? fields,
    required List<ApiMultipartFile> files,
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(
        await _buildHeaders(includeJsonContentType: false),
      );

      if (fields != null && fields.isNotEmpty) {
        request.fields.addAll(fields);
      }

      for (final file in files) {
        request.files.add(
          http.MultipartFile.fromBytes(
            file.field,
            file.bytes,
            filename: file.filename,
            contentType: MediaType.parse(file.contentType),
          ),
        );
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 20),
      );
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 401 && onUnauthorized != null) {
        await onUnauthorized!();
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

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
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
      final headers = await _buildHeaders();
      http.Response response;

      if (method == 'GET') {
        response = await _httpClient
            .get(uri, headers: headers)
            .timeout(const Duration(seconds: 12));
      } else if (method == 'POST') {
        response = await _httpClient
            .post(
              uri,
              headers: headers,
              body: jsonEncode(body ?? <String, dynamic>{}),
            )
            .timeout(const Duration(seconds: 12));
      } else if (method == 'PUT') {
        response = await _httpClient
            .put(
              uri,
              headers: headers,
              body: jsonEncode(body ?? <String, dynamic>{}),
            )
            .timeout(const Duration(seconds: 12));
      } else if (method == 'DELETE') {
        response = await _httpClient
            .delete(uri, headers: headers)
            .timeout(const Duration(seconds: 12));
      } else {
        throw ApiException('Unsupported request method');
      }

      if (response.statusCode == 401 && onUnauthorized != null) {
        await onUnauthorized!();
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

  Future<Map<String, String>> _buildHeaders({
    bool includeJsonContentType = true,
  }) async {
    final headers = <String, String>{...defaultHeaders};

    if (!includeJsonContentType) {
      headers.remove('Content-Type');
    }

    if (authTokenProvider != null) {
      final token = await authTokenProvider!();
      if (token != null && token.trim().isNotEmpty) {
        headers['Authorization'] = 'Bearer ${token.trim()}';
      }
    }

    if (localeCodeProvider != null) {
      final localeCode = await localeCodeProvider!();
      if (localeCode != null && localeCode.trim().isNotEmpty) {
        headers['Accept-Language'] = localeCode.trim().toLowerCase();
      }
    }

    return headers;
  }

  Map<String, dynamic> _parseEnvelope(http.Response response) {
    final payloadText = response.body.trim();
    if (payloadText.isEmpty) {
      return <String, dynamic>{};
    }

    final dynamic body = jsonDecode(payloadText);
    if (body is! Map<String, dynamic>) {
      throw ApiException(
        'Unexpected response format',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message =
          (body['error'] is String && (body['error'] as String).isNotEmpty)
          ? body['error'] as String
          : 'Request failed';
      throw ApiException(message, statusCode: response.statusCode);
    }

    final success = body['success'] == true;
    if (!success) {
      final message =
          (body['error'] is String && (body['error'] as String).isNotEmpty)
          ? body['error'] as String
          : 'Request failed';
      throw ApiException(message, statusCode: response.statusCode);
    }

    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw ApiException(
        'Invalid data payload',
        statusCode: response.statusCode,
      );
    }

    return data;
  }
}

class ApiMultipartFile {
  const ApiMultipartFile({
    required this.field,
    required this.bytes,
    required this.filename,
    required this.contentType,
  });

  final String field;
  final Uint8List bytes;
  final String filename;
  final String contentType;
}

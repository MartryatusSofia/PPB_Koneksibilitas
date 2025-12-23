import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Gunakan host sesuai platform: web/desktop pakai localhost, Android emulator pakai 10.0.2.2
  static const String _baseWebDesktop = 'http://localhost:8000/api';
  static const String _baseAndroidEmu = 'http://10.0.2.2:8000/api';
  static String get baseUrl => kIsWeb ? _baseWebDesktop : _baseAndroidEmu;

  static Map<String, String> _defaultHeaders({String? token}) {
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint').replace(queryParameters: query);
    final response = await http.get(uri, headers: _defaultHeaders(token: token));
    return _handleJson(response);
  }

  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        ..._defaultHeaders(token: token),
        'Content-Type': 'application/json',
      },
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleJson(response);
  }

  static Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    Map<String, File>? files,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(_defaultHeaders(token: token));
    request.fields.addAll(fields);

    if (files != null) {
      for (final entry in files.entries) {
        final file = entry.value;
        if (await file.exists()) {
          request.files.add(await http.MultipartFile.fromPath(
            entry.key,
            file.path,
          ));
        }
      }
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _handleJson(response);
  }

  static Map<String, dynamic> _handleJson(http.Response response) {
    final status = response.statusCode;
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (status >= 200 && status < 300) {
      return data;
    }

    final message = data['message'] ?? 'API Error';
    throw Exception('$message (code: $status)');
  }
}
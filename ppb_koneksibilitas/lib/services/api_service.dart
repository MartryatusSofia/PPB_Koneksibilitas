import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseWebDesktop = 'http://localhost:8000/api';
  static const String _baseAndroidEmu = 'http://10.0.2.2:8000/api';
  static String get baseUrl => kIsWeb ? _baseWebDesktop : _baseAndroidEmu;

  static String? _token;
  static String? get token => _token;

  static void setToken(String? token) {
    _token = token;
  }

  static Map<String, String> _headers({String? token}) {
    final t = token ?? _token;
    return {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      if (t != null && t.isNotEmpty) 'Authorization': 'Bearer $t',
    };
  }
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint').replace(queryParameters: query);
    final res = await http.get(uri, headers: _headers(token: token));
    return _decode(res);
  }
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {..._headers(token: token), 'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
    return _decode(res);
  }
  static Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    Map<String, dynamic>? files,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(_headers(token: token));
    request.fields.addAll(fields);

    if (files != null) {
      for (final entry in files.entries) {
        final value = entry.value;

        // single dart:io File (mobile/desktop)
        if (value is File) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, value.path),
          );
          continue;
        }

        // single bytes (web) -> value should be a Map with 'bytes' and 'name'
        if (value is Map && value['bytes'] != null) {
          final bytes = value['bytes'] as List<int>;
          final filename = value['name'] as String? ?? entry.key;
          request.files.add(http.MultipartFile.fromBytes(entry.key, bytes, filename: filename));
          continue;
        }

        // multiple files (list)
        if (value is List) {
          for (final item in value) {
            if (item is File) {
              request.files.add(
                await http.MultipartFile.fromPath(entry.key, item.path),
              );
            } else if (item is Map && item['bytes'] != null) {
              final bytes = item['bytes'] as List<int>;
              final filename = item['name'] as String? ?? entry.key;
              request.files.add(http.MultipartFile.fromBytes(entry.key, bytes, filename: filename));
            }
          }
        }
      }
    }
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _decode(response);
  }
  static Map<String, dynamic> _decode(http.Response res) {
    final data = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300 && data is Map<String, dynamic>) {
      return data;}
    throw Exception(data['message'] ?? 'API Error');
  }
}

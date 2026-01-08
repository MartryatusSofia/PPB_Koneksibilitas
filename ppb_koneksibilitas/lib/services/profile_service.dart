import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';
import 'token_storage.dart';
import 'package:file_picker/file_picker.dart';

class ProfileService {
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await TokenStorage.getToken();
    return ApiService.get('profile', token: token);
  }

  static Future<List<String>> getAvailableSkills() async {
    final token = await TokenStorage.getToken();
    final response = await ApiService.get('skills', token: token);
    if (response['success'] == true && response['data'] is List) {
      return List<String>.from(response['data']);
    }
    return [];
  }

  static Future<bool> updateProfile({
    String? name,
    String? subtitle,
    String? about,
    List<String>? skills,
    PlatformFile? avatarFile,
    PlatformFile? cvFile,
    PlatformFile? portfolioFile,
  }) async {
    final token = await TokenStorage.getToken();
    final uri = Uri.parse('${ApiService.baseUrl}/profile'); 
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (name != null) request.fields['name'] = name;
    if (subtitle != null) request.fields['subtitle'] = subtitle;
    if (about != null) request.fields['about'] = about;

    if (skills != null) {
      for (int i = 0; i < skills.length; i++) {
        request.fields['skills[$i]'] = skills[i];
      }
    }
    Future<void> addFile(String field, PlatformFile pFile) async {
      if (kIsWeb) {
        if (pFile.bytes != null) {
          request.files.add(http.MultipartFile.fromBytes(
            field,
            pFile.bytes!,
            filename: pFile.name,
          ));
        }
      } else {
        if (pFile.path != null) {
          request.files.add(await http.MultipartFile.fromPath(
            field,
            pFile.path!,
          ));
        }
      }
    }

    if (avatarFile != null) await addFile('avatar', avatarFile);
    if (cvFile != null) await addFile('cv', cvFile);
    if (portfolioFile != null) await addFile('portfolio', portfolioFile);

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Gagal Upload: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error Upload: $e");
      return false;
    }
  }
}
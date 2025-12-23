import 'dart:io';

import 'package:ppb_koneksibilitas/services/api_service.dart';
import 'package:ppb_koneksibilitas/services/token_storage.dart';

class ProfileService {
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await TokenStorage.getToken();
    return ApiService.get('profile', token: token);
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? subtitle,
    String? about,
    List<String>? skills,
  }) async {
    final token = await TokenStorage.getToken();
    return ApiService.post(
      'profile',
      token: token,
      body: {
        if (name != null) 'name': name,
        if (subtitle != null) 'subtitle': subtitle,
        if (about != null) 'about': about,
        if (skills != null) 'skills': skills,
      },
    );
  }

  static Future<Map<String, dynamic>> uploadAvatar(File file) async {
    final token = await TokenStorage.getToken();
    return ApiService.postMultipart(
      'profile/avatar',
      token: token,
      fields: {},
      files: {'avatar': file},
    );
  }

  static Future<Map<String, dynamic>> uploadCv(File file) async {
    final token = await TokenStorage.getToken();
    return ApiService.postMultipart(
      'profile/cv',
      token: token,
      fields: {},
      files: {'cv': file},
    );
  }

  static Future<Map<String, dynamic>> getSkills() async {
    final token = await TokenStorage.getToken();
    return ApiService.get('profile/skills', token: token);
  }
}


import 'package:file_picker/file_picker.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';

class ProfileController {
  
  // 1. List Skill Manual (Agar cepat & tidak loading)
  final List<String> manualSkills = [
    'Design Grafis',
    'Mobile Developer',
    'Web Development',
    'UI/UX Designer',
    'Data Analyst',
    'SEO',
    'Copywriting',
    'Social Media Management',
    'Project Management',
    'DevOps',
  ];

  Future<UserProfile?> fetchProfile() async {
    try {
      final response = await ProfileService.getProfile();
      if (response['success'] == true) {
        return UserProfile.fromJson(response['data']);
      }
    } catch (e) {
      print("Error fetch: $e");
    }
    return null;
  }

  // (Fungsi fetchMasterSkills Dihapus karena kita pakai manualSkills di atas)

  Future<bool> updateData({
    String? name,
    String? subtitle,
    String? about,
    List<String>? skills,
    PlatformFile? avatar,
    PlatformFile? cv,
    PlatformFile? portfolio,
  }) async {
    return await ProfileService.updateProfile(
      name: name,
      subtitle: subtitle,
      about: about,
      skills: skills,
      avatarFile: avatar,
      cvFile: cv,
      portfolioFile: portfolio,
    );
  }
}
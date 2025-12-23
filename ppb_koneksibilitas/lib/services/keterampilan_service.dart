import 'package:ppb_koneksibilitas/services/api_service.dart';
import 'package:ppb_koneksibilitas/services/token_storage.dart';

class KeterampilanService {
  static Future<List<dynamic>> getAll() async {
    final res = await ApiService.get('keterampilan');
    return res['data'] ?? [];
  }

  static Future<List<dynamic>> getUserSkills() async {
    final token = await TokenStorage.getToken();
    final res = await ApiService.get('user/keterampilan', token: token);
    return res['data'] ?? [];
  }

  static Future<List<dynamic>> syncUserSkills(List<int> ids) async {
    final token = await TokenStorage.getToken();
    final res = await ApiService.post(
      'user/keterampilan',
      token: token,
      body: {'keterampilan_ids': ids},
    );
    return res['data'] ?? [];
  }
}


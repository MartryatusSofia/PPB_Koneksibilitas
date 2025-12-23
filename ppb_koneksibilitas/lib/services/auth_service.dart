import 'package:ppb_koneksibilitas/services/api_service.dart';
import 'package:ppb_koneksibilitas/services/token_storage.dart';

class AuthService {
  // ================= LOGIN =================
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final data = await ApiService.post(
      'login',
      body: {
        'email': email,
        'password': password,
      },
    );

    if (data['success'] == true && data['token'] != null) {
      await TokenStorage.saveToken(data['token']);
      return true;
    }

    return false;
  }

  // ================= REGISTER =================
  static Future<bool> register({
    required String email,
    required String namaDepan,
    required String namaBelakang,
    required String jenisKelamin,
    required String password,
  }) async {
    final data = await ApiService.post(
      'register',
      body: {
        'email': email,
        'nama_depan': namaDepan,
        'nama_belakang': namaBelakang,
        'jenis_kelamin': jenisKelamin,
        'password': password,
      },
    );

    if (data['success'] == true && data['token'] != null) {
      await TokenStorage.saveToken(data['token']);
      return true;
    }

    return false;
  }
}

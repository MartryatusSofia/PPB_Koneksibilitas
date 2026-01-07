import 'api_service.dart';
import 'token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // ================= RESTORE TOKEN SAAT APP START =================
  static Future<void> bootstrap() async {
    final token = await TokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      ApiService.setToken(token);
    }
  }

  // ================= LOGIN =================
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final res = await ApiService.post(
      'login',
      body: {
        'email': email,
        'password': password,
      },
    );

    if (res['token'] != null) {
      await TokenStorage.saveToken(res['token']);
      ApiService.setToken(res['token']);
      // Save username (if returned by the API) into SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String fullName = '';
      String userEmail = '';
      String userPhone = '';
      String userAddress = '';
      String userGender = '';

      if (res['user'] != null && res['user'] is Map) {
        final user = Map<String, dynamic>.from(res['user']);
        final first = (user['nama_depan'] as String?) ?? '';
        final last = (user['nama_belakang'] as String?) ?? '';
        fullName = (first + ' ' + last).trim();
        userEmail = (user['email'] as String?) ?? '';
        userPhone = (user['phone'] as String?) ?? (user['nomor_hp'] as String?) ?? '';
        userAddress = (user['alamat'] as String?) ?? (user['alamat_lengkap'] as String?) ?? '';
        userGender = (user['jenis_kelamin'] as String?) ?? '';
      } else {
        fullName = (res['nama_depan'] as String?) ?? '';
        userEmail = (res['email'] as String?) ?? '';
        userPhone = (res['nomor_hp'] as String?) ?? '';
      }

      await prefs.setString('user_name', fullName);
      await prefs.setString('user_email', userEmail);
      await prefs.setString('user_phone', userPhone);
      await prefs.setString('user_address', userAddress);
      await prefs.setString('user_gender', userGender);
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
    final res = await ApiService.post(
      'register',
      body: {
        'email': email,
        'nama_depan': namaDepan,
        'nama_belakang': namaBelakang,
        'jenis_kelamin': jenisKelamin,
        'password': password,
      },
    );

    if (res['token'] != null) {
      await TokenStorage.saveToken(res['token']);
      ApiService.setToken(res['token']);
      // Save basic profile to SharedPreferences so forms can prefill
      final prefs = await SharedPreferences.getInstance();
      final fullName = '${namaDepan.trim()} ${namaBelakang.trim()}'.trim();
      await prefs.setString('user_name', fullName);
      await prefs.setString('user_email', email);
      await prefs.setString('user_gender', jenisKelamin);
      return true;
    }

    return false;
  }

  // ================= LOGOUT =================
  static Future<void> logout() async {
    await ApiService.post('logout');
    await TokenStorage.clearToken();
    ApiService.setToken(null);
  }
}

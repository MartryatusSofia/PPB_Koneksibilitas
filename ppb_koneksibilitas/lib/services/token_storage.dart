import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _key = 'api_token';   // SAMAKAN DENGAN SEMUA MODUL

  // ================= SIMPAN TOKEN =================
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token.isNotEmpty) {
      await prefs.setString(_key, token);
    }
  }

  // ================= AMBIL TOKEN =================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_key);

    if (token == null || token.isEmpty) {
      return null;
    }
    return token;
  }

  // ================= HAPUS TOKEN =================
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

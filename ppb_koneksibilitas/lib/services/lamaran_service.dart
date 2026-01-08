import 'api_service.dart';
import 'token_storage.dart';

class LamaranService {
  static Future<List<dynamic>> fetchLamaran() async {
    final token = await TokenStorage.getToken();
    
    // Minta semua data, filter dilakukan di UI
    final response = await ApiService.get(
      'status-lamaran', 
      token: token,
      query: {'status': 'Semua'}
    );

    if (response['success'] == true) {
      return response['data'];
    } else {
      throw Exception("Gagal mengambil data lamaran");
    }
  }
}
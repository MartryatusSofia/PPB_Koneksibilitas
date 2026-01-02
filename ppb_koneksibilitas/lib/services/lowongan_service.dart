import 'package:ppb_koneksibilitas/services/api_service.dart';
import '../models/lowongan_model.dart';

class LowonganService {
  // =========================
  // SEARCH LOWONGAN
  // =========================
  static Future<List<Lowongan>> fetchLowongan({String? search}) async {
    final body = await ApiService.get(
      'lowongan',
      query: search != null && search.isNotEmpty ? {'search': search} : null,
    );

    final List data = body['data'] ?? [];
    return data
        .map((e) => Lowongan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // =========================
  // DETAIL LOWONGAN
  // =========================
  static Future<Map<String, dynamic>?> fetchDetailLowongan(
    int lowonganId,
  ) async {
    final body = await ApiService.get('lowongan/$lowonganId');

    // format API:
    // { success: true, data: {...} }
    return body['data'] as Map<String, dynamic>?;
  }
}
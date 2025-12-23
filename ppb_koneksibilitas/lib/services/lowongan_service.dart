import 'package:ppb_koneksibilitas/services/api_service.dart';

import '../models/lowongan_model.dart';

class LowonganService {
  static Future<List<Lowongan>> fetchLowongan() async {
    final body = await ApiService.get('lowongan');
    final List data = body['data'] ?? [];
    return data.map((e) => Lowongan.fromJson(e as Map<String, dynamic>)).toList();
  }
}

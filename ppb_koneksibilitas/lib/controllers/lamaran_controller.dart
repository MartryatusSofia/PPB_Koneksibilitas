import '../models/lamaran_model.dart';
import '../services/lamaran_service.dart';

class LamaranController {
  Future<List<LamaranModel>> getLamaranList() async {
    try {
      final rawData = await LamaranService.fetchLamaran();
      return rawData.map((json) => LamaranModel.fromJson(json)).toList();
    } catch (e) {
      print("Error Controller: $e");
      return [];
    }
  }
}
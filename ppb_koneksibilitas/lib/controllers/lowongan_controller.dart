import '../models/lowongan_model.dart';
import '../services/lowongan_service.dart';

class LowonganController {
  Future<List<Lowongan>> getLowongan() {
    return LowonganService.fetchLowongan();
  }
}

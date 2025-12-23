import 'dart:io';

import 'package:ppb_koneksibilitas/services/api_service.dart';
import 'package:ppb_koneksibilitas/services/token_storage.dart';

class LamaranService {
  static Future<List<dynamic>> getMyLamaran() async {
    final token = await TokenStorage.getToken();
    final res = await ApiService.get('lamaran', token: token);
    return res['data'] ?? [];
  }

  static Future<Map<String, dynamic>> getDetail(int id) async {
    final token = await TokenStorage.getToken();
    return ApiService.get('lamaran/$id', token: token);
  }

  static Future<Map<String, dynamic>> create({
    required int lowonganId,
    required String namaLengkap,
    required String jenisKelamin,
    required String nomorHp,
    required String alamatLengkap,
    required String email,
    required String pendidikan,
    required String namaInstitusi,
    required String jurusan,
    required int thStart,
    required int thEnd,
    String? alatBantu,
    File? cv,
    File? resume,
    File? portofolio,
  }) async {
    final token = await TokenStorage.getToken();

    final fields = <String, String>{
      'lowongan_id': lowonganId.toString(),
      'nama_lengkap': namaLengkap,
      'jenis_kelamin': jenisKelamin,
      'nomor_hp': nomorHp,
      'alamat_lengkap': alamatLengkap,
      'email': email,
      'pendidikan': pendidikan,
      'nama_institusi': namaInstitusi,
      'jurusan': jurusan,
      'th_start': thStart.toString(),
      'th_end': thEnd.toString(),
      if (alatBantu != null) 'alat_bantu': alatBantu,
    };

    final files = <String, File>{};
    if (cv != null) files['cv'] = cv;
    if (resume != null) files['resume'] = resume;
    if (portofolio != null) files['portofolio'] = portofolio;

    return ApiService.postMultipart(
      'lamaran',
      token: token,
      fields: fields,
      files: files.isEmpty ? null : files,
    );
  }
}


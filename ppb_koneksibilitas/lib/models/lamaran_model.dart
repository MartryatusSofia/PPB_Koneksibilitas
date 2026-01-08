class LamaranModel {
  final int id;
  final String status;
  final String tanggal;
  final String posisi;
  final String perusahaan;

  LamaranModel({
    required this.id,
    required this.status,
    required this.tanggal,
    required this.posisi,
    required this.perusahaan,
  });

  factory LamaranModel.fromJson(Map<String, dynamic> json) {
    // 1. Ambil status mentah dari database
    String rawStatus = json['status'] ?? 'Terkirim';

    // 2. Normalisasi: Jika database isinya bahasa Inggris, kita ubah ke Indonesia
    // agar sesuai dengan Tab Filter dan Warna UI
    if (rawStatus.toLowerCase() == 'submitted') {
      rawStatus = 'Terkirim';
    } else if (rawStatus.toLowerCase() == 'accepted' || rawStatus.toLowerCase() == 'approved') {
      rawStatus = 'Diproses';
    } else if (rawStatus.toLowerCase() == 'rejected' || rawStatus.toLowerCase() == 'declined') {
      rawStatus = 'Ditolak';
    }

    return LamaranModel(
      id: json['id'] ?? 0,
      status: rawStatus, // Gunakan status yang sudah dibahasa-indonesiakan
      tanggal: json['tanggal'] ?? '-',
      posisi: json['posisi'] ?? '-',
      perusahaan: json['perusahaan'] ?? '-',
    );
  }
}
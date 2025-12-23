class Lowongan {
  final int id;
  final String posisi;
  final String perusahaan;
  final String kategori;
  final String? persyaratan;
  final String? createdAt;
  final String? approvedAt;

  Lowongan({
    required this.id,
    required this.posisi,
    required this.perusahaan,
    required this.kategori,
    this.persyaratan,
    this.createdAt,
    this.approvedAt,
  });

  factory Lowongan.fromJson(Map<String, dynamic> json) {
    final perusahaanData = json['perusahaan'] as Map<String, dynamic>?;
    return Lowongan(
      id: _parseInt(json['lowongan_id'] ?? json['id']),
      posisi: json['posisi'] ?? '',
      perusahaan: perusahaanData?['nama_perusahaan'] ?? '',
      kategori: json['kategori_pekerjaan'] ?? '-',
      persyaratan: json['persyaratan'],
      createdAt: json['created_at'],
      approvedAt: json['approved_at'],
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}

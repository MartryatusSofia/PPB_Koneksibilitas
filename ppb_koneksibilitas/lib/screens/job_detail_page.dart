import 'package:flutter/material.dart';
import '../services/lowongan_service.dart';
import 'package:flutter_html/flutter_html.dart';
import 'lamaran_data_pribadi.dart';

class JobDetailPage extends StatelessWidget {
  final int lowonganId;

  const JobDetailPage({super.key, required this.lowonganId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Informasi Lowongan",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: LowonganService.fetchDetailLowongan(lowonganId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat detail lowongan'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          final Map<String, dynamic> data = snapshot.data!;

          final title = data['posisi'] ?? 'Posisi tidak tersedia';

          final company =
              data['perusahaan']?['nama'] ?? 'Perusahaan tidak diketahui';

          final kategori =
              data['kategori_pekerjaan'] ?? 'Kategori tidak tersedia';

          final logo = 'https://img.icons8.com/fluency/48/company.png';

          final persyaratan =
              data['persyaratan'] ?? '<p>Belum ada persyaratan</p>';

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(logo),
                      radius: 28,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          company,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.bookmark_border),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  "Lowongan tersedia",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Kategori Pekerjaan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  kategori,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 16),
                const Text(
                  "Persyaratan Lowongan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),
                Html(data: persyaratan),

                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DataPribadiPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Lamar Pekerjaan",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
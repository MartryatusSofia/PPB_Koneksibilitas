import 'package:flutter/material.dart';
import 'lamaran_data_pribadi.dart';

class JobDetailPage extends StatefulWidget {
  final int lowonganId;
  final String title;
  final String company;
  final String logo;

  const JobDetailPage({
    super.key,
    required this.lowonganId,
    required this.title,
    required this.company,
    required this.logo,
  });

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  bool _isSaved = false;

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSaved ? 'Lowongan disimpan' : 'Lowongan dihapus',
        ),
      ),
    );
  }

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
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.black,
            ),
            onPressed: _toggleSave,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.logo),
                  radius: 28,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.company,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Lowongan tersedia",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const Text("Customer Support Specialist"),

            const SizedBox(height: 16),

            const Text(
              "Status Lowongan Saat Ini",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const Row(
              children: [
                Icon(Icons.people_outline, size: 18),
                SizedBox(width: 4),
                Text("8 Pendaftar"),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              "Kebutuhan Dokumen",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DocItem(text: "CV"),
                DocItem(text: "Resume"),
                DocItem(text: "Portofolio"),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              "Persyaratan Lowongan",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            const Text(
              "Fresh Graduate atau memiliki pengalaman minimal 1 tahun.\n"
              "Siap bekerja di bawah tekanan.",
            ),

            const Spacer(),

            // ===== BUTTON LAMAR =====
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // ✅ teks putih
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== DOC ITEM =====
class DocItem extends StatelessWidget {
  final String text;
  const DocItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.circle, color: Colors.amber, size: 12),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

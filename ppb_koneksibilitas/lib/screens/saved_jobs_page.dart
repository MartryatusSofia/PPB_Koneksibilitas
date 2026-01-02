import 'package:flutter/material.dart';

import '../services/saved_lowongan_service.dart';
import '../controllers/lowongan_controller.dart';
import '../models/lowongan_model.dart';
import '../widgets/app_bottom_nav.dart';
import 'job_detail_page.dart';

class SavedJobPage extends StatefulWidget {
  const SavedJobPage({super.key});

  @override
  State<SavedJobPage> createState() => _SavedJobPageState();
}

class _SavedJobPageState extends State<SavedJobPage> {
  final SavedLowonganService _savedService = SavedLowonganService();
  final LowonganController _lowonganController = LowonganController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lowongan Tersimpan'),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: FutureBuilder(
        future: Future.wait([
          _savedService.getSavedIds(),
          _lowonganController.getLowongan(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Gagal memuat data'));
          }

          final savedIds = snapshot.data![0] as List<int>;
          final allLowongan = snapshot.data![1] as List<Lowongan>;

          final savedLowongan =
              allLowongan.where((l) => savedIds.contains(l.id)).toList();

          if (savedLowongan.isEmpty) {
            return const Center(child: Text('Belum ada lowongan tersimpan'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: savedLowongan.length,
            itemBuilder: (context, index) {
              final item = savedLowongan[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    item.posisi,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item.perusahaan),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailPage(
                            lowonganId: item.id,
                            title: item.posisi,
                            company: item.perusahaan,
                            logo:
                                'https://img.icons8.com/fluency/48/company.png',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Lamar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

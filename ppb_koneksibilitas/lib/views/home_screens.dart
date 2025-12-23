import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ppb_koneksibilitas/controllers/lowongan_controller.dart';
import 'package:ppb_koneksibilitas/models/lowongan_model.dart';

import 'package:ppb_koneksibilitas/widgets/app_bottom_nav.dart';
import 'package:ppb_koneksibilitas/widgets/job_card.dart';
import 'package:ppb_koneksibilitas/widgets/training_card.dart';

import 'package:ppb_koneksibilitas/screens/search_screens.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final LowonganController _lowonganController = LowonganController();

  /// USERNAME DARI INPUT LOGIN
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  /// AMBIL USERNAME DARI SHARED PREFERENCES
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('user_name');

    debugPrint('USERNAME LOGIN: $username');

    setState(() {
      _userName = username ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2563EB);
    const textDark = Color(0xFF1F2937);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo! $_userName Selamat Datang 👋🏻',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 34,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                      children: [
                        TextSpan(text: 'Gunakan Kesempatanmu\n'),
                        TextSpan(
                          text: 'Di Koneksibilitas',
                          style: TextStyle(color: primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SEARCH BAR
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchScreens(),
                        ),
                      );
                    },
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.black54),
                          SizedBox(width: 8),
                          Text(
                            'Cari pekerjaan…',
                            style: TextStyle(color: Color(0xFF9CA3AF)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rekomendasi untuk kamu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// ========= LOWONGAN =========
                    FutureBuilder<List<Lowongan>>(
                      future: _lowonganController.getLowongan(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Text('Gagal memuat data lowongan');
                        }

                        final lowongan = snapshot.data!;

                        if (lowongan.isEmpty) {
                          return const Text(
                            'Belum ada lowongan yang tersedia',
                          );
                        }

                        return Column(
                          children: lowongan.map((item) {
                            return JobCard(
                              title: item.posisi,
                              company: item.perusahaan,
                              tag: item.kategori,
                              logoUrl:
                                  'https://img.icons8.com/fluency/48/company.png',
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // ========= TRAINING =========
                    const Text(
                      'Pelatihan Online',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 280,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          TrainingCard(
                            imageUrl:
                                'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800',
                            title: 'Belajar dasar-dasar SEO',
                            description:
                                'Kelas ini membahas konsep dasar Search Engine Optimization',
                          ),
                          SizedBox(width: 12),
                          TrainingCard(
                            imageUrl:
                                'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800',
                            title: 'UI/UX untuk Pemula',
                            description:
                                'Pelajari prinsip desain antarmuka & pengalaman pengguna',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

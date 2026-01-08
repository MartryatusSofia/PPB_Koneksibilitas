import 'package:flutter/material.dart';
import '../controllers/lamaran_controller.dart';
import '../models/lamaran_model.dart';
import '../widgets/app_bottom_nav.dart';

class StatusLamaranPage extends StatefulWidget {
  const StatusLamaranPage({super.key});

  @override
  State<StatusLamaranPage> createState() => _StatusLamaranPageState();
}

class _StatusLamaranPageState extends State<StatusLamaranPage> {
  final LamaranController _controller = LamaranController();
  
  List<LamaranModel> _allLamaran = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _controller.getLamaranList();
    if (mounted) {
      setState(() {
        _allLamaran = data;
        _isLoading = false;
      });
    }
  }

  // Helper Warna Status (Sesuai Request: Terkirim, Diproses, Ditolak)
  Color _statusColor(String status) {
    switch (status) {
      case "Terkirim": return const Color(0xFFD6E9FF); // Biru Muda
      case "Diproses": return const Color(0xFFD8F7E1); // Hijau Muda
      case "Ditolak": return const Color(0xFFFFD8D8);  // Merah Muda
      default: return Colors.grey.shade200;
    }
  }

  Color _textColor(String status) {
    switch (status) {
      case "Terkirim": return const Color(0xFF0D80F2); // Biru Tua
      case "Diproses": return const Color(0xFF28A745); // Hijau Tua
      case "Ditolak": return const Color(0xFFE74C3C);  // Merah Tua
      default: return Colors.black;
    }
  }

  // Widget Card Item
  Widget _buildLamaranCard(LamaranModel lamaran) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Icon Gedung (Pengganti Logo)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.domain, color: Colors.blue, size: 28),
            ),
            const SizedBox(width: 12),
            
            // Info Lowongan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lamaran.posisi,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lamaran.perusahaan,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lamaran.tanggal,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
            ),
            
            // Badge Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _statusColor(lamaran.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                lamaran.status, // Ini sekarang pasti 'Terkirim', bukan 'submitted'
                style: TextStyle(
                  color: _textColor(lamaran.status),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tab sesuai request
    final tabs = ["Semua", "Terkirim", "Diproses", "Ditolak"];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Status Lamaran', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          bottom: TabBar(
            labelColor: const Color(0xFF0D80F2),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF0D80F2),
            isScrollable: true,
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: tabs.map((tab) {
                  // FILTERING DATA
                  List<LamaranModel> filteredList;
                  
                  if (tab == "Semua") {
                    filteredList = _allLamaran;
                  } else {
                    // Karena Model sudah mengubah 'submitted' jadi 'Terkirim',
                    // Filter ini sekarang akan BERHASIL menangkap datanya.
                    filteredList = _allLamaran
                        .where((item) => item.status == tab)
                        .toList();
                  }

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text("Tidak ada lamaran ($tab)", style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return _buildLamaranCard(filteredList[index]);
                    },
                  );
                }).toList(),
              ),
        bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      ),
    );
  }
}
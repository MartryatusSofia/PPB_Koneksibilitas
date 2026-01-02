import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ppb_koneksibilitas/services/api_service.dart';
import '../widgets/app_bottom_nav.dart';
import 'package:ppb_koneksibilitas/services/token_storage.dart';

class StatusLamaranPage extends StatefulWidget {
  const StatusLamaranPage({super.key});

  @override
  State<StatusLamaranPage> createState() => _StatusLamaranPageState();
}

class _StatusLamaranPageState extends State<StatusLamaranPage> {
  List<dynamic> lamaranList = [];
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _fetchLamaranData();
  }
  
  Future<void> _fetchLamaranData() async {
    try {
      final String? token = await TokenStorage.getToken();
      if (token == null) {
        print("User belum login");
        setState(() => _isLoading = false);
        return;
      }
      final response = await ApiService.get(
        'status-lamaran', 
        token: token,     
        query: {'status': 'Semua'}, 
      );

      if (mounted) {
        setState(() {
          lamaranList = response['data']; 
          _isLoading = false;
        });
      }

    } catch (e) {
      print("Error fetching data: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        if (e.toString().contains('401')) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Sesi habis, silakan login ulang")),
           );
        }
      }
    }
  }
  Color _statusColor(String status) {
    switch (status) {
      case "Terkirim": return const Color(0xFFD6E9FF);
      case "Diproses": return const Color(0xFFD8F7E1);
      case "Ditolak": return const Color(0xFFFFD8D8);
      default: return Colors.grey.shade200;
    }
  }
  Color _textColor(String status) {
    switch (status) {
      case "Terkirim": return const Color(0xFF0D80F2);
      case "Diproses": return const Color(0xFF28A745);
      case "Ditolak": return const Color(0xFFE74C3C);
      default: return Colors.black;
    }
  }
  Widget _buildLamaranCard(Map<String, dynamic> data) {
    // Parsing data nested agar aman dari null
    final lowongan = data['lowongan'] ?? {};
    final perusahaan = lowongan['perusahaan'] ?? {};
    final status = data['status'] ?? 'Unknown';
    final String baseUrlImage = "http://10.0.2.2:8000/storage/"; 

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            "$baseUrlImage${perusahaan['logo']}", 
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 48, 
                height: 48, 
                color: Colors.grey.shade300, 
                child: const Icon(Icons.business, color: Colors.grey)
              );
            },
          ),
        ),
        title: Text(
          lowongan['posisi'] ?? 'Posisi Kosong', 
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(perusahaan['nama_perusahaan'] ?? 'Perusahaan Kosong'),
        trailing: Container(
          decoration: BoxDecoration(
            color: _statusColor(status),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            status,
            style: TextStyle(
              color: _textColor(status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ["Semua", "Terkirim", "Diproses", "Ditolak"];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Status Lamaran',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF0D80F2),
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : TabBarView(
              children: tabs.map((tab) {
                List filtered = tab == "Semua"
                    ? lamaranList
                    : lamaranList.where((item) => item['status'] == tab).toList();
                
                if (filtered.isEmpty) {
                  return Center(child: Text("Belum ada lamaran ($tab)"));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return _buildLamaranCard(filtered[index]);
                  },
                );
              }).toList(),
            ),
        bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      ),
    );
  }
}
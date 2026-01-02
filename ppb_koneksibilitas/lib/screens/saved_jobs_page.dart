import 'package:flutter/material.dart';
import 'job_detail_page.dart';
import '../widgets/app_bottom_nav.dart';

class SavedJobsPage extends StatelessWidget {
  const SavedJobsPage({super.key});

  final List<Map<String, dynamic>> jobs = const [
    {
      'id': 1,
      'title': 'Admin Toko Online',
      'company': 'GlobalTrans Indo',
      'logo': 'https://img.icons8.com/color/48/000000/google-logo.png',
    },
    {
      'id': 2,
      'title': 'Desain Grafis',
      'company': 'CV. Kreasi Warna',
      'logo': 'https://img.icons8.com/color/48/000000/adobe-illustrator.png',
    },
    {
      'id': 3,
      'title': 'Data Entry Operator',
      'company': 'PT. Digital Nusantara',
      'logo': 'https://img.icons8.com/color/48/000000/database.png',
    },
    {
      'id': 4,
      'title': 'Admin Sosial Media',
      'company': 'GlobalTrans Indo',
      'logo': 'https://img.icons8.com/color/48/000000/facebook-new.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lowongan Tersimpan",
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Edit",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(job['logo']!),
                radius: 24,
              ),
              title: Text(
                job['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(job['company']!),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JobDetailPage(lowonganId: job['id']),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                "Lamar",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}
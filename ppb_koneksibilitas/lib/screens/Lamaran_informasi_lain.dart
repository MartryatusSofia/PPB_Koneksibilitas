import 'package:flutter/material.dart';
import 'package:ppb_koneksibilitas/views/home_screens.dart';

class InformasiLainPage extends StatefulWidget {
  const InformasiLainPage({super.key});

  @override
  State<InformasiLainPage> createState() => _InformasiLainPageState();
}

class _InformasiLainPageState extends State<InformasiLainPage> {
  final TextEditingController alatBantuController = TextEditingController();
  String? jenisDisabilitas;
  bool fileUploaded = false;

  Widget labelWajib(String text) {
    return Row(
      children: [
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Text(' *', style: TextStyle(color: Colors.red)),
      ],
    );
  }

  InputDecoration inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFDADADA), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFDADADA), width: 1.2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Lamar Pekerjaan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    'Step 3',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Informasi Lain',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),


            labelWajib("Jenis Disabilitas"),
            const SizedBox(height: 6),
            Row(
              children: [
                Radio<String>(
                  value: 'Tuna Wicara',
                  groupValue: jenisDisabilitas,
                  activeColor: Colors.blue,
                  onChanged: (val) {
                    setState(() {
                      jenisDisabilitas = val;
                    });
                  },
                ),
                const Text('Tuna Wicara'),
                const SizedBox(width: 24),
                Radio<String>(
                  value: 'Tuna Rungu',
                  groupValue: jenisDisabilitas,
                  activeColor: Colors.blue,
                  onChanged: (val) {
                    setState(() {
                      jenisDisabilitas = val;
                    });
                  },
                ),
                const Text('Tuna Rungu'),
                const SizedBox(width: 24),
                Radio<String>(
                  value: 'Lainnya',
                  groupValue: jenisDisabilitas,
                  activeColor: Colors.blue,
                  onChanged: (val) {
                    setState(() {
                      jenisDisabilitas = val;
                    });
                  },
                ),
                const Text('Lainnya'),
              ],
            ),
            const SizedBox(height: 18),

            labelWajib("Alat Bantu yang Digunakan"),
            const SizedBox(height: 6),
            TextField(
              controller: alatBantuController,
              decoration: inputStyle("Masukkan alat bantu (jika tidak ada ketik - )"),
            ),
            const SizedBox(height: 18),

            labelWajib("Unggah Dokumen"),
            const SizedBox(height: 6),
            const Text(
              '(Unggah dokumen pendukung seperti CV, portofolio, atau dokumen lainnya.)',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                setState(() {
                  fileUploaded = true;
                });
              },
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: fileUploaded ? Colors.blue : Colors.grey.shade400,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file,
                        color: fileUploaded ? Colors.blue : Colors.grey,
                        size: 32,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        fileUploaded
                            ? "File berhasil diunggah"
                            : "Upload file",
                        style: TextStyle(
                          color: fileUploaded ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Selesai
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (jenisDisabilitas == null ||
                      alatBantuController.text.isEmpty ||
                      !fileUploaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lengkapi semua data wajib terlebih dahulu.'),
                      ),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data berhasil disimpan!'),
                    ),
                  );

                  // Setelah 1 detik, kembali ke beranda
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreens()),
                      (route) => false,
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Selesai',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

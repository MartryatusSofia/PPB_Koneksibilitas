import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'package:ppb_koneksibilitas/views/home_screens.dart';

class InformasiLainPage extends StatefulWidget {
  final int applicationId;
  final int lowonganId;
  const InformasiLainPage({Key? key, required this.applicationId, required this.lowonganId}) : super(key: key);

  @override
  State<InformasiLainPage> createState() => _InformasiLainPageState();
}

class _InformasiLainPageState extends State<InformasiLainPage> {
  final alatBantuController = TextEditingController();
  String? jenisDisabilitas;

  PlatformFile? cvFile;
  PlatformFile? portofolioFile;
  List<PlatformFile> additionalFiles = [];

  Future<void> pickCv() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );
    if (res != null && res.files.isNotEmpty) {
      setState(() => cvFile = res.files.first);
    }
  }

  Future<void> pickPortofolio() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'zip', 'jpg', 'png'],
      withData: true,
    );
    if (res != null && res.files.isNotEmpty) {
      setState(() => portofolioFile = res.files.first);
    }
  }

  Future<void> pickAdditional() async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );
    if (res != null && res.files.isNotEmpty) {
      setState(() => additionalFiles = res.files);
    }
  }

  Widget label(String t, {bool required = true}) => Row(children: [
        Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
        if (required) const Text(" *", style: TextStyle(color: Colors.red))
      ]);

  InputDecoration inputStyle(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDADADA))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0D80F2))),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text('Lamar Pekerjaan',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Center(
              child: Column(children: [
            Text("Step 3",
                style: TextStyle(
                    color: Color(0xFF0D80F2), fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("Informasi Lain",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
          ])),
          const SizedBox(height: 30),

          label("Jenis Disabilitas"),
          const SizedBox(height: 6),
          Wrap(
            spacing: 24,
            children: ["Tuna Rungu / Tuna Wicara", "Lainnya"]
                .map((e) => Row(mainAxisSize: MainAxisSize.min, children: [
                      Radio<String>(
                          value: e,
                          groupValue: jenisDisabilitas,
                          onChanged: (v) =>
                              setState(() => jenisDisabilitas = v)),
                      Text(e)
                    ]))
                .toList(),
          ),
          const SizedBox(height: 18),

            label("Alat Bantu", required: false),
            const SizedBox(height: 6),
            TextField(
              controller: alatBantuController,
              decoration: inputStyle("Contoh: Alat bantu dengar")),
            const SizedBox(height: 18),

            // CV
            const Text('CV *', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Row(children: [
              OutlinedButton.icon(
                onPressed: pickCv,
                icon: const Icon(Icons.upload_file, color: Color(0xFF6D28D9)),
                label: const Text('Choose File', style: TextStyle(color: Color(0xFF6D28D9))),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F3FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(cvFile?.name ?? 'No file chosen',
                      style: const TextStyle(color: Colors.black54))),
            ]),
            const SizedBox(height: 18),

            // Portofolio
            const Text('Portofolio', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Row(children: [
              OutlinedButton.icon(
                onPressed: pickPortofolio,
                icon: const Icon(Icons.upload_file, color: Color(0xFF6D28D9)),
                label: const Text('Choose File', style: TextStyle(color: Color(0xFF6D28D9))),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F3FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(portofolioFile?.name ?? 'No file chosen',
                      style: const TextStyle(color: Colors.black54))),
            ]),
            const SizedBox(height: 18),

            // Additional documents
            const Text('Dokumen Tambahan', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Row(children: [
              OutlinedButton.icon(
                onPressed: pickAdditional,
                icon: const Icon(Icons.upload_file, color: Color(0xFF6D28D9)),
                label: const Text('Choose Files', style: TextStyle(color: Color(0xFF6D28D9))),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F3FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(
                      additionalFiles.isNotEmpty
                          ? additionalFiles.map((f) => f.name).join(', ')
                          : 'No file chosen',
                      style: const TextStyle(color: Colors.black54))),
            ]),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D80F2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: const Text("Selesai",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: () async {
                if (jenisDisabilitas == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Pilih jenis disabilitas")));
                  return;
                }

                // build fields
                final fields = <String, String>{
                  "application_id": widget.applicationId.toString(),
                  "lowongan_id": widget.lowonganId.toString(),
                  "assistive_tools": alatBantuController.text,
                  if (jenisDisabilitas != null) "jenis_disabilitas": jenisDisabilitas!,
                };

                // build files map for multipart
                final files = <String, dynamic>{};

                if (cvFile != null) {
                  if (kIsWeb) {
                    files['cv'] = {'bytes': cvFile!.bytes!, 'name': cvFile!.name};
                  } else if (cvFile!.path != null) {
                    files['cv'] = File(cvFile!.path!);
                  }
                }

                if (portofolioFile != null) {
                  if (kIsWeb) {
                    files['portofolio'] = {'bytes': portofolioFile!.bytes!, 'name': portofolioFile!.name};
                  } else if (portofolioFile!.path != null) {
                    files['portofolio'] = File(portofolioFile!.path!);
                  }
                }

                if (additionalFiles.isNotEmpty) {
                  if (kIsWeb) {
                    files['resume'] = additionalFiles
                        .map((f) => {'bytes': f.bytes!, 'name': f.name})
                        .toList();
                  } else {
                    files['resume'] = additionalFiles
                        .where((f) => f.path != null)
                        .map((f) => File(f.path!))
                        .toList();
                  }
                }

                await ApiService.postMultipart(
                  "mobile/lamaran/step3",
                  token: ApiService.token,
                  fields: fields,
                  files: files.isEmpty ? null : files,
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreens()),
                  (_) => false,
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}

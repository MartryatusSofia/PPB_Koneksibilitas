import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'lamaran_informasi_lain.dart';

class RiwayatPendidikanPage extends StatefulWidget {
  final int applicationId;
  final int lowonganId;
  const RiwayatPendidikanPage({Key? key, required this.applicationId, required this.lowonganId}) : super(key: key);

  @override
  State<RiwayatPendidikanPage> createState() => _RiwayatPendidikanPageState();
}

class _RiwayatPendidikanPageState extends State<RiwayatPendidikanPage> {
  final _formKey = GlobalKey<FormState>();

  final institusiController = TextEditingController();
  final jurusanController = TextEditingController();
  final tahunMulaiController = TextEditingController();
  final tahunBerakhirController = TextEditingController();
  String? pendidikanTerakhir;

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

  Widget label(String t) => Row(children: [
        Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Text(" *", style: TextStyle(color: Colors.red))
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Lamar Pekerjaan',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Center(
              child: Column(children: [
                Text("Step 2",
                    style: TextStyle(
                        color: Color(0xFF0D80F2),
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Riwayat Pendidikan",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
              ]),
            ),
            const SizedBox(height: 30),

            label("Pendidikan Terakhir"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              decoration: inputStyle("Pilih pendidikan terakhir"),
              items: const [
                DropdownMenuItem(value: "SMA/SMK", child: Text("SMA/SMK")),
                DropdownMenuItem(value: "Diploma", child: Text("Diploma")),
                DropdownMenuItem(
                    value: "Sarjana (S1)", child: Text("Sarjana (S1)")),
                DropdownMenuItem(
                    value: "Magister (S2)", child: Text("Magister (S2)")),
              ],
              onChanged: (v) => pendidikanTerakhir = v,
              validator: (v) => v == null ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 18),

            label("Nama Institusi"),
            const SizedBox(height: 6),
            TextFormField(
                controller: institusiController,
                decoration: inputStyle("Masukkan nama institusi"),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null),
            const SizedBox(height: 18),

            label("Jurusan"),
            const SizedBox(height: 6),
            TextFormField(
                controller: jurusanController,
                decoration: inputStyle("Masukkan jurusan"),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null),
            const SizedBox(height: 18),

            label("Tahun Mulai"),
            const SizedBox(height: 6),
            TextFormField(
                controller: tahunMulaiController,
                keyboardType: TextInputType.number,
                decoration: inputStyle("Masukkan tahun mulai")),
            const SizedBox(height: 18),

            label("Tahun Berakhir"),
            const SizedBox(height: 6),
            TextFormField(
                controller: tahunBerakhirController,
                keyboardType: TextInputType.number,
                decoration: inputStyle("Masukkan tahun berakhir")),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D80F2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: const Text("Lanjutkan",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  await ApiService.post(
                    "mobile/lamaran/step2",
                    token: ApiService.token,
                    body: {
                      "application_id": widget.applicationId.toString(),
                      "lowongan_id": widget.lowonganId.toString(),
                      "last_education": pendidikanTerakhir!,
                      "institution": institusiController.text,
                      "major": jurusanController.text,
                      "year_start": tahunMulaiController.text,
                      "year_end": tahunBerakhirController.text,
                    },
                  );

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => InformasiLainPage(
                              applicationId: widget.applicationId, lowonganId: widget.lowonganId)));
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}

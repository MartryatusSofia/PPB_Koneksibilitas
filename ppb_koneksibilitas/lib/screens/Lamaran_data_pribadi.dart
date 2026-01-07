import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lamaran_riwayat_pendidikan.dart';

class DataPribadiPage extends StatefulWidget {
  final int lowonganId;   // 🔥 WAJIB

  const DataPribadiPage({
    required this.lowonganId,
    Key? key,
  }) : super(key: key);

  @override
  State<DataPribadiPage> createState() => _DataPribadiPageState();
}

class _DataPribadiPageState extends State<DataPribadiPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final noHpController = TextEditingController();
  final emailController = TextEditingController();

  String? jenisKelamin;

  InputDecoration inputStyle(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDADADA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0D80F2)),
        ),
      );

  Widget label(String t) => Row(children: [
        Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Text(" *", style: TextStyle(color: Colors.red))
      ]);

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString('user_name') ?? '';
    final email = prefs.getString('user_email') ?? '';
    final phone = prefs.getString('user_phone') ?? '';
    final address = prefs.getString('user_address') ?? '';
    final gender = prefs.getString('user_gender') ?? '';

    if (fullName.isNotEmpty) namaController.text = fullName;
    if (email.isNotEmpty) emailController.text = email;
    if (phone.isNotEmpty) noHpController.text = phone;
    if (address.isNotEmpty) alamatController.text = address;
    if (gender.isNotEmpty) setState(() => jenisKelamin = gender);
  }

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
                Text("Step 1",
                    style: TextStyle(
                        color: Color(0xFF0D80F2),
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Data Pribadi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ]),
            ),
            const SizedBox(height: 30),

            label("Nama Lengkap"),
            const SizedBox(height: 6),
            TextFormField(
              controller: namaController,
              decoration: inputStyle("Masukkan nama lengkap"),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 18),

            label("Jenis Kelamin"),
            const SizedBox(height: 6),
            Row(children: [
              Radio<String>(
                  value: 'Laki-laki',
                  groupValue: jenisKelamin,
                  onChanged: (v) => setState(() => jenisKelamin = v)),
              const Text('Laki-laki'),
              const SizedBox(width: 24),
              Radio<String>(
                  value: 'Perempuan',
                  groupValue: jenisKelamin,
                  onChanged: (v) => setState(() => jenisKelamin = v)),
              const Text('Perempuan'),
            ]),
            const SizedBox(height: 18),

            label("Nomor HP"),
            const SizedBox(height: 6),
            TextFormField(
              controller: noHpController,
              decoration: inputStyle("Masukkan nomor HP"),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 18),

            label("Alamat Lengkap"),
            const SizedBox(height: 6),
            TextFormField(
              controller: alamatController,
              decoration: inputStyle("Masukkan alamat lengkap"),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 18),

            label("Email"),
            const SizedBox(height: 6),
            TextFormField(
              controller: emailController,
              decoration: inputStyle("Masukkan email"),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
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
                  if (!_formKey.currentState!.validate() || jenisKelamin == null) return;

                  try {
                    final res = await ApiService.post(
                      "mobile/lamaran/step1",
                      token: ApiService.token,
                      body: {
                        "lowongan_id": widget.lowonganId,   // 🔥 INI KUNCINYA
                        "full_name": namaController.text,
                        "gender": jenisKelamin,
                        "phone": noHpController.text,
                        "email": emailController.text,
                        "address": alamatController.text,
                      },
                    );

                    final id = int.parse(res['application_id'].toString());

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RiwayatPendidikanPage(
                            applicationId: id, lowonganId: widget.lowonganId),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}

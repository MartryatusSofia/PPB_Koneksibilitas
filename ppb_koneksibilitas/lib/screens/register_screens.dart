// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'login_screens.dart';
import 'package:ppb_koneksibilitas/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? selectedGender;
  bool obscureText = true;
  bool isChecked = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Image.asset('assets/register.png', height: 150),
            const SizedBox(height: 20),

            const Text(
              'KONEKSIBILITAS',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Text('Daftar sebagai pekerja'),
            const SizedBox(height: 30),

            _input(firstNameController, 'Nama Depan', Icons.person),
            const SizedBox(height: 15),
            _input(lastNameController, 'Nama Belakang', Icons.person),
            const SizedBox(height: 15),
            _input(emailController, 'Email', Icons.email),
            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: obscureText,
              decoration: _decoration(
                'Password',
                Icons.lock,
                suffix: IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => obscureText = !obscureText);
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: _decoration('Jenis Kelamin', Icons.person),
              items: const [
                DropdownMenuItem(
                  value: 'Laki-laki',
                  child: Text('Laki-laki'),
                ),
                DropdownMenuItem(
                  value: 'Perempuan',
                  child: Text('Perempuan'),
                ),
              ],
              onChanged: (value) {
                setState(() => selectedGender = value);
              },
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() => isChecked = value ?? false);
                  },
                ),
                const Expanded(
                  child: Text(
                    'Dengan lanjut, anda setuju pada ketentuan dan privasi',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign Up'),
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOGIC REGISTER =================
  Future<void> _handleRegister() async {
    if (!isChecked || selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final success = await AuthService.register(
        email: emailController.text,
        namaDepan: firstNameController.text,
        namaBelakang: lastNameController.text,
        jenisKelamin: selectedGender!,
        password: passwordController.text,
      );

      setState(() => isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Registrasi berhasil, silakan login'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Registrasi gagal'),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }
  }

  InputDecoration _decoration(String hint, IconData icon,
      {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _input(
      TextEditingController c, String hint, IconData icon) {
    return TextField(
      controller: c,
      decoration: _decoration(hint, icon),
    );
  }
}

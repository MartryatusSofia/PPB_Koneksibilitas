import 'package:flutter/material.dart';

import 'package:ppb_koneksibilitas/views/home_screens.dart';
import 'package:ppb_koneksibilitas/screens/saved_jobs_page.dart';
import 'package:ppb_koneksibilitas/screens/login_screens.dart';
import 'package:ppb_koneksibilitas/screens/register_screens.dart';
import 'package:ppb_koneksibilitas/screens/status_lamaran.dart';
import 'package:ppb_koneksibilitas/screens/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Koneksibilitas',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
      ),

      // Halaman pertama kali dijalankan
      home: const LoginScreen(),

      // Daftar route
      routes: {
        '/home': (context) => const HomeScreens(),
        '/saved-jobs': (context) => const SavedJobsPage(),
        '/register': (context) => const RegisterScreen(),        
        '/profile': (context) => const ProfilePage(),
        '/status-lamaran': (context) => const StatusLamaranPage(),
      },
    );
  }
}

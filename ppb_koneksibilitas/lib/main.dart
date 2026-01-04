import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/saved_job_provider.dart';

import 'views/home_screens.dart';
import 'screens/saved_jobs_page.dart';
import 'screens/login_screens.dart';
import 'screens/register_screens.dart';
import 'screens/status_lamaran.dart';
import 'screens/profile_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SavedJobProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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

      // Halaman pertama
      home: const LoginScreen(),

      // Routes
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

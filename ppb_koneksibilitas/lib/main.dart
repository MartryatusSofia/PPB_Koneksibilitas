import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/saved_job_provider.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';

import 'views/home_screens.dart';
import 'screens/login_screens.dart';
import 'screens/register_screens.dart';
import 'screens/saved_jobs_page.dart';
import 'screens/profile_page.dart';
import 'screens/status_lamaran.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.bootstrap(); // 🔥 restore token

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SavedJobProvider()),
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
      home: ApiService.token == null ? const LoginScreen() : const HomeScreens(),
      routes: {
        '/home': (_) => const HomeScreens(),
        '/saved-jobs': (_) => const SavedJobsPage(),
        '/register': (_) => const RegisterScreen(),
        '/profile': (_) => const ProfilePage(),
        '/status-lamaran': (_) => const StatusLamaranPage(),
      },
    );
  }
}

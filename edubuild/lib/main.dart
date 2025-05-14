import 'package:flutter/material.dart';
import 'package:edubuild/screens/login_screen.dart';
import 'package:edubuild/screens/home_screen.dart';
import 'package:edubuild/screens/add_school_screen.dart';
import 'package:edubuild/screens/monitoring_renovasi_screen.dart';
import 'package:edubuild/screens/umpan_balik_screen.dart';
import 'package:edubuild/screens/search_school_screen.dart';

// ✅ Tambahkan import untuk HomeWithTabs
import 'package:edubuild/screens/home_with_tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduBuild',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: LoginScreen(), // Bisa juga ganti ke HomeWithTabs() langsung untuk testing
      routes: {
        '/home': (context) => const HomeScreen(),
        '/addSchool': (context) => const AddSchoolScreen(),
        '/monitoringRenovasi': (context) => const MonitoringRenovasiScreen(
              namaSekolah: 'SMA Negeri 1 Padang',
              statusProyek: 'Dalam Proses Renovasi',
              riwayatPerbaikan: [
                'Pengecatan ulang ruang kelas (Jan 2024)',
                'Perbaikan atap bocor (Feb 2024)',
              ],
            ),
        '/umpanBalik': (context) => UmpanBalikScreen(
              feedbackList: [
                {
                  'nama': 'Budi',
                  'rating': 5,
                  'komentar': 'Aplikasinya sangat membantu!'
                },
                {
                  'nama': 'Sari',
                  'rating': 4,
                  'komentar': 'UI-nya mudah dipahami.'
                },
              ],
            ),
        // ✅ Tambahkan route ke halaman tab baru
        '/homeWithTabs': (context) => HomeWithTabs(),
      },
    );
  }
}

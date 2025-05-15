import 'package:flutter/material.dart';
import 'package:edubuild/screens/login_screen.dart';
import 'package:edubuild/screens/home_screen.dart';
import 'package:edubuild/screens/add_school_screen.dart';
import 'package:edubuild/screens/monitoring_renovasi_screen.dart';
import 'package:edubuild/screens/umpan_balik_screen.dart';
import 'package:edubuild/screens/search_school_screen.dart';
import 'package:edubuild/screens/home_with_tabs.dart';

// ✅ Tambahkan ini
import 'package:edubuild/widgets/mobile_wrapper.dart';

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
      home: MobileWrapper(child: LoginScreen()), // ✅ tanpa const
      routes: {
        '/home': (context) => const MobileWrapper(child: HomeScreen()),
        '/addSchool': (context) => const MobileWrapper(child: AddSchoolScreen()),
        '/monitoringRenovasi': (context) => const MobileWrapper(
              child: MonitoringRenovasiScreen(
                namaSekolah: 'SMA Negeri 1 Padang',
                statusProyek: 'Dalam Proses Renovasi',
                riwayatPerbaikan: [
                  'Pengecatan ulang ruang kelas (Jan 2024)',
                  'Perbaikan atap bocor (Feb 2024)',
                ],
              ),
            ),
        '/umpanBalik': (context) => const MobileWrapper(
              child: UmpanBalikScreen(
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
            ),
        '/homeWithTabs': (context) => MobileWrapper(child: HomeWithTabs()), // ✅ tanpa const
      },
    );
  }
}

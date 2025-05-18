import 'package:flutter/material.dart';
import 'package:edubuild/screens/login_screen.dart';
import 'package:edubuild/screens/home_screen.dart';
import 'package:edubuild/screens/monitoring_renovasi_screen.dart';
import 'package:edubuild/screens/umpan_balik_screen.dart';

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
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: MobileWrapper(child: LoginScreen()), // ✅ tanpa const
      routes: {
        '/home': (context) => const MobileWrapper(child: HomeScreen()),
        '/monitoringRenovasi':
            (context) => const MobileWrapper(
              child: MonitoringRenovasiScreen(
                namaSekolah: 'SMA Negeri 1 Padang',
                statusProyekAwal: 'Belum Selesai',
                riwayatPerbaikan: [
                  'Pengecatan tembok - April 2024',
                  'Pemasangan atap - Mei 2024',
                  'Perbaikan lantai - Juni 2024',
                ],
              ),
            ),
        '/umpanBalik':
            (context) => const MobileWrapper(
              child: UmpanBalikScreen(
                feedbackList: [
                  {
                    'nama': 'Budi',
                    'rating': 5,
                    'komentar': 'Aplikasinya sangat membantu!',
                  },
                  {
                    'nama': 'Sari',
                    'rating': 4,
                    'komentar': 'UI-nya mudah dipahami.',
                  },
                ],
              ),
            ), // ✅ tanpa const
      },
    );
  }
}

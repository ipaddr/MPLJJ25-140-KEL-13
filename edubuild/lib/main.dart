import 'package:flutter/material.dart';
import 'package:edubuild/screens/login_screen.dart';
import 'package:edubuild/screens/home_screen.dart';
import 'package:edubuild/screens/monitoring_renovasi_screen.dart';
import 'package:edubuild/screens/umpan_balik_screen.dart';
import 'package:edubuild/screens/admin_home_screen.dart';
import 'package:edubuild/screens/order_detail_screen.dart';
<<<<<<< HEAD
import 'package:edubuild/screens/detail_pesanan_screen.dart';
=======
>>>>>>> a1f4df323fb068d3e295688e1ca09c9bc6a2d037
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
      home: const MobileWrapper(child: LoginScreen()),

      // ✅ Pakai onGenerateRoute untuk handle arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/detailPesanan') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => MobileWrapper(
              child: DetailPesananScreen(
                namaSekolah: args['namaSekolah'],
                idPesanan: args['idPesanan'],
                status: args['status'],
                rincian: args['rincian'],
              ),
            ),
          );
        }

<<<<<<< HEAD
        final routes = {
          '/home': (context) => const MobileWrapper(child: HomeScreen()),
          '/monitoringRenovasi': (context) => const MobileWrapper(
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
          '/umpanBalik': (context) => const MobileWrapper(
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
              ),
          '/adminHome': (context) => const AdminHomeScreen(),
          '/orderDetail': (context) => const OrderDetailScreen(),
        };

        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }

        // Fallback route jika route tidak ditemukan
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Halaman tidak ditemukan')),
          ),
        );
=======
        '/umpanBalik': (context) => const MobileWrapper(
              child: UmpanBalikScreen(),
            ),

        '/adminHome': (context) => const AdminHomeScreen(),
        '/orderDetail': (context) => const OrderDetailScreen(),
>>>>>>> a1f4df323fb068d3e295688e1ca09c9bc6a2d037
      },
    );
  }
}
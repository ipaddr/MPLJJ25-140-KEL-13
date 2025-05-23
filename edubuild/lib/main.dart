import 'package:flutter/material.dart';
import 'package:edubuild/screens/login_screen.dart';
import 'package:edubuild/screens/home_screen.dart';
import 'package:edubuild/screens/monitoring_renovasi_screen.dart';
import 'package:edubuild/screens/umpan_balik_screen.dart';
import 'package:edubuild/screens/admin_home_screen.dart';
import 'package:edubuild/screens/order_detail_screen.dart';
import 'package:edubuild/screens/detail_pesanan_screen.dart';
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
      onGenerateRoute: (settings) {
        // Handle routes that need arguments
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

        // Handle standard routes
        final routes = {
          '/login': (context) => const LoginScreen(),
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
                child: UmpanBalikScreen(),
              ),
          '/adminHome': (context) => const MobileWrapper(
                child: AdminHomeScreen(),
              ),
          '/orderDetail': (context) => const MobileWrapper(
                child: OrderDetailScreen(),
              ),
        };

        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }
        
        // Return null for unknown routes
        return null;
      },
    );
  }
}
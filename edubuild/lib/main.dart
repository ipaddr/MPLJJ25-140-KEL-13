import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:edubuild/screens/login_screen.dart';
import 'package:edubuild/screens/home_screen.dart';
import 'package:edubuild/screens/monitoring_renovasi_screen.dart';
import 'package:edubuild/screens/umpan_balik_screen.dart';
import 'package:edubuild/screens/admin_home_screen.dart';
import 'package:edubuild/screens/detail_pesanan_screen.dart';
import 'package:edubuild/widgets/mobile_wrapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Tambahkan import untuk theme controller
import 'package:edubuild/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://fthhyrivyfvvtwfyzqem.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ0aGh5cml2eWZ2dnR3Znl6cWVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA2MDg4MzUsImV4cCI6MjA2NjE4NDgzNX0.ODvdM4u4a5GSjAUXcOSbmwiVBzI0bytMXLPWwEUgWPM',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EduBuild',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: const Color(0xFF181A20),
          ),
          themeMode: mode,
          home: const MobileWrapper(child: LoginScreen()),
          onGenerateRoute: (settings) {
            // Route dengan arguments
            if (settings.name == '/detailPesanan') {
              final args = settings.arguments as Map<String, dynamic>?;
              if (args == null || args['idPesanan'] == null) {
                return MaterialPageRoute(
                  builder:
                      (context) => const Scaffold(
                        body: Center(
                          child: Text('Data pesanan tidak ditemukan'),
                        ),
                      ),
                );
              }
              return MaterialPageRoute(
                builder:
                    (context) => MobileWrapper(
                      child: DetailPesananScreen(idPesanan: args['idPesanan']),
                    ),
              );
            }

            // Route dinamis untuk orderDetail
            if (settings.name == '/orderDetail') {
              final args = settings.arguments as Map<String, dynamic>?;
              if (args == null || args['idPesanan'] == null) {
                return MaterialPageRoute(
                  builder:
                      (context) => const Scaffold(
                        body: Center(
                          child: Text('Data pesanan tidak ditemukan'),
                        ),
                      ),
                );
              }
              return MaterialPageRoute(
                builder:
                    (context) => MobileWrapper(
                      child: DetailPesananScreen(idPesanan: args['idPesanan']),
                    ),
              );
            }

            // Route standar
            final routes = <String, WidgetBuilder>{
              '/home': (context) => const MobileWrapper(child: HomeScreen()),
              '/monitoringRenovasi':
                  (context) => const MobileWrapper(
                    child: MonitoringRenovasiScreen(
                      namaSekolah: 'SMA Negeri 1 Padang',
                    ),
                  ),
              '/umpanBalik':
                  (context) => const MobileWrapper(child: UmpanBalikScreen()),
              '/adminHome':
                  (context) => const MobileWrapper(child: AdminHomeScreen()),
            };

            final builder = routes[settings.name];
            if (builder != null) {
              return MaterialPageRoute(builder: builder);
            }

            // Jika route tidak ditemukan
            return MaterialPageRoute(
              builder:
                  (context) => const Scaffold(
                    body: Center(child: Text('Halaman tidak ditemukan')),
                  ),
            );
          },
        );
      },
    );
  }
}

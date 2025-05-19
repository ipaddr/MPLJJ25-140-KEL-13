import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/monitoring_renovasi_screen.dart';
import '../screens/umpan_balik_screen.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "© EduBuild 2025",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (index) {
            onIndexChanged(index);

            // Navigasi sesuai index
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MonitoringRenovasiScreen(
                          namaSekolah: 'SMA Negeri 1 Padang',
                          statusProyekAwal: 'Sedang Berlangsung',
                          riwayatPerbaikan: const [
                            'Penggantian Atap',
                            'Cat Dinding',
                            'Pemasangan Keramik',
                          ],
                        ),
                  ),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => UmpanBalikScreen(
                          namaSekolah: 'SMA Negeri 1 Padang',
                          riwayatPerbaikan: const [
                            'Penggantian Atap',
                            'Cat Dinding',
                            'Pemasangan Keramik',
                          ],
                          feedbackList: const [
                            {'nama': 'Perlu pengecatan ulang'},
                            {'nama': 'Kondisi toilet kurang bersih'},
                          ],
                        ),
                  ),
                );
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.note_alt),
              label: "Form Input",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              label: "Monitoring",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feedback),
              label: "Umpan Balik",
            ),
          ],
        ),
      ],
    );
  }
}

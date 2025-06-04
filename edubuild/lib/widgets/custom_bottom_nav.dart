import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/home_screen.dart';
import '../screens/monitoring_renovasi_screen.dart';
import '../screens/umpan_balik_screen.dart';
import '../screens/order_detail_screen.dart';
import '../screens/chatbot.dart';

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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Ambil dokumen terbaru dari Firestore
                final snapshot = await FirebaseFirestore.instance
                    .collection('laporan_renovasi')
                    .orderBy('tanggal', descending: true)
                    .limit(1)
                    .get();
                if (snapshot.docs.isNotEmpty) {
                  final idPesanan = snapshot.docs.first.id;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailScreen(idPesanan: idPesanan),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tidak ada data untuk diexport!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Export'),
            ),
          ],
        ),
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF005792),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedIndex,
          onTap: (index) {
            onIndexChanged(index);

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
                    builder: (context) => MonitoringRenovasiScreen(
                      namaSekolah: 'SMA Negeri 1 Padang',
                      statusProyekAwal: 'Belum Dimulai',
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
                  MaterialPageRoute(builder: (context) => UmpanBalikScreen()),
                );
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatBotScreen(),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: "Chat Bot",
            ),
          ],
        ),
      ],
    );
  }
}
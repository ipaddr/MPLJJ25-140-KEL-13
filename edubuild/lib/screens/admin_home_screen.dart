import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edubuild/screens/order_detail_screen.dart';
import 'package:edubuild/screens/login_screen.dart';
import 'package:edubuild/widgets/custom_bottom_nav.dart';
import 'home_screen.dart';
import 'monitoring_renovasi_screen.dart';
import 'umpan_balik_screen.dart';
import 'chatbot.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005A9C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
        title: const Text('Beranda Admin', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('laporan_renovasi')
            .orderBy('tanggal', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          final laporanList = snapshot.hasData ? snapshot.data!.docs : [];
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: laporanList.isEmpty ? 2 : laporanList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3 / 2.2,
            ),
            itemBuilder: (context, index) {
              if (laporanList.isEmpty) {
                // Tampilkan grid kosong jika belum ada laporan
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/sekolah.png', height: 80),
                      const SizedBox(height: 6),
                      const Text(
                        'Belum ada laporan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        'Status: -',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }
              final laporan = laporanList[index].data() as Map<String, dynamic>;
              final items = laporan['items'] as List<dynamic>? ?? [];
              final sekolah = items.isNotEmpty ? items[0]['title'] ?? '-' : '-';
              final status = laporan['status'] ?? 'Menunggu';
              final idPesanan = laporanList[index].id; // Ambil ID dokumen Firestore
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailScreen(idPesanan: idPesanan),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/sekolah.png', height: 80),
                      const SizedBox(height: 6),
                      Text(
                        sekolah,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Status: $status',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            // Sudah di halaman admin home
          } else if (index == 1) {
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
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UmpanBalikScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChatBotScreen()),
            );
          }
        },
      ),
    );
  }
}
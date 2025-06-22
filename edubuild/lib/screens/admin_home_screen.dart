import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edubuild/screens/detail_pesanan_screen.dart';
import 'package:edubuild/screens/login_screen.dart';
import 'package:edubuild/widgets/admin_bottom_nav.dart';
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
        title: const Text(
          'Beranda Admin',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('renovation_items')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          final sekolahList = snapshot.hasData ? snapshot.data!.docs : [];
          if (sekolahList.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data sekolah',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sekolahList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3 / 2.2,
            ),
            itemBuilder: (context, index) {
              final data = sekolahList[index].data() as Map<String, dynamic>;
              final namaSekolah = data['title'] ?? '-';
              final desc = data['desc'] ?? '';
              final price = data['price'] ?? 0;

              return FutureBuilder<QuerySnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('laporan_renovasi')
                        .where(
                          'items',
                          arrayContains: {
                            'title': namaSekolah,
                            'desc': desc,
                            'price': price,
                          },
                        )
                        .orderBy('tanggal', descending: true)
                        .limit(1)
                        .get(),
                builder: (context, laporanSnapshot) {
                  String status = 'Belum Ada Laporan';
                  String idPesanan = '';
                  if (laporanSnapshot.hasData &&
                      laporanSnapshot.data!.docs.isNotEmpty) {
                    final laporan =
                        laporanSnapshot.data!.docs.first.data()
                            as Map<String, dynamic>;
                    status = laporan['status'] ?? 'Menunggu';
                    idPesanan = laporanSnapshot.data!.docs.first.id;
                  }
                  return GestureDetector(
                    onTap:
                        idPesanan.isNotEmpty
                            ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DetailPesananScreen(
                                        idPesanan: idPesanan,
                                      ),
                                ),
                              );
                            }
                            : null,
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
                            namaSekolah,
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
          );
        },
      ),
      bottomNavigationBar: AdminBottomNav(),
    );
  }
}

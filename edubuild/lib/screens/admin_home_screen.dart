import 'package:flutter/material.dart';
import 'package:edubuild/screens/order_detail_screen.dart';
import 'package:edubuild/widgets/admin_bottom_nav.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  static const List<String> schools = [
    'SMA Negeri 1 Padang',
    'SMA Negeri 1 Padang',
    'SMA Negeri 1 Padang',
    'SMA Negeri 1 Padang',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005A9C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.white),
        title: const Text('Beranda Admin', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: schools.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3 / 2.2,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigasi ke order detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OrderDetailScreen()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/images/sekolah.png', height: 80),

                        const SizedBox(height: 6),
                        Text(
                          schools[index],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Sedang Pemasangan Atap Baru',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ElevatedButton(
              onPressed: () {
                // Fungsi search atau navigasi lain bisa ditambahkan di sini
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Search School'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(),
    );
  }
}

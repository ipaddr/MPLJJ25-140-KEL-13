import 'package:flutter/material.dart';
import '../widgets/mobile_wrapper.dart';
import 'umpan_balik_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'monitoring_renovasi_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget> _buildRenovationItems() {
    final items = [
      {
        'title': 'Atap',
        'subtitle': 'Penggantian atap rusak',
        'price': 'Rp 250.000',
      },
      {
        'title': 'Cat Dinding',
        'subtitle': 'Penggantian cat rusak',
        'price': 'Rp 500.000',
      },
      {
        'title': 'Lantai',
        'subtitle': 'Penggantian keramik',
        'price': 'Rp 800.000',
      },
      {
        'title': 'Loteng',
        'subtitle': 'Penggantian loteng rusak',
        'price': 'Rp 1.450.000',
      },
      {
        'title': 'Pintu/Jendela',
        'subtitle': 'Pintu atau Jendela rusak',
        'price': 'Rp 750.000',
      },
    ];

    return items.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(item['subtitle']!, style: TextStyle(color: Colors.grey)),
              ],
            ),
            Text(item['price']!, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }).toList();
  }

  List<Map<String, dynamic>> feedbackList = [];
  List<Map<String, dynamic>> schools = [];

  void _addSchool(Map<String, dynamic> newSchool) {
    setState(() {
      schools.add(newSchool);
    });
  }

  void _addFeedback(Map<String, dynamic> newFeedback) {
    setState(() {
      feedbackList.add(newFeedback);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: MobileWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'EduBuild',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Building Schools, Building the Future',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                // SEARCH BAR
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search School',
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.filter_alt, color: Colors.black54),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Tombol Pelaporan
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/formInput',
                            ); // Ganti dengan route Anda
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Pelaporan',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),

                    // Tombol Visualisasi
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/monitoring',
                            ); // Ganti dengan route Anda
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Visualisasi',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),

                    // Tombol Feedback
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/feedback',
                            ); // Ganti dengan route Anda
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Feedback',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Penilaian kelengkapan renovasi sekolah',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Daftar Komponen
                      ..._buildRenovationItems(),

                      const SizedBox(height: 16),

                      // Upload button dummy
                      GestureDetector(
                        onTap: () {
                          // Implement upload logic here
                        },
                        child: DottedBorder(
                          color: Colors.white,
                          strokeWidth: 2,
                          dashPattern: [6, 4],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.upload_file,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Total
                      Text(
                        'Total = Rp 2.550.000',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Kirim Laporan Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement submit logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Kirim Laporan'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // NANTI: Tombol Pelaporan/Visualisasi/Feedback
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Column(
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
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });

                // Navigasi sesuai index
                if (index == 0) {
                  // Form Input (Home)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                } else if (index == 1) {
                  // Monitoring Renovasi
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MonitoringRenovasiScreen(
                            namaSekolah: 'SMA Negeri 1 Padang',
                            statusProyekAwal: 'Sedang Berlangsung',
                            riwayatPerbaikan: [
                              'Penggantian Atap',
                              'Cat Dinding',
                              'Pemasangan Keramik',
                            ],
                          ),
                    ),
                  );
                } else if (index == 2) {
                  // Umpan Balik
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => UmpanBalikScreen(
                            feedbackList: [
                              {'nama': 'Perlu pengecatan ulang'},
                              {'nama': 'Kondisi toilet kurang bersih'},
                            ],
                          ),
                    ),
                  );
                }
              },
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
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
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/addSchool');
          if (result != null && result is Map<String, dynamic>) {
            _addSchool(result);
          }
        },
        backgroundColor: const Color(0xFF1E3A8A),
        tooltip: 'Tambah Sekolah',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import 'monitoring_renovasi_screen.dart';
import 'umpan_balik_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Made non-final to allow changes

  // List states
  final List<Map<String, dynamic>> feedbackList = [];
  final List<Map<String, dynamic>> schools = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () {
              // Navigate back to login screen
              Navigator.pushReplacementNamed(context, '/login');
              // Or if you prefer:
              // Navigator.pushNamedAndRemoveUntil(
              //   context,
              //   '/login',
              //   (route) => false,
              // );
            },
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EduBuild',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Building Schools, Building the Future',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Search School',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.filter_list, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Top buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopButton('Pelaporan', Colors.blue.shade800),
                  _buildTopButton('Visualisasi', Colors.blue.shade700),
                  _buildTopButton('Feedback', Colors.blue.shade700),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Renovasi Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Penilaian kelengkapan renovasi sekolah',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._buildRenovasiItems(),
                    const SizedBox(height: 16),

                    // Upload image area
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white70),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white),
                            ),
                            child: const Icon(
                              Icons.file_upload_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Upload Image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Export button and total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Total = Rp 2.550.000',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) {
          setState(() {
            _selectedIndex = index;

            // Handle navigation based on index
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MonitoringRenovasiScreen(
                        namaSekolah: "SMA Negeri 1 Padang",
                        statusProyekAwal: "Belum Selesai",
                        riwayatPerbaikan: const [
                          "Pengecatan Dinding",
                          "Struk Pemesanan",
                        ],
                      ),
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UmpanBalikScreen()),
              );
            }
          });
        },
      ),
    );
  }

  Widget _buildTopButton(String label, Color color) {
    return SizedBox(
      width: 110,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }

  List<Widget> _buildRenovasiItems() {
    final List<Map<String, dynamic>> items = [
      {'title': 'Atap', 'desc': 'Penggantian atap rusak', 'price': 250000},
      {
        'title': 'Cat Dinding',
        'desc': 'Penggantian cat rusak',
        'price': 500000,
      },
      {'title': 'Lantai', 'desc': 'Penggantian keramik', 'price': 800000},
      {'title': 'Loteng', 'desc': 'Penggantian loteng rusak', 'price': 1450000},
      {
        'title': 'Pintu/Jendela',
        'desc': 'Pintu atau Jendela rusak',
        'price': 750000,
      },
    ];

    return items.map((item) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(item['desc'], style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            Text(
              'Rp ${item['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }).toList();
  }
}

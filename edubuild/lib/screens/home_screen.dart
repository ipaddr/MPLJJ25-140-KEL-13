import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'monitoring_renovasi_screen.dart'; // Import halaman Monitoring Renovasi
import 'umpan_balik_screen.dart'; // Import halaman Umpan Balik jika ada
=======
import '../widgets/mobile_wrapper.dart';
import 'umpan_balik_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'monitoring_renovasi_screen.dart';
import 'dart:async';
import '../widgets/custom_bottom_nav.dart';
>>>>>>> a1f4df323fb068d3e295688e1ca09c9bc6a2d037

class HomeScreen extends StatefulWidget {  // Ubah menjadi StatefulWidget untuk menyimpan state
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0; // Index 0 untuk Home

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.menu, color: Colors.blue),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EduBuild', 
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            Text('Building Schools, Building the Future',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
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
                      child: Text('Search School', style: TextStyle(color: Colors.grey)),
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
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                            child: const Icon(Icons.file_upload_outlined, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          const Text('Upload Image', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Export button and total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Export'),
                        ),
                        const Text(
                          'Total = Rp 2.550.000',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Submit report button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Kirim Laporan', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  const Text(
                    'EduBuild',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '© 2025 EduBuild',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    'Platform memantau dan menilai kondisi sekolah di seluruh Indonesia',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hubungi kami: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      Text(
                        'support@edubuild.id',
                        style: TextStyle(fontSize: 12, color: Colors.blue.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Bottom navigation - DIPERBARUI dengan fungsi navigasi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Form Input (Home)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _selectedIndex == 0 ? Colors.blue : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.description, 
                              color: _selectedIndex == 0 ? Colors.white : Colors.grey,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Form Input',
                            style: TextStyle(
                              fontSize: 12,
                              color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                              fontWeight: _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      
                      // Monitoring - TOMBOL YANG DITAMBAHKAN NAVIGASI
                      InkWell(
                        onTap: () {
                          // Navigasi ke halaman MonitoringRenovasiScreen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MonitoringRenovasiScreen(
                                namaSekolah: "SMA Negeri 1 Padang", 
                                statusProyekAwal: "Sudah / Belum Selesai", 
                                riwayatPerbaikan: const [
                                  "Pengecatan Dinding", 
                                  "Struk Pemesanan"
                                ],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _selectedIndex == 1 ? Colors.blue : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.monitor, 
                                color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Monitoring',
                              style: TextStyle(
                                fontSize: 12,
                                color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                                fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Umpan Balik
                      InkWell(
                        onTap: () {
                          // Navigasi ke halaman UmpanBalikScreen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UmpanBalikScreen(
                                feedbackList: [
                                  {'nama': 'Perlu pengecatan ulang'},
                                  {'nama': 'Kondisi toilet kurang bersih'},
                                ],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _selectedIndex == 2 ? Colors.blue : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.thumb_up, 
                                color: _selectedIndex == 2 ? Colors.white : Colors.grey,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Umpan Balik',
                              style: TextStyle(
                                fontSize: 12,
                                color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
                                fontWeight: _selectedIndex == 2 ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  List<Widget> _buildRenovasiItems() {
    final List<Map<String, dynamic>> items = [
      {'title': 'Atap', 'desc': 'Penggantian atap rusak', 'price': 250000},
      {'title': 'Cat Dinding', 'desc': 'Penggantian cat rusak', 'price': 500000},
      {'title': 'Lantai', 'desc': 'Penggantian keramik', 'price': 800000},
      {'title': 'Loteng', 'desc': 'Penggantian loteng rusak', 'price': 1450000},
      {'title': 'Pintu/Jendela', 'desc': 'Pintu atau Jendela rusak', 'price': 750000},
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
                    style: const TextStyle(fontWeight: FontWeight.bold)
                  ),
                  Text(
                    item['desc'], 
                    style: const TextStyle(fontSize: 12)
                  ),
                ]
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
<<<<<<< HEAD
}
=======

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
        child: Center(
          child: SingleChildScrollView(
            child: MobileWrapper(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'EduBuild',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Building Schools, Building the Future',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // SEARCH BAR
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Search School',
                              prefixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
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
                  ),
                  const SizedBox(height: 20),

                  // BUTTONS ROW
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/formInput');
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
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/monitoring');
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
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/feedback');
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
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // BLUE CONTAINER
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Penilaian kelengkapan renovasi sekolah',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ..._buildRenovationItems(),
                        const SizedBox(height: 16),
                        // Upload button
                        GestureDetector(
                          onTap: () {},
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
                        Text(
                          'Total = Rp 2.550.000',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {},
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
                            child: const Text(
                              'Kirim Laporan',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 12),
                  const Text(
                    'EduBuild\n© 2025 EduBuild.\nPlatform untuk memantau dan menilai kondisi sekolah di seluruh Indonesia.\nHubungi Kami : support@edubuild.id',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomNav(
          selectedIndex: _selectedIndex,
          onIndexChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
>>>>>>> a1f4df323fb068d3e295688e1ca09c9bc6a2d037

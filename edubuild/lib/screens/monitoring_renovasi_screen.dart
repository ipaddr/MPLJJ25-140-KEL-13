import 'package:flutter/material.dart';
import '../widgets/mobile_wrapper.dart';
import 'umpan_balik_screen.dart';
import 'home_screen.dart'; 
import 'dart:async';

class MonitoringRenovasiScreen extends StatefulWidget {
  final String namaSekolah;
  final String statusProyekAwal;
  final List<String> riwayatPerbaikan;

  const MonitoringRenovasiScreen({
    super.key,
    required this.namaSekolah,
    required this.statusProyekAwal,
    required this.riwayatPerbaikan,
  });

  @override
  State<MonitoringRenovasiScreen> createState() =>
      _MonitoringRenovasiScreenState();
}

class _MonitoringRenovasiScreenState extends State<MonitoringRenovasiScreen> {
  int _selectedIndex = 1; // Set ke 1 karena ini adalah tab Monitoring
  late String statusProyek;

  @override
  void initState() {
    super.initState();
    statusProyek = widget.statusProyekAwal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Renovasi'),
        backgroundColor: const Color(0xFF1A5276),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      backgroundColor: const Color(0xFF1A5276),
      body: SingleChildScrollView(
        child: MobileWrapper(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Status Proyek',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: statusProyek,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: const [
                        DropdownMenuItem(
                          value: 'Belum Dimulai',
                          child: Text('Belum Dimulai'),
                        ),
                        DropdownMenuItem(
                          value: 'Sedang Berlangsung',
                          child: Text('Sedang Berlangsung'),
                        ),
                        DropdownMenuItem(
                          value: 'Sudah Selesai',
                          child: Text('Sudah Selesai'),
                        ),
                        DropdownMenuItem(
                          value: 'Sudah / Belum Selesai',
                          child: Text('Sudah / Belum Selesai'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            statusProyek = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // School Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFAED6F1),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          widget.namaSekolah,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A5276),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/sekolah.png',
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 120,
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(Icons.home_work, size: 48),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.namaSekolah,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Pemasangan Atap Baru',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Riwayat Perbaikan
                const Text(
                  'Riwayat Perbaikan',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                
                // Display Riwayat Perbaikan as buttons instead of cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.riwayatPerbaikan.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: Text(
                          widget.riwayatPerbaikan[index],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'EduBuild',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '© 2025 EduBuild',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'Platform untuk memantau dan menilai kondisi sekolah di',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'seluruh Indonesia',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'Hubungi kami: support@edubuild.id',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Custom Bottom Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.list_alt, 
                            color: _selectedIndex == 0 ? Colors.blue[700] : Colors.grey,
                          ),
                          Text(
                            'Form Input',
                            style: TextStyle(
                              fontSize: 10,
                              color: _selectedIndex == 0 ? Colors.blue[700] : Colors.grey[600],
                              fontWeight: _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Already on this page
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.monitor,
                            color: _selectedIndex == 1 ? Colors.blue[700] : Colors.grey,
                          ),
                          Text(
                            'Monitoring',
                            style: TextStyle(
                              fontSize: 10,
                              color: _selectedIndex == 1 ? Colors.blue[700] : Colors.grey[600],
                              fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
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
                        children: [
                          Icon(
                            Icons.assignment,
                            color: _selectedIndex == 2 ? Colors.blue[700] : Colors.grey,
                          ),
                          Text(
                            'Urutan Balik',
                            style: TextStyle(
                              fontSize: 10,
                              color: _selectedIndex == 2 ? Colors.blue[700] : Colors.grey[600],
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
    );
  }
}
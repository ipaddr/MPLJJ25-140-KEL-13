import 'package:flutter/material.dart';
import '../widgets/mobile_wrapper.dart';
import 'umpan_balik_screen.dart';
import 'home_screen.dart'; 
import 'monitoring_renovasi_screen.dart';
import 'dart:async';// Pastikan nama file sesuai


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
  int _selectedIndex = 0;
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
        backgroundColor: const Color(0xFF005792),
      ),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: statusProyek,
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
                Center(
                  child: Column(
                    children: [
                      Text(
                        widget.namaSekolah,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/sekolah.png',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.namaSekolah}\nPemasangan Atap Baru',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Riwayat Perbaikan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.riwayatPerbaikan.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(widget.riwayatPerbaikan[index]),
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
    );
  }
}

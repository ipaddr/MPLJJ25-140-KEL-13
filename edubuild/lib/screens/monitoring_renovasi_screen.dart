import 'package:flutter/material.dart';
import '../widgets/mobile_wrapper.dart';
import '../widgets/custom_bottom_nav.dart';
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
  final int _selectedIndex = 1; // Set ke 1 karena ini adalah tab Monitoring
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
        title: const Text('Monitoring Renovasi', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: const Color(0xFF005792),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: MobileWrapper(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Status Proyek',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
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
                        isExpanded: true,
                        value: statusProyek,
                        alignment: Alignment.center,
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
                  Text(
                    widget.namaSekolah,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // ...existing code...
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 280, // Fixed width for consistency
                      height: 180, // Fixed height for consistency
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/sekolah.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ...existing code...
                  const SizedBox(height: 8),
                  Text(
                    '${widget.namaSekolah}\nPemasangan Atap Baru',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Riwayat Perbaikan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
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
                          title: Text(
                            widget.riwayatPerbaikan[index],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UmpanBalikScreen()),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/school_card.dart';
import 'map_screen.dart';
import 'monitoring_renovasi_screen.dart';
import 'umpan_balik_screen.dart';
import 'feedback_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> schools = [
    {
      'name': 'SMA Negeri 1 Padang',
      'location': 'Padang, Sumatera Barat',
      'status': 'Sedang Pemasangan Atap Baru',
      'riwayat': [
        'Pengecatan Dinding',
        'Penggantian Genteng',
        'Perbaikan Lantai',
      ],
    },
    {
      'name': 'SMA Negeri 10 Padang',
      'location': 'Padang, Sumatera Barat',
      'status': 'Baik',
      'riwayat': [
        'Perbaikan Jendela',
      ],
    },
  ];

  List<Map<String, dynamic>> feedbackList = [];

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
      appBar: AppBar(
        title: const Text(
          'EduBuild',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Sekolah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                },
                icon: const Icon(Icons.map),
                label: const Text("Lihat Peta Sekolah"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UmpanBalikScreen(feedbackList: feedbackList),
                    ),
                  );
                },
                icon: const Icon(Icons.feedback),
                label: const Text("Umpan Balik Pengguna"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[800],
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FeedbackFormScreen(onSubmit: _addFeedback),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("Tulis Umpan Balik"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: schools.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada data sekolah.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : ListView.separated(
                        itemCount: schools.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final school = schools[index];
                          return SchoolCard(
                            name: school['name'],
                            location: school['location'],
                            status: school['status'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MonitoringRenovasiScreen(
                                    namaSekolah: school['name'],
                                    statusProyek: school['status'],
                                    riwayatPerbaikan:
                                        List<String>.from(school['riwayat']),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, '/addSchool'); // opsional
          if (result != null && result is Map<String, dynamic>) {
            _addSchool(result);
          }
        },
        backgroundColor: const Color(0xFF1E3A8A),
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Tambah Sekolah',
      ),
    );
  }
}

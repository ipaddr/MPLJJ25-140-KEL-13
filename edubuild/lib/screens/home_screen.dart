import 'package:flutter/material.dart';
import '../widgets/school_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> schools = [
    {
      'name': 'SMA Negeri 1 Padang',
      'location': 'Padang, Sumatera Barat',
      'status': 'Perlu Renovasi',
    },
    {
      'name': 'SMA Negeri 10 Padang',
      'location': 'Padang, Sumatera Barat',
      'status': 'Baik',
    },
  ];

  void _addSchool(Map<String, String> newSchool) {
    setState(() {
      schools.add(newSchool);
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
        backgroundColor: const Color(0xFF1E3A8A), // Sesuai tone biru Figma
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
                            name: school['name']!,
                            location: school['location']!,
                            status: school['status']!,
                            onTap: () =>
                                Navigator.pushNamed(context, '/dashboard'),
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
          final result = await Navigator.pushNamed(context, '/addSchool');
          if (result != null && result is Map<String, String>) {
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

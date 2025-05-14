import 'package:flutter/material.dart';

class MonitoringRenovasiScreen extends StatelessWidget {
  final String namaSekolah;
  final String statusProyek;
  final List<String> riwayatPerbaikan;

  const MonitoringRenovasiScreen({
    super.key,
    required this.namaSekolah,
    required this.statusProyek,
    required this.riwayatPerbaikan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Renovasi'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Proyek',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.school, color: Colors.blue),
                title: Text(namaSekolah),
                subtitle: Text(statusProyek),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Riwayat Perbaikan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Perbaikan ada di sini: gunakan Expanded hanya saat layout mengizinkan
            Expanded(
              child: ListView.builder(
                itemCount: riwayatPerbaikan.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(riwayatPerbaikan[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

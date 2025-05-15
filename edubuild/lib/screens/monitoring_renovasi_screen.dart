import 'package:flutter/material.dart';
import '../widgets/mobile_wrapper.dart';

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
      body: SingleChildScrollView(
        child: MobileWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

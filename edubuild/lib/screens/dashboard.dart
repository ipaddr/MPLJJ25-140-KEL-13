import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/admin_bottom_nav.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'urgent':
        return Colors.orange;
      case 'perlu renovasi':
        return Colors.red;
      case 'baik':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF005A9C),
        title: const Text('Dashboard Admin'),
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
      ),
      bottomNavigationBar: const AdminBottomNav(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildStatCard('Total Sekolah', '1.245'),
                  _buildStatCard('Laporan Baru', '32'),
                  _buildStatCard('proyek selesai', '5'),
                  _buildStatCard('Target Bulan Selesai', '8'),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Lihat buat penilaian sekolah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // Ambil data sekolah dari Firestore
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('sekolah').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('Belum ada data sekolah.');
                  }
                  final docs = snapshot.data!.docs;
                  return Column(
                    children: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final name = data['name'] ?? '-';
                      final address = data['address'] ?? '-';
                      final status = data['status'] ?? '-';
                      final statusColor = _getStatusColor(status);
                      return _buildSchoolItem(name, address, status, statusColor);
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                'EduBuild\n© 2025 EduBuild.\nPlatform untuk memantau dan menilai kondisi sekolah di seluruh Indonesia.\nHubungi Kami : support@edubuild.id',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005A9C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolItem(
    String name,
    String address,
    String status,
    Color statusColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(status, style: TextStyle(color: statusColor)),
            ],
          ),
          const SizedBox(height: 4),
          Text(address, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

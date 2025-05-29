import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/admin_bottom_nav.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005A9C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF005A9C),
        title: const Text('Beranda Umpan Balik'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedback')
            .orderBy('tanggal', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada umpan balik.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _buildFeedbackCard(
                  namaSekolah: data['namaSekolah'] ?? '-',
                  tanggal: data['tanggal'] != null
                      ? _formatTanggal(data['tanggal'])
                      : '-',
                  rating: data['rating'] ?? 0,
                  komentar: data['komentar'] ?? '',
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedbackCard({
    required String namaSekolah,
    required String tanggal,
    required int rating,
    required String komentar,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF005A9C),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            namaSekolah,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            tanggal,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                color: index < rating ? Colors.yellow : Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            komentar,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  static String _formatTanggal(dynamic tanggal) {
    if (tanggal is Timestamp) {
      final dt = tanggal.toDate();
      return '${dt.day} ${_bulan(dt.month)} ${dt.year}';
    }
    return tanggal.toString();
  }

  static String _bulan(int bulan) {
    const namaBulan = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return namaBulan[bulan];
  }
}

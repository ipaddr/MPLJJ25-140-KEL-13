import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPesananScreen extends StatelessWidget {
  final String idPesanan;

  const DetailPesananScreen({
    super.key,
    required this.idPesanan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan Renovasi'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('laporan_renovasi') // GANTI dari 'pesanan' ke 'laporan_renovasi'
            .doc(idPesanan)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Data pesanan tidak ditemukan.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          // Ambil nama sekolah dari item pertama jika ada
          final items = (data['items'] as List<dynamic>? ?? [])
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
          final namaSekolah = items.isNotEmpty ? (items.first['title'] ?? '-') : '-';
          final status = data['status'] ?? '-';

          int total = 0;
          for (var item in items) {
            final int price = (item['price'] ?? 0) is int
                ? (item['price'] ?? 0)
                : int.tryParse(item['price'].toString()) ?? 0;
            total += price;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  namaSekolah,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('ID: $idPesanan'),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Chip(
                    label: Text(
                      status == 'Disetujui' ? 'Disetujui' : 'Belum Disetujui',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: status == 'Disetujui' ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Rincian Pesanan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...items.map((item) {
                  final int price = (item['price'] ?? 0) is int
                      ? (item['price'] ?? 0)
                      : int.tryParse(item['price'].toString()) ?? 0;
                  return Card(
                    color: Colors.purple[50],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(item['desc'] ?? ''),
                              ],
                            ),
                          ),
                          Text(
                            'Rp $price',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total: Rp $total',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

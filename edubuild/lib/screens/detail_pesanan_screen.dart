import 'package:flutter/material.dart';

class DetailPesananScreen extends StatelessWidget {
  final String namaSekolah;
  final String idPesanan;
  final String status;
  final List<Map<String, dynamic>> rincian;

  const DetailPesananScreen({
    super.key,
    required this.namaSekolah,
    required this.idPesanan,
    required this.status,
    required this.rincian,
  });

  @override
  Widget build(BuildContext context) {
    int total = 0;
    for (var item in rincian) {
      final int price = (item['price'] ?? 0) is int
          ? (item['price'] ?? 0)
          : int.tryParse(item['price'].toString()) ?? 0;
      total += price;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan Renovasi'),
      ),
      body: Padding(
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
            ...rincian.map((item) {
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
      ),
    );
  }
}
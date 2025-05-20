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
      total += item['harga'] as int;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan Renovasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(namaSekolah, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('ID: $idPesanan'),
            const SizedBox(height: 4),
            Chip(
              label: Text(status),
              backgroundColor: status == 'Disetujui' ? Colors.green : Colors.grey,
              labelStyle: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text('Rincian Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...rincian.map((item) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['judul'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(item['deskripsi']),
                        const SizedBox(height: 4),
                        Text('Rp ${item['harga']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Total: Rp $total', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

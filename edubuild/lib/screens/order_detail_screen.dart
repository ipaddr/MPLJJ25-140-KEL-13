import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edubuild/screens/admin_home_screen.dart'; // untuk bottom navbar

class OrderDetailScreen extends StatelessWidget {
  final String idPesanan;
  const OrderDetailScreen({Key? key, required this.idPesanan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('laporan_renovasi')
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
            final namaSekolah = data['namaSekolah'] ?? '-';
            final status = data['status'] ?? '-';
            final items = (data['items'] as List<dynamic>? ?? [])
                .map((e) => Map<String, dynamic>.from(e))
                .toList();

            final total = items.fold<int>(
              0,
              (sum, item) {
                final price = item['price'];
                if (price is int) return sum + price;
                if (price is double) return sum + price.toInt();
                if (price is String) return sum + (int.tryParse(price) ?? 0);
                return sum;
              },
            );

            return Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.menu),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "EduBuild",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Building Schools, Building the Future",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Info Pesanan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              namaSekolah,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text("Detail Pesanan Renovasi"),
                            const SizedBox(height: 4),
                            Text(
                              "ID: $idPesanan",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        label: Text(
                          status == 'Disetujui' ? 'Disetujui' : 'Belum Disetujui',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: status == 'Disetujui' ? Colors.green : Colors.red,
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // List item dan total harga
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text(
                        "Rincian Pesanan",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ...items.map(
                        (item) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(item['title'] ?? ''),
                            subtitle: Text(item['desc'] ?? ''),
                            trailing: Text(
                              "Rp ${item['price']}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Total: Rp $total",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      // bottomNavigationBar: AdminBottomNav(), // aktifkan jika ingin bottom nav admin
    );
  }
}
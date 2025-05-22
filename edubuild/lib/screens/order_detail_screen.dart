import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  static const List<Map<String, dynamic>> items = [
    {
      'title': 'Atap',
      'desc': 'Penggantian atap rusak\nMaterial: Genteng metal\nLuas area: 12m2',
      'price': 250000,
    },
    {
      'title': 'Cat Dinding',
      'desc': 'Penggantian ulang dinding rusak\nMaterial: Cat interior\nLuas area: 25m2',
      'price': 500000,
    },
    {
      'title': 'Lantai',
      'desc': 'Penggantian lantai keramik\nMaterial: Keramik 30x30\nLuas area: 12m2',
      'price': 800000,
    },
    {
      'title': 'Loteng',
      'desc': 'Penggantian loteng rusak\nMaterial: Loteng berbahan kayu\nLuas area: 54m2',
      'price': 250000,
    },
  ];

  Widget buildAdminBottomNavBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: 1,
      onTap: (index) {
        // Handle navigation
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = items.fold<int>(0, (sum, item) => sum + (item['price'] as int));

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      children: const [
                        Text(
                          "SMA N 3 PAYAKUMBUH",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Detail Pesanan Renovasi"),
                        SizedBox(height: 4),
                        Text(
                          "ID: PRN-2025051701",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: const Text("Disetujui"),
                    backgroundColor: Colors.green,
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
                        title: Text(item['title']),
                        subtitle: Text(item['desc']),
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
        ),
      ),
      bottomNavigationBar: buildAdminBottomNavBar(),
    );
  }
}
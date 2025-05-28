import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_bottom_nav.dart';
import 'monitoring_renovasi_screen.dart';
import 'umpan_balik_screen.dart';
import 'detail_pesanan_screen.dart';
import 'chatbot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isLoading = true;
  String searchQuery = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> renovationItems = [
    {
      'title': 'Atap',
      'desc': 'Penggantian atap rusak',
      'price': 250000,
    },
    {
      'title': 'Cat Dinding',
      'desc': 'Penggantian cat rusak',
      'price': 500000,
    },
    {
      'title': 'Lantai',
      'desc': 'Penggantian keramik',
      'price': 800000,
    },
    {
      'title': 'Loteng',
      'desc': 'Penggantian loteng rusak',
      'price': 1450000,
    },
    {
      'title': 'Pintu/Jendela',
      'desc': 'Pintu atau Jendela rusak',
      'price': 750000,
    },
  ];

  @override
  void initState() {
    super.initState();
    loadRenovationItems();
  }

  Future<void> loadRenovationItems() async {
    setState(() => isLoading = true);
    try {
      final QuerySnapshot snapshot = await _firestore.collection('renovation_items').get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          renovationItems = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'title': data['title'] ?? '',
              'desc': data['desc'] ?? '',
              'price': data['price'] ?? 0,
            };
          }).toList();
        });
      }
    } catch (e) {
      // ignore error, use dummy data
    } finally {
      setState(() => isLoading = false);
    }
  }

  int calculateTotal() {
    return renovationItems.fold(0, (sum, item) {
      final int price = (item['price'] ?? 0) is int
          ? (item['price'] ?? 0)
          : int.tryParse(item['price'].toString()) ?? 0;
      return sum + price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.menu, color: Colors.blue, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "EduBuild",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "Building Schools, Building the Future",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Search School',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) => setState(() => searchQuery = value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.grey),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          // Top buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTopButton('Pelaporan', Colors.blue.shade800),
                _buildTopButton('Visualisasi', Colors.blue.shade700),
                _buildTopButton('Feedback', Colors.blue.shade700),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Renovasi Section
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade100,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Penilaian kelengkapan renovasi sekolah',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      else
                        ...renovationItems
                            .where((item) => item['title']
                                .toString()
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                            .map((item) {
                              final int price = (item['price'] ?? 0) is int
                                  ? (item['price'] ?? 0)
                                  : int.tryParse(item['price'].toString()) ?? 0;
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title'] ?? '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(item['desc'] ?? '',
                                              style: const TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Total = Rp ${calculateTotal().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue[800],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Kirim Laporan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Footer
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'EduBuild',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '© 2025 EduBuild.\nPlatform untuk memantau dan menilai kondisi sekolah di seluruh Indonesia.\nHubungi Kami : support@edubuild.id',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MonitoringRenovasiScreen(
                    namaSekolah: "SMA Negeri 1 Padang",
                    statusProyekAwal: "Belum Dimulai", // <-- UBAH INI!
                    riwayatPerbaikan: [
                      "Pengecatan Dinding",
                      "Struk Pemesanan",
                    ],
                  ),
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UmpanBalikScreen()),
              );
            }
          });
        },
      ),
    );
  }

  Widget _buildTopButton(String label, Color color) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          if (label == 'Pelaporan') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPesananScreen(
                  namaSekolah: "SMA N 3 PAYAKUMBUH",
                  idPesanan: "PRN-2025051701",
                  status: "Disetujui",
                  rincian: [
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
                  ],
                ),
              ),
            );
          } else if (label == 'Visualisasi') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MonitoringRenovasiScreen(
                  namaSekolah: "SMA Negeri 1 Padang",
                  statusProyekAwal: "Belum Dimulai", // <-- UBAH INI!
                  riwayatPerbaikan: [
                    "Pengecatan Dinding",
                    "Struk Pemesanan",
                  ],
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: color, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
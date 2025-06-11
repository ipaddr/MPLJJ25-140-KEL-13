import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
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
  List<Map<String, dynamic>> renovationItems = [];

  @override
  void initState() {
    super.initState();
    loadRenovationItems();
  }

  Future<void> loadRenovationItems() async {
    setState(() => isLoading = true);
    try {
      final QuerySnapshot snapshot = await _firestore.collection('renovation_items').get();
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
    } catch (e) {
      renovationItems = [];
    } finally {
      setState(() => isLoading = false);
    }
  }

  int calculateTotal() {
    return renovationItems
        .where((item) => item['title']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .fold(0, (sum, item) {
      final int price = (item['price'] ?? 0) is int
          ? (item['price'] ?? 0)
          : int.tryParse(item['price'].toString()) ?? 0;
      return sum + price;
    });
  }

  Future<void> _showAddSchoolDialog() async {
    final _titleController = TextEditingController();
    final _descController = TextEditingController();
    final _priceController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Sekolah'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nama Sekolah'),
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Deskripsi Renovasi'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Biaya (Rp)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isEmpty ||
                  _descController.text.isEmpty ||
                  _priceController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua field harus diisi!')),
                );
                return;
              }
              try {
                final newItem = {
                  'title': _titleController.text,
                  'desc': _descController.text,
                  'price': int.tryParse(_priceController.text) ?? 0,
                };
                await _firestore.collection('renovation_items').add(newItem);
                setState(() {
                  searchQuery = '';
                });
                await loadRenovationItems();
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menambah data: $e')),
                );
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  Future<void> _kirimLaporan() async {
    final filteredItems = renovationItems
        .where((item) => item['title']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    if (filteredItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada data sekolah yang akan dikirim!')),
      );
      return;
    }

    try {
      final docRef = await _firestore.collection('laporan_renovasi').add({
        'items': filteredItems,
        'tanggal': DateTime.now(),
        'status': 'Menunggu',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil dikirim!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPesananScreen(idPesanan: docRef.id),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim laporan!')),
      );
    }
  }

  Widget _buildStatBox(String value, String label, List<Color> gradientColors) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
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
          // Statistik Bar (REAL-TIME)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('laporan_renovasi').snapshots(),
              builder: (context, snapshot) {
                int totalProyek = 0;
                int totalAnggaran = 0;
                int totalProgress = 0;
                if (snapshot.hasData) {
                  final docs = snapshot.data!.docs;
                  totalProyek = docs.length;
                  int progressSum = 0;
                  int progressCount = 0;
                  for (var doc in docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final items = data['items'] as List<dynamic>? ?? [];
                    for (var item in items) {
                      final price = item['price'] ?? 0;
                      totalAnggaran += (price is int)
                          ? price
                          : int.tryParse(price.toString()) ?? 0;
                    }
                    if (data.containsKey('progress')) {
                      final prog = data['progress'];
                      if (prog is int) {
                        progressSum += prog;
                        progressCount++;
                      } else if (prog is double) {
                        progressSum += prog.round();
                        progressCount++;
                      }
                    }
                  }
                  totalProgress = progressCount > 0
                      ? (progressSum ~/ progressCount)
                      : 75;
                }
                return Row(
                  children: [
                    _buildStatBox(
                      '$totalProyek',
                      'Total Proyek',
                      [Color(0xFF36D1C4), Color(0xFF1E69DE)],
                    ),
                    _buildStatBox(
                      'Rp ${totalAnggaran >= 1000000 ? (totalAnggaran / 1000000).toStringAsFixed(1) + "JT" : totalAnggaran.toString()}',
                      'Total Anggaran',
                      [Color(0xFFFFB347), Color(0xFFFF5E62)],
                    ),
                    _buildStatBox(
                      '$totalProgress%',
                      'Progress',
                      [Color(0xFFB06AB3), Color(0xFF4568DC)],
                    ),
                  ],
                );
              },
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
                            onSubmitted: (value) => setState(() => searchQuery = value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Top buttons + Tambah Sekolah
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTopButton('Pelaporan', Colors.blue.shade800),
                _buildTopButton('Visualisasi', Colors.blue.shade700),
                _buildTopButton('Feedback', Colors.blue.shade700),
                ElevatedButton.icon(
                  onPressed: _showAddSchoolDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Sekolah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                  ),
                ),
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
                          onPressed: _kirimLaporan,
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
          });
          if (index == 0) {
            // Sudah di Home, tidak perlu navigasi
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MonitoringRenovasiScreen(
                  namaSekolah: "SMA Negeri 1 Padang",
                  statusProyekAwal: "Belum Dimulai",
                  riwayatPerbaikan: [
                    "Pengecatan Dinding",
                    "Struk Pemesanan",
                  ],
                ),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UmpanBalikScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChatBotScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildTopButton(String label, Color color) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: () async {
          if (label == 'Pelaporan') {
            final snapshot = await _firestore
                .collection('laporan_renovasi')
                .orderBy('tanggal', descending: true)
                .limit(1)
                .get();
            if (snapshot.docs.isNotEmpty) {
              final doc = snapshot.docs.first;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPesananScreen(idPesanan: doc.id),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Belum ada laporan renovasi!')),
              );
            }
          } else if (label == 'Visualisasi') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MonitoringRenovasiScreen(
                  namaSekolah: "SMA Negeri 1 Padang",
                  statusProyekAwal: "Belum Dimulai",
                  riwayatPerbaikan: [
                    "Pengecatan Dinding",
                    "Struk Pemesanan",
                  ],
                ),
              ),
            );
          } else if (label == 'Feedback') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UmpanBalikScreen(),
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
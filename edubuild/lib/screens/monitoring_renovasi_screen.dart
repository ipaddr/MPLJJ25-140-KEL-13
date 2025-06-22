import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/mobile_wrapper.dart';
import '../widgets/custom_bottom_nav.dart';
import 'umpan_balik_screen.dart';
import 'home_screen.dart';
import 'chatbot.dart';

class MonitoringRenovasiScreen extends StatefulWidget {
  final String namaSekolah;

  const MonitoringRenovasiScreen({super.key, required this.namaSekolah});

  @override
  State<MonitoringRenovasiScreen> createState() =>
      _MonitoringRenovasiScreenState();
}

class _MonitoringRenovasiScreenState extends State<MonitoringRenovasiScreen> {
  int _selectedIndex = 1;
  String statusProyekAwal = 'Belum Dimulai';
  List<String> riwayatPerbaikan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
  }

  Future<void> _loadDataFromFirestore() async {
    setState(() => isLoading = true);
    final snapshot =
        await FirebaseFirestore.instance
            .collection('monitoring_renovasi')
            .doc(widget.namaSekolah.replaceAll(' ', '_'))
            .get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      setState(() {
        statusProyekAwal = data['statusProyek'] ?? 'Belum Dimulai';
        riwayatPerbaikan = List<String>.from(data['riwayatPerbaikan'] ?? []);
      });
    }
    setState(() => isLoading = false);
  }

  Future<void> _updateStatusProyek(String newStatus) async {
    setState(() => statusProyekAwal = newStatus);
    final ref = FirebaseFirestore.instance
        .collection('monitoring_renovasi')
        .doc(widget.namaSekolah.replaceAll(' ', '_'));
    await ref.set({
      'namaSekolah': widget.namaSekolah,
      'statusProyek': newStatus,
      'riwayatPerbaikan': riwayatPerbaikan,
    }, SetOptions(merge: true));
  }

  Future<void> _addRiwayatPerbaikan(String perbaikan) async {
    setState(() => riwayatPerbaikan.add(perbaikan));
    final ref = FirebaseFirestore.instance
        .collection('monitoring_renovasi')
        .doc(widget.namaSekolah.replaceAll(' ', '_'));
    await ref.set({
      'namaSekolah': widget.namaSekolah,
      'statusProyek': statusProyekAwal,
      'riwayatPerbaikan': riwayatPerbaikan,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Renovasi', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: const Color(0xFF005792),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: MobileWrapper(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'Status Proyek',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: statusProyekAwal,
                                alignment: Alignment.center,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Belum Dimulai',
                                    child: Text('Belum Dimulai'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Sedang Berlangsung',
                                    child: Text('Sedang Berlangsung'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Sudah Selesai',
                                    child: Text('Sudah Selesai'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    _updateStatusProyek(value);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.namaSekolah,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Container(
                              width: 280,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/sekolah.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.namaSekolah}\nPemasangan Atap Baru',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Riwayat Perbaikan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
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
                                  title: Text(
                                    riwayatPerbaikan[index],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          // Tambah riwayat perbaikan
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Tambah riwayat perbaikan',
                                    border: OutlineInputBorder(),
                                  ),
                                  onSubmitted: (value) {
                                    if (value.trim().isNotEmpty) {
                                      _addRiwayatPerbaikan(value.trim());
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  // Optional: bisa tambahkan dialog input jika ingin
                                },
                                child: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF005792),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () async {
                                final ref = FirebaseFirestore.instance
                                    .collection('monitoring_renovasi')
                                    .doc(
                                      widget.namaSekolah.replaceAll(' ', '_'),
                                    );
                                await ref.set({
                                  'namaSekolah': widget.namaSekolah,
                                  'statusProyek': statusProyekAwal,
                                  'riwayatPerbaikan': riwayatPerbaikan,
                                }, SetOptions(merge: true));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Data renovasi dikirim!'),
                                  ),
                                );
                              },
                              child: const Text(
                                'Kirim',
                                style: TextStyle(
                                  color: Colors.white,
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
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            // Sudah di Monitoring, tidak perlu navigasi
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
}

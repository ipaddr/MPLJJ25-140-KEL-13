import 'package:flutter/material.dart';
import '../widgets/mobile_wrapper.dart';
import 'home_screen.dart';
import 'monitoring_renovasi_screen.dart';

class UmpanBalikScreen extends StatefulWidget {
  final List<Map<String, dynamic>> feedbackList;

  const UmpanBalikScreen({
    super.key,
    required this.feedbackList,
  });

  @override
  State<UmpanBalikScreen> createState() => _UmpanBalikScreenState();
}

class _UmpanBalikScreenState extends State<UmpanBalikScreen> {
  int _selectedIndex = 2; // Set ke 2 karena ini adalah tab Umpan Balik
  final TextEditingController _feedbackController = TextEditingController();
  List<Map<String, dynamic>> _feedbackList = [];

  @override
  void initState() {
    super.initState();
    _feedbackList = List.from(widget.feedbackList);
  }

  void _addFeedback() {
    if (_feedbackController.text.trim().isNotEmpty) {
      setState(() {
        _feedbackList.add({'nama': _feedbackController.text.trim()});
        _feedbackController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Umpan Balik'),
        backgroundColor: const Color(0xFF005792),
      ),
      body: SingleChildScrollView(
        child: MobileWrapper(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Umpan Balik',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _feedbackList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.feedback),
                        title: Text(_feedbackList[index]['nama']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _feedbackList.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Tambah Umpan Balik Baru',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _feedbackController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan umpan balik',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _addFeedback,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Kirim Umpan Balik',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "© EduBuild 2025",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                if (_selectedIndex == index) {
                  // Pengguna mengklik tab yang sudah aktif
                  return;
                }
                
                setState(() {
                  _selectedIndex = index;
                });

                // Navigasi sesuai index
                if (index == 0) {
                  // Form Input (Home)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                } else if (index == 1) {
                  // Monitoring Renovasi
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MonitoringRenovasiScreen(
                        namaSekolah: 'SMA Negeri 1 Padang',
                        statusProyekAwal: 'Sedang Berlangsung',
                        riwayatPerbaikan: [
                          'Penggantian Atap',
                          'Cat Dinding',
                          'Pemasangan Keramik',
                        ],
                      ),
                    ),
                  );
                } else if (index == 2) {
                  // Umpan Balik (sudah berada di halaman ini)
                  // Tidak perlu navigasi
                }
              },
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.note_alt),
                  label: "Form Input",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assessment),
                  label: "Monitoring",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.feedback),
                  label: "Umpan Balik",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
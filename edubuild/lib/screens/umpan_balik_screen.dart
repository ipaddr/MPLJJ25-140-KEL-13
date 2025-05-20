import 'package:flutter/material.dart';
import '../widgets/mobile_wrapper.dart';
<<<<<<< HEAD
import 'home_screen.dart';
import 'monitoring_renovasi_screen.dart';

class UmpanBalikScreen extends StatefulWidget {
  final List<Map<String, dynamic>> feedbackList;

  const UmpanBalikScreen({
    super.key,
    required this.feedbackList,
  });
=======
import '../widgets/custom_bottom_nav.dart';

class UmpanBalikScreen extends StatefulWidget {
  const UmpanBalikScreen({super.key});
>>>>>>> a1f4df323fb068d3e295688e1ca09c9bc6a2d037

  @override
  State<UmpanBalikScreen> createState() => _UmpanBalikScreenState();
}

class _UmpanBalikScreenState extends State<UmpanBalikScreen> {
<<<<<<< HEAD
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
=======
  int _selectedIndex = 2;
  int rating = 0;
  DateTime? selectedDate;
  final TextEditingController commentController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
>>>>>>> a1f4df323fb068d3e295688e1ca09c9bc6a2d037
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF01497C),
      appBar: AppBar(
<<<<<<< HEAD
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
=======
        backgroundColor: Colors.white,
        title: const Text(
          'Umpan Balik',
          style: TextStyle(color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
>>>>>>> a1f4df323fb068d3e295688e1ca09c9bc6a2d037
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Beri Penilaian Renovasi',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'SMA Negeri 1 Padang\nJl. Belanti Raya, Lolong Belanti',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: index < rating ? Colors.orange : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  const Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate == null
                                ? '--Pilih Tanggal--'
                                : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Komentar Anda', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: commentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Tulis Komentar Anda.....',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF01497C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        // TODO: Tambahkan logika pengiriman umpan balik
                      },
                      child: const Text('Kirim'),
                    ),
                  )
                ],
              ),
            ),
<<<<<<< HEAD
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
=======
            const SizedBox(height: 24),
            const Divider(color: Colors.white70),
            const SizedBox(height: 12),
            const Text(
              'EduBuild\n© 2025 EduBuild.\nPlatform untuk memantau dan menilai kondisi sekolah di seluruh Indonesia.\nHubungi Kami : support@edubuild.id',
              style: TextStyle(color: Colors.white70, fontSize: 12),
>>>>>>> a1f4df323fb068d3e295688e1ca09c9bc6a2d037
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomNav(
          selectedIndex: _selectedIndex,
          onIndexChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
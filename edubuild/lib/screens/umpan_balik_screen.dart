import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/mobile_wrapper.dart';
import '../widgets/custom_bottom_nav.dart';
import 'home_screen.dart';
import 'monitoring_renovasi_screen.dart';
import 'chatbot.dart';

class UmpanBalikScreen extends StatefulWidget {
  const UmpanBalikScreen({super.key});

  @override
  State<UmpanBalikScreen> createState() => _UmpanBalikScreenState();
}

class _UmpanBalikScreenState extends State<UmpanBalikScreen> {
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
      });
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (rating > 0 &&
        selectedDate != null &&
        commentController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('feedback').add({
          'namaSekolah': 'SMA N X XXXXX',
          'tanggal': Timestamp.fromDate(selectedDate!),
          'rating': rating,
          'komentar': commentController.text,
          'createdAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Umpan balik berhasil dikirim')),
        );
        setState(() {
          rating = 0;
          selectedDate = null;
          commentController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim umpan balik: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data umpan balik!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF01497C),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Umpan Balik', style: TextStyle(color: Colors.black)),
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Beri Penilaian Renovasi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'SMA N X XXXXX',
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
                  const Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  const Text(
                    'Tanggal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
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
                  const Text(
                    'Komentar Anda',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: commentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Tulis Komentar Anda.....',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF01497C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _submitFeedback,
                      child: const Text('Kirim'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white70),
            const SizedBox(height: 12),
            const Text(
              'EduBuild\n© 2025 EduBuild.\nPlatform untuk memantau dan menilai kondisi sekolah di seluruh Indonesia.\nHubungi Kami : support@edubuild.id',
              style: TextStyle(color: Colors.white70, fontSize: 12),
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
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MonitoringRenovasiScreen(
                        namaSekolah: 'SMA Negeri 1 Padang',
                        statusProyekAwal: 'Belum Dimulai',
                        riwayatPerbaikan: const [
                          'Penggantian Atap',
                          'Cat Dinding',
                          'Pemasangan Keramik',
                        ],
                      ),
                ),
              );
            } else if (index == 2) {
              // Sudah di Umpan Balik, tidak perlu navigasi
            } else if (index == 3) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ChatBotScreen()),
              );
            }
          },
        ),
      ),
    );
  }
}

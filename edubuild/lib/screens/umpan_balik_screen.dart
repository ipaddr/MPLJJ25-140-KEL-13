import 'package:flutter/material.dart';
import '../widgets/mobile_wrapper.dart';
import 'umpan_balik_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'monitoring_renovasi_screen.dart';
import 'dart:async';
import 'home_screen.dart'; 

int rating = 0;
String? selectedDate;

List<String> dateOptions = ['1 Mei 2025', '2 Mei 2025', '3 Mei 2025'];

class UmpanBalikScreen extends StatefulWidget {
  final List<Map<String, dynamic>> feedbackList;

  const UmpanBalikScreen({super.key, required this.feedbackList});

  @override
  State<UmpanBalikScreen> createState() => _UmpanBalikScreenState();
}

class _UmpanBalikScreenState extends State<UmpanBalikScreen> {
  int _selectedIndex = 0;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController komentarController = TextEditingController();
  int rating = 3;

  List<Map<String, dynamic>> feedbacks = [];
  String? selectedDate;

  List<String> dateOptions = ['1 Mei 2025', '2 Mei 2025', '3 Mei 2025'];

  @override
  void initState() {
    super.initState();
    feedbacks = List.from(widget.feedbackList);
  }

  void _submitFeedback() {
    if (namaController.text.isNotEmpty && komentarController.text.isNotEmpty) {
      setState(() {
        feedbacks.add({
          'nama': namaController.text,
          'rating': rating,
          'komentar': komentarController.text,
        });
        namaController.clear();
        komentarController.clear();
        rating = 3;
      });
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    komentarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text('Umpan Balik', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: MobileWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Beri Penilaian Renovasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'SMA Negeri 1 Padang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Jl. Belanti Raya, Lolong Belanti',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                    const Text(
                      'Komentar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: komentarController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Tuliskan komentar Anda...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Kirim',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const Text(
                      'Tanggal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedDate,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('--Pilih Tanggal--'),
                      items:
                          dateOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedDate = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        '© 2025 EduBuild. All rights reserved.',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue[900],
      // Background biru seperti di desain
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
                setState(() {
                  _selectedIndex = index;
                });

                // Navigasi sesuai index
                if (index == 2) {
                  // Index 2 adalah Umpan Balik
                  // Import umpan_balik_screen.dart harus sudah ditambahkan di bagian atas file
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => UmpanBalikScreen(
                            feedbackList:
                                [], // Kirim daftar kosong atau data feedback yang ada
                          ),
                    ),
                  );
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

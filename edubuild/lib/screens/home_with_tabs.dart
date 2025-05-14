import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeWithTabs extends StatefulWidget {
  const HomeWithTabs({super.key});

  @override
  State<HomeWithTabs> createState() => _HomeWithTabsState();
}

class _HomeWithTabsState extends State<HomeWithTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  String? selectedBangunan;
  String? selectedFasilitas;
  String? selectedKebersihan;

  final List<String> options = ['Baik', 'Cukup', 'Buruk'];

  final namaController = TextEditingController();
  final komentarController = TextEditingController();
  int rating = 3;
  List<Map<String, dynamic>> feedbacks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  void _submitForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Laporan berhasil dikirim')),
    );
  }

  void _submitFeedback() {
    if (namaController.text.isNotEmpty &&
        komentarController.text.isNotEmpty) {
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
    _tabController.dispose();
    namaController.dispose();
    komentarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduBuild'),
        backgroundColor: const Color(0xFF1E3A8A),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pelaporan'),
            Tab(text: 'Visualisasi'),
            Tab(text: 'Feedback'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPelaporanTab(),
          _buildVisualisasiTab(),
          _buildFeedbackTab(),
        ],
      ),
    );
  }

  Widget _buildPelaporanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Penilaian kelengkapan sekolah',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 12),
                _buildDropdown('Bangunan', selectedBangunan,
                    (val) => setState(() => selectedBangunan = val)),
                const SizedBox(height: 12),
                _buildDropdown('Fasilitas', selectedFasilitas,
                    (val) => setState(() => selectedFasilitas = val)),
                const SizedBox(height: 12),
                _buildDropdown('Kebersihan', selectedKebersihan,
                    (val) => setState(() => selectedKebersihan = val)),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: _selectedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.upload, color: Colors.white),
                                SizedBox(height: 4),
                                Text('Upload Image',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            )
                          : Image.file(_selectedImage!),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Export'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Kirim Laporan'),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualisasiTab() {
    return const Center(
      child: Text(
        'Halaman Visualisasi (Placeholder)',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildFeedbackTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Berikan umpan balikmu!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: namaController,
            decoration: const InputDecoration(
              labelText: 'Nama',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: komentarController,
            decoration: const InputDecoration(
              labelText: 'Komentar',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Rating:'),
              const SizedBox(width: 8),
              for (int i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => rating = i),
                  icon: Icon(
                    i <= rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _submitFeedback,
            child: const Text('Kirim'),
          ),
          const Divider(height: 32),
          Expanded(
            child: feedbacks.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada umpan balik.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                : ListView.separated(
                    itemCount: feedbacks.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final fb = feedbacks[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(fb['nama']),
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    i < fb['rating']
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(fb['komentar']),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          items: options
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}

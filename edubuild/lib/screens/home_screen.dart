import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_bottom_nav.dart';
import 'monitoring_renovasi_screen.dart';
import 'umpan_balik_screen.dart';
import 'detail_pesanan_screen.dart';
import 'chatbot.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
// Tambahkan import warna
import 'package:edubuild/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  int _selectedIndex = 0;
  bool isLoading = true;
  String searchQuery = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> renovationItems = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    loadRenovationItems();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadRenovationItems() async {
    setState(() => isLoading = true);
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('renovation_items').get();
      setState(() {
        renovationItems =
            snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {
                'id': doc.id,
                'title': data['title'] ?? '',
                'desc': data['desc'] ?? '',
                'price': data['price'] ?? 0,
                'tools': data['tools'] ?? [],
                'fotoSekolah': data['fotoSekolah'],
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
        .where(
          (item) => item['title'].toString().toLowerCase().contains(
            searchQuery.toLowerCase(),
          ),
        )
        .fold(0, (sum, item) {
          final int price =
              (item['price'] ?? 0) is int
                  ? (item['price'] ?? 0)
                  : int.tryParse(item['price'].toString()) ?? 0;
          return sum + price;
        });
  }

  Future<void> _showAddSchoolDialog() async {
    final _titleController = TextEditingController();
    final _descController = TextEditingController();
    final _priceController = TextEditingController();

    File? _dialogImage;
    String? _dialogUploadedImageUrl;

    List<Map<String, TextEditingController>> toolsControllers = [
      {
        'name': TextEditingController(text: 'Atap'),
        'price': TextEditingController(),
      },
      {
        'name': TextEditingController(text: 'Semen'),
        'price': TextEditingController(),
      },
      {
        'name': TextEditingController(text: 'Batu Bata'),
        'price': TextEditingController(),
      },
      {
        'name': TextEditingController(text: 'Paku'),
        'price': TextEditingController(),
      },
    ];

    Future<void> _pickDialogImage(StateSetter setStateDialog) async {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile != null) {
          setStateDialog(() {
            _dialogImage = File(pickedFile.path);
          });

          // Upload ke Supabase Storage
          final supabase = Supabase.instance.client;
          final fileName =
              'sekolah_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final fileBytes = await pickedFile.readAsBytes();

          final response = await supabase.storage
              .from('bukti-renovasi')
              .uploadBinary(
                fileName,
                fileBytes,
                fileOptions: FileOptions(
                  upsert: true,
                  contentType: 'image/jpeg',
                ),
              );

          if (response.isNotEmpty) {
            final publicUrl = supabase.storage
                .from('bukti-renovasi')
                .getPublicUrl(fileName);
            setStateDialog(() {
              _dialogUploadedImageUrl = publicUrl;
            });
          } else {
            setStateDialog(() {
              _dialogUploadedImageUrl = null;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal upload ke Supabase')),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }

    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setStateDialog) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.cardGradient(context),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow(context),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tambah & Kirim Laporan Sekolah',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Upload & preview foto sekolah
                          Row(
                            children: [
                              if (_dialogUploadedImageUrl != null)
                                Container(
                                  height: 50,
                                  width: 50,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        _dialogUploadedImageUrl!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                )
                              else if (_dialogImage != null)
                                Container(
                                  height: 50,
                                  width: 50,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(_dialogImage!),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ElevatedButton.icon(
                                onPressed:
                                    () => _pickDialogImage(setStateDialog),
                                icon: const Icon(Icons.upload_file),
                                label: const Text('Upload Foto'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonPrimary(
                                    context,
                                  ),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Nama Sekolah',
                              filled: true,
                              fillColor: AppColors.surface(
                                context,
                              ).withOpacity(0.85),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _descController,
                            decoration: InputDecoration(
                              labelText: 'Deskripsi Renovasi',
                              filled: true,
                              fillColor: AppColors.surface(
                                context,
                              ).withOpacity(0.85),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelText: 'Biaya (Rp)',
                              filled: true,
                              fillColor: AppColors.surface(
                                context,
                              ).withOpacity(0.85),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Alat-alat Bangunan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                          ...toolsControllers.asMap().entries.map((entry) {
                            int idx = entry.key;
                            var tool = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: tool['name'],
                                      decoration: InputDecoration(
                                        labelText: 'Nama Alat',
                                        filled: true,
                                        fillColor: AppColors.surface(
                                          context,
                                        ).withOpacity(0.85),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: tool['price'],
                                      decoration: InputDecoration(
                                        labelText: 'Harga (Rp)',
                                        filled: true,
                                        fillColor: AppColors.surface(
                                          context,
                                        ).withOpacity(0.85),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                  if (toolsControllers.length > 1)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () => setStateDialog(
                                            () =>
                                                toolsControllers.removeAt(idx),
                                          ),
                                    ),
                                ],
                              ),
                            );
                          }),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed:
                                  () => setStateDialog(() {
                                    toolsControllers.add({
                                      'name': TextEditingController(),
                                      'price': TextEditingController(),
                                    });
                                  }),
                              icon: const Icon(Icons.add),
                              label: const Text('Tambah Alat'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_titleController.text.isEmpty ||
                                      _descController.text.isEmpty ||
                                      _priceController.text.isEmpty ||
                                      _dialogUploadedImageUrl == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Semua field dan foto harus diisi!',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  List<Map<String, dynamic>> tools = [];
                                  for (var tool in toolsControllers) {
                                    final name = tool['name']!.text.trim();
                                    final price = tool['price']!.text.trim();
                                    if (name.isNotEmpty && price.isNotEmpty) {
                                      tools.add({
                                        'name': name,
                                        'price': int.tryParse(price) ?? 0,
                                      });
                                    }
                                  }
                                  try {
                                    final newItem = {
                                      'title': _titleController.text,
                                      'desc': _descController.text,
                                      'price':
                                          int.tryParse(_priceController.text) ??
                                          0,
                                      'tools': tools,
                                      'fotoSekolah': _dialogUploadedImageUrl,
                                    };
                                    // Simpan ke renovation_items (untuk list sekolah)
                                    await _firestore
                                        .collection('renovation_items')
                                        .add(newItem);

                                    // Simpan juga ke laporan_renovasi (untuk laporan)
                                    await _firestore
                                        .collection('laporan_renovasi')
                                        .add({
                                          'items': [newItem],
                                          'tanggal': DateTime.now(),
                                          'status': 'Menunggu',
                                          'buktiImage': _dialogUploadedImageUrl,
                                          'namaSekolah': _titleController.text,
                                        });

                                    setState(() => searchQuery = '');
                                    await loadRenovationItems();
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Laporan berhasil dikirim!',
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Gagal mengirim laporan: $e',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonPrimary(
                                    context,
                                  ),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Kirim Laporan'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ),
    );
  }

  Widget _buildStatBox(String value, String label, List<Color> gradientColors) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _animationController,
        builder:
            (context, child) => Opacity(
              opacity: _fadeAnimation.value,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gradEnd.withOpacity(0.10),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
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
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildRenovationItem(Map<String, dynamic> item) {
    final int price =
        (item['price'] ?? 0) is int
            ? (item['price'] ?? 0)
            : int.tryParse(item['price'].toString()) ?? 0;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.cardGradient(context),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow(context),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info sekolah
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        Text(
                          item['desc'] ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Foto sekolah (jika ada)
              if (item['fotoSekolah'] != null)
                Container(
                  height: 80,
                  width: 120,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(item['fotoSekolah']),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              // Tombol-tombol aksi
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final currentContext = context;
                      final snapshot =
                          await _firestore
                              .collection('renovation_items')
                              .where('title', isEqualTo: item['title'])
                              .limit(1)
                              .get();

                      if (snapshot.docs.isNotEmpty) {
                        final doc = snapshot.docs.first;
                        if (!mounted) return;
                        Navigator.push(
                          currentContext,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DetailPesananScreen(idPesanan: doc.id),
                          ),
                        );
                      } else {
                        if (!mounted) return;
                        ScaffoldMessenger.of(currentContext).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Belum ada laporan renovasi untuk sekolah ini!',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary(context),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Pelaporan'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MonitoringRenovasiScreen(
                                namaSekolah: item['title'] ?? '',
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary(context),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Visualisasi'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UmpanBalikScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonFeedback(context),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Feedback'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        color: AppColors.background(context),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EduBuild',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '© 2025 EduBuild.\nPlatform untuk memantau dan menilai kondisi sekolah di seluruh Indonesia.\nHubungi Kami : support@edubuild.id',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoftBlueBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.cardGradient(context),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Stack(
        children: [
          _buildSoftBlueBackground(),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.headerGradient(context),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gradEnd.withOpacity(0.13),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "EduBuild",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              "Building Schools, Building the Future",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Statistik Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          _firestore.collection('laporan_renovasi').snapshots(),
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
                              totalAnggaran +=
                                  (price is int)
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
                          totalProgress =
                              progressCount > 0
                                  ? (progressSum ~/ progressCount)
                                  : 75;
                        }
                        return Row(
                          children: [
                            _buildStatBox('$totalProyek', 'Total Proyek', [
                              AppColors.gradStart,
                              AppColors.gradEnd,
                            ]),
                            _buildStatBox(
                              'Rp ${totalAnggaran >= 1000000 ? (totalAnggaran / 1000000).toStringAsFixed(1) + "JT" : totalAnggaran.toString()}',
                              'Total Anggaran',
                              [AppColors.gradStart, AppColors.gradEnd],
                            ),
                            _buildStatBox('$totalProgress%', 'Progress', [
                              AppColors.gradStart,
                              AppColors.gradEnd,
                            ]),
                          ],
                        );
                      },
                    ),
                  ),
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surface(
                                context,
                              ).withOpacity(0.95),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gradEnd.withOpacity(0.07),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: AppColors.textPrimary(context),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Search School',
                                      border: InputBorder.none,
                                    ),
                                    onChanged:
                                        (value) =>
                                            setState(() => searchQuery = value),
                                    onSubmitted:
                                        (value) =>
                                            setState(() => searchQuery = value),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Tombol tambah sekolah
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 2,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Sekolah'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimary(context),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                          shadowColor: AppColors.gradEnd.withOpacity(0.13),
                        ),
                        onPressed: _showAddSchoolDialog,
                      ),
                    ),
                  ),
                  // Renovasi Section
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface(context).withOpacity(0.95),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gradEnd.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Penilaian kelengkapan renovasi sekolah',
                                style: TextStyle(
                                  color: AppColors.textPrimary(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (isLoading)
                                Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.buttonPrimary(context),
                                  ),
                                )
                              else
                                ...renovationItems
                                    .where(
                                      (item) => item['title']
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchQuery.toLowerCase()),
                                    )
                                    .map(_buildRenovationItem),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            // Sudah di Home
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const MonitoringRenovasiScreen(
                      namaSekolah: "SMA Negeri 1 Padang",
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
}

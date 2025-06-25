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
import 'package:edubuild/theme/app_colors.dart';
import 'package:edubuild/theme/theme_controller.dart';
import 'admin_home_screen.dart';

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
  bool _isDarkMode = false; // State for dark mode

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation; // Animasi skala baru

  @override
  void initState() {
    super.initState();
    _isDarkMode =
        ThemeController.themeMode.value ==
        ThemeMode.dark; // Initialize dark mode state based on ThemeController
    loadRenovationItems();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ), // Durasi animasi lebih panjang
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuad, // Kurva animasi yang lebih halus
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15), // Mulai sedikit lebih jauh
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ), // Kurva slide yang lebih dinamis
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95, // Mulai sedikit lebih kecil
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ), // Efek "pop" ringan
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

  // ...existing import and class code...

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
                      // SOFT GRADIENT: gunakan warna pastel/soft
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFF6F8FF), // Soft blue-white
                          const Color(0xFFE9ECF7), // Soft blue-lavender
                          const Color(0xFFD9E7F1), // Soft blue
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
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
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Upload & preview foto sekolah
                          Row(
                            children: [
                              if (_dialogUploadedImageUrl != null)
                                Container(
                                  height: 48,
                                  width: 48,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        _dialogUploadedImageUrl!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                )
                              else if (_dialogImage != null)
                                Container(
                                  height: 48,
                                  width: 48,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(_dialogImage!),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ElevatedButton.icon(
                                onPressed:
                                    () => _pickDialogImage(setStateDialog),
                                icon: const Icon(Icons.upload_file, size: 18),
                                label: const Text('Upload Foto'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFF6D8EFF,
                                  ), // Soft blue
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Input fields
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Nama Sekolah',
                              filled: true,
                              fillColor:
                                  Theme.of(
                                    context,
                                  ).inputDecorationTheme.fillColor ??
                                  AppColors.surface(context),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade200,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _descController,
                            decoration: InputDecoration(
                              labelText: 'Deskripsi Renovasi',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.85),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade200,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelText: 'Biaya (Rp)',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.85),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade200,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          const SizedBox(height: 18),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Alat-alat Bangunan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4A6FA5), // Soft blue
                                fontSize: 15,
                              ),
                            ),
                          ),
                          ...toolsControllers.asMap().entries.map((entry) {
                            int idx = entry.key;
                            var tool = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: tool['name'],
                                      decoration: InputDecoration(
                                        labelText: 'Nama Alat',
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(
                                          0.85,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.blue.shade200,
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12,
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
                                        fillColor: Colors.white.withOpacity(
                                          0.85,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.blue.shade200,
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12,
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
                                        color: Color(0xFFEF5350), // Soft red
                                      ),
                                      splashRadius: 18,
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
                              icon: const Icon(
                                Icons.add,
                                color: Color(0xFF4A6FA5),
                              ),
                              label: const Text(
                                'Tambah Alat',
                                style: TextStyle(
                                  color: Color(0xFF4A6FA5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF4A6FA5),
                                textStyle: const TextStyle(fontSize: 14),
                                splashFactory: NoSplash.splashFactory,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[600],
                                  textStyle: const TextStyle(fontSize: 15),
                                ),
                              ),
                              const SizedBox(width: 10),
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
                                  backgroundColor: const Color(
                                    0xFF6D8EFF,
                                  ), // Soft blue
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 22,
                                    vertical: 13,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  elevation: 0,
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
  // ...rest of

  // Removed the _buildStatBox widget as it's no longer needed.

  // ...existing code...

  Widget _buildRenovationItem(Map<String, dynamic> item) {
    final int price =
        (item['price'] ?? 0) is int
            ? (item['price'] ?? 0)
            : int.tryParse(item['price'].toString()) ?? 0;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.cardGradient(context),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow(context).withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['fotoSekolah'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item['fotoSekolah'],
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 90,
                            width: 90,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey[400],
                              size: 40,
                            ),
                          ),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.textPrimary(context),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['desc'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary(context),
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Ganti warna harga menjadi putih pada mode light
                          Text(
                            'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : AppColors.textPrimary(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildActionButton(
                            label: 'Pelaporan',
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
                                        (context) => DetailPesananScreen(
                                          idPesanan: doc.id,
                                        ),
                                  ),
                                );
                              } else {
                                if (!mounted) return;
                                ScaffoldMessenger.of(
                                  currentContext,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Belum ada laporan renovasi untuk sekolah ini!',
                                    ),
                                  ),
                                );
                              }
                            },
                            backgroundColor: AppColors.buttonPrimary(context),
                          ),
                          const SizedBox(width: 8),
                          _buildActionButton(
                            label: 'Visualisasi',
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
                            backgroundColor: AppColors.buttonPrimary(context),
                          ),
                          const SizedBox(width: 8),
                          _buildActionButton(
                            label: 'Feedback',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const UmpanBalikScreen(),
                                ),
                              );
                            },
                            backgroundColor: AppColors.buttonFeedback(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ...rest of your code

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
  }) {
    return Expanded(
      // Gunakan Expanded agar tombol mengisi ruang
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 10, // Padding horizontal lebih kecil
            vertical: 10, // Padding vertikal lebih besar
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Border radius tombol
          ),
          elevation: 3, // Elevasi tombol
          shadowColor: backgroundColor.withOpacity(0.4), // Bayangan tombol
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12), // Ukuran font tombol
        ),
      ),
    );
  }

  Widget _buildSoftBlueBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.backgroundGradient(
            context,
          ), // Gunakan gradien latar belakang yang lebih halus
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  // Callback function to toggle dark mode
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      ThemeController.toggleTheme(); // Call the actual theme toggle
    });
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
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      40,
                      20,
                      20,
                    ), // Padding atas lebih besar
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.headerGradient(context),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(
                          25,
                        ), // Border radius sedikit lebih besar
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gradEnd.withOpacity(
                            0.20,
                          ), // Bayangan lebih terlihat
                          blurRadius: 12, // Blur lebih besar
                          offset: const Offset(0, 6), // Offset lebih besar
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align items to the top
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "EduBuild",
                              style: TextStyle(
                                fontSize: 24, // Ukuran font lebih besar
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  // Tambahkan bayangan teks
                                  Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Building Schools, Building the Future",
                              style: TextStyle(
                                fontSize: 13, // Ukuran font sedikit lebih besar
                                color:
                                    Colors.white70, // Warna teks sedikit redup
                              ),
                            ),
                          ],
                        ),
                        // Removed the Spacer and StreamBuilder for stat boxes
                        const Spacer(),
                      ],
                    ),
                  ),
                  // Search bar and Add School button in a Row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      18,
                      20,
                      8, // Reduced bottom padding
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Distribute space
                      children: [
                        // Tombol tambah sekolah (moved to left)
                        Expanded(
                          // Use Expanded to give it flexible width
                          flex: 5, // Give it more flex to be a bit wider
                          child: SizedBox(
                            height: 38,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.add_business_rounded,
                                  size: 16,
                                ),
                                label: const Text(
                                  'Tambah Sekolah',
                                  style: TextStyle(fontSize: 10),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonPrimary(
                                    context,
                                  ),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  elevation: 2,
                                  shadowColor: AppColors.buttonPrimary(
                                    context,
                                  ).withOpacity(0.2),
                                ),
                                onPressed: _showAddSchoolDialog,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ), // Small spacing between button and search bar
                        // Search bar (moved to right)
                        Expanded(
                          // Use Expanded to give it flexible width
                          flex:
                              6, // Give it more flex to be a bit wider than the button
                          child: SizedBox(
                            height: 38,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 0,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface(
                                    context,
                                  ).withOpacity(0.98),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.gradEnd.withOpacity(
                                        0.08,
                                      ),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: AppColors.textPrimary(
                                        context,
                                      ).withOpacity(0.7),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Cari Sekolah...',
                                          hintStyle: TextStyle(
                                            color: AppColors.textSecondary(
                                              context,
                                            ).withOpacity(0.6),
                                            fontSize: 12,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        onChanged:
                                            (value) => setState(
                                              () => searchQuery = value,
                                            ),
                                        onSubmitted:
                                            (value) => setState(
                                              () => searchQuery = value,
                                            ),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Renovasi Section
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12, // Padding vertikal lebih besar
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(
                          18,
                        ), // Padding lebih besar
                        decoration: BoxDecoration(
                          color: AppColors.surface(
                            context,
                          ).withOpacity(0.98), // Opasitas lebih tinggi
                          borderRadius: BorderRadius.circular(
                            18,
                          ), // Border radius lebih besar
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gradEnd.withOpacity(
                                0.12,
                              ), // Bayangan lebih terlihat
                              blurRadius: 15, // Blur lebih besar
                              offset: const Offset(0, 8), // Offset lebih besar
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daftar Sekolah & Penilaian Renovasi', // Judul lebih deskriptif
                              style: TextStyle(
                                color: AppColors.textPrimary(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 17, // Ukuran font lebih besar
                              ),
                            ),
                            const SizedBox(height: 15), // Spasi lebih besar
                            if (isLoading)
                              Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.buttonPrimary(context),
                                ),
                              )
                            else if (renovationItems.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'Belum ada data sekolah yang tersedia.',
                                    style: TextStyle(
                                      color: AppColors.textSecondary(context),
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
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
                                  .map(_buildRenovationItem)
                                  .toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) {
          // Adjust index mapping since the last item is now 'Mode'
          if (index == 0) {
            setState(() => _selectedIndex = index);
          } else if (index == 1) {
            setState(() => _selectedIndex = index);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const MonitoringRenovasiScreen(
                      namaSekolah: "SMA Negeri 1 Padang", // Example school name
                    ),
              ),
            );
          } else if (index == 2) {
            setState(() => _selectedIndex = index);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UmpanBalikScreen()),
            );
          } else if (index == 3) {
            setState(() => _selectedIndex = index);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChatBotScreen()),
            );
          } else if (index == 4) {
            setState(() => _selectedIndex = index);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/mobile_wrapper.dart';
import '../widgets/custom_bottom_nav.dart';
import 'umpan_balik_screen.dart';
import 'home_screen.dart';
import 'chatbot.dart';
// Tambahkan import warna
import 'package:edubuild/theme/app_colors.dart';

class MonitoringRenovasiScreen extends StatefulWidget {
  final String namaSekolah;

  const MonitoringRenovasiScreen({super.key, required this.namaSekolah});

  @override
  State<MonitoringRenovasiScreen> createState() =>
      _MonitoringRenovasiScreenState();
}

class _MonitoringRenovasiScreenState extends State<MonitoringRenovasiScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;
  String statusProyekAwal = 'Belum Dimulai';
  List<String> riwayatPerbaikan = [];
  bool isLoading = true;
  String? fotoSekolah;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
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

  Future<void> _loadDataFromFirestore() async {
    setState(() => isLoading = true);
    // Ambil data monitoring
    final snapshot =
        await FirebaseFirestore.instance
            .collection('monitoring_renovasi')
            .doc(widget.namaSekolah.replaceAll(' ', '_'))
            .get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      statusProyekAwal = data['statusProyek'] ?? 'Belum Dimulai';
      riwayatPerbaikan = List<String>.from(data['riwayatPerbaikan'] ?? []);
    }
    // Ambil foto sekolah dari renovation_items
    final sekolahSnapshot =
        await FirebaseFirestore.instance
            .collection('renovation_items')
            .where('title', isEqualTo: widget.namaSekolah)
            .limit(1)
            .get();
    if (sekolahSnapshot.docs.isNotEmpty) {
      final sekolahData = sekolahSnapshot.docs.first.data();
      fotoSekolah = sekolahData['fotoSekolah'];
    }
    setState(() => isLoading = false);
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
      appBar: AppBar(
        title: const Text('Monitoring Renovasi', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: AppColors.buttonPrimary(context),
        elevation: 2,
        shadowColor: AppColors.buttonPrimary(context).withOpacity(0.15),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          _buildSoftBlueBackground(),
          Center(
            child: SingleChildScrollView(
              child: MobileWrapper(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20.0,
                  ),
                  child:
                      isLoading
                          ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.buttonPrimary(context),
                            ),
                          )
                          : FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                      horizontal: 18,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface(
                                        context,
                                      ).withOpacity(0.97),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.gradEnd.withOpacity(
                                            0.10,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Status Proyek',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary(
                                              context,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.background(
                                              context,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Text(
                                            statusProyekAwal,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary(
                                                context,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          widget.namaSekolah,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary(
                                              context,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Center(
                                          child: Container(
                                            width: 260,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.gradEnd
                                                      .withOpacity(0.10),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child:
                                                  fotoSekolah != null &&
                                                          fotoSekolah!
                                                              .isNotEmpty
                                                      ? Image.network(
                                                        fotoSekolah!,
                                                        fit: BoxFit.cover,
                                                      )
                                                      : Image.asset(
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
                                          style: TextStyle(
                                            color: AppColors.textPrimary(
                                              context,
                                            ),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          'Riwayat Perbaikan',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary(
                                              context,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                        if (riwayatPerbaikan.isEmpty)
                                          Text(
                                            'Belum ada riwayat perbaikan.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.textPrimary(
                                                context,
                                              ),
                                            ),
                                          )
                                        else
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: riwayatPerbaikan.length,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                color: AppColors.background(
                                                  context,
                                                ),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.history,
                                                    color:
                                                        AppColors.textPrimary(
                                                          context,
                                                        ),
                                                  ),
                                                  title: Text(
                                                    riwayatPerbaikan[index],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.textPrimary(
                                                            context,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                ),
              ),
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

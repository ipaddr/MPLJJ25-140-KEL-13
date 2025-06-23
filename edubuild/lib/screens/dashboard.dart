import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/admin_bottom_nav.dart';
// Tambahkan import warna
import 'package:edubuild/theme/app_colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;
  Map<String, TextEditingController> _riwayatControllers = {};

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    for (var controller in _riwayatControllers.values) {
      controller.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updateStatusProyek(String namaSekolah, String newStatus) async {
    final ref = FirebaseFirestore.instance
        .collection('monitoring_renovasi')
        .doc(namaSekolah.replaceAll(' ', '_'));
    final snapshot = await ref.get();
    List<String> riwayatPerbaikan = [];
    if (snapshot.exists) {
      final data = snapshot.data()!;
      riwayatPerbaikan = List<String>.from(data['riwayatPerbaikan'] ?? []);
    }
    await ref.set({
      'namaSekolah': namaSekolah,
      'statusProyek': newStatus,
      'riwayatPerbaikan': riwayatPerbaikan,
    }, SetOptions(merge: true));
  }

  Future<void> _addRiwayatPerbaikan(
    String namaSekolah,
    String perbaikan,
  ) async {
    final ref = FirebaseFirestore.instance
        .collection('monitoring_renovasi')
        .doc(namaSekolah.replaceAll(' ', '_'));
    final snapshot = await ref.get();
    List<String> riwayatPerbaikan = [];
    if (snapshot.exists) {
      final data = snapshot.data()!;
      riwayatPerbaikan = List<String>.from(data['riwayatPerbaikan'] ?? []);
    }
    riwayatPerbaikan.add(perbaikan);
    await ref.set({
      'namaSekolah': namaSekolah,
      'riwayatPerbaikan': riwayatPerbaikan,
    }, SetOptions(merge: true));
  }

  void _onKirimPressed() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Data berhasil dikirim!')));
    // Anda bisa menambahkan aksi lain di sini jika diperlukan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface(context).withOpacity(0.95),
        elevation: 0,
        title: Text(
          'Dashboard Admin',
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary(context)),
        centerTitle: true,
      ),
      bottomNavigationBar: const AdminBottomNav(selectedIndex: 1),
      body: Stack(
        children: [
          const _SoftBluePurpleBackground(),
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('renovation_items')
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.buttonPrimary(context),
                              ),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Text('Belum ada data sekolah.');
                          }
                          final docs = snapshot.data!.docs;
                          return Column(
                            children:
                                docs.map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  final namaSekolah = data['title'] ?? '-';
                                  final fotoSekolah = data['fotoSekolah'];
                                  final sekolahKey = namaSekolah.replaceAll(
                                    ' ',
                                    '_',
                                  );
                                  _riwayatControllers.putIfAbsent(
                                    sekolahKey,
                                    () => TextEditingController(),
                                  );

                                  return FutureBuilder<DocumentSnapshot>(
                                    future:
                                        FirebaseFirestore.instance
                                            .collection('monitoring_renovasi')
                                            .doc(sekolahKey)
                                            .get(),
                                    builder: (context, monitorSnapshot) {
                                      String statusProyek = 'Belum Dimulai';
                                      List<String> riwayatPerbaikan = [];
                                      if (monitorSnapshot.hasData &&
                                          monitorSnapshot.data!.exists) {
                                        final monitorData =
                                            monitorSnapshot.data!.data()
                                                as Map<String, dynamic>;
                                        statusProyek =
                                            monitorData['statusProyek'] ??
                                            'Belum Dimulai';
                                        riwayatPerbaikan = List<String>.from(
                                          monitorData['riwayatPerbaikan'] ?? [],
                                        );
                                      }
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        padding: const EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: AppColors.cardGradient(
                                              context,
                                            ),
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.shadow(context),
                                              blurRadius: 16,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              namaSekolah,
                                              style: TextStyle(
                                                fontSize: 18,
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
                                                width: 280,
                                                height: 180,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColors.shadow(
                                                        context,
                                                      ),
                                                      blurRadius: 8,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child:
                                                      fotoSekolah != null &&
                                                              fotoSekolah
                                                                  .toString()
                                                                  .isNotEmpty
                                                          ? Image.network(
                                                            fotoSekolah,
                                                            fit: BoxFit.cover,
                                                          )
                                                          : Image.asset(
                                                            'assets/images/sekolah.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.surface(
                                                  context,
                                                ).withOpacity(0.85),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Status Proyek',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors.textPrimary(
                                                            context,
                                                          ),
                                                    ),
                                                  ),
                                                  DropdownButtonHideUnderline(
                                                    child: DropdownButton<
                                                      String
                                                    >(
                                                      isExpanded: true,
                                                      value: statusProyek,
                                                      alignment:
                                                          Alignment.center,
                                                      items: const [
                                                        DropdownMenuItem(
                                                          value:
                                                              'Belum Dimulai',
                                                          child: Text(
                                                            'Belum Dimulai',
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value:
                                                              'Sedang Berlangsung',
                                                          child: Text(
                                                            'Sedang Berlangsung',
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value:
                                                              'Sudah Selesai',
                                                          child: Text(
                                                            'Sudah Selesai',
                                                          ),
                                                        ),
                                                      ],
                                                      onChanged: (value) {
                                                        if (value != null) {
                                                          _updateStatusProyek(
                                                            namaSekolah,
                                                            value,
                                                          );
                                                          setState(() {});
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.surface(
                                                  context,
                                                ).withOpacity(0.85),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Riwayat Perbaikan',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors.textPrimary(
                                                            context,
                                                          ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        riwayatPerbaikan.length,
                                                    itemBuilder: (
                                                      context,
                                                      index,
                                                    ) {
                                                      return Card(
                                                        color:
                                                            AppColors
                                                                .gradSoftPurple,
                                                        child: ListTile(
                                                          leading: Icon(
                                                            Icons.history,
                                                            color:
                                                                AppColors.textSecondary(
                                                                  context,
                                                                ),
                                                          ),
                                                          title: Text(
                                                            riwayatPerbaikan[index],
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
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
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextField(
                                                          controller:
                                                              _riwayatControllers[sekolahKey],
                                                          decoration: const InputDecoration(
                                                            hintText:
                                                                'Tambah riwayat perbaikan',
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                          onSubmitted: (
                                                            value,
                                                          ) async {
                                                            if (value
                                                                .trim()
                                                                .isNotEmpty) {
                                                              await _addRiwayatPerbaikan(
                                                                namaSekolah,
                                                                value.trim(),
                                                              );
                                                              _riwayatControllers[sekolahKey]
                                                                  ?.clear();
                                                              setState(() {});
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors.buttonSecondary(
                                                                context,
                                                              ),
                                                          foregroundColor:
                                                              Colors.white,
                                                        ),
                                                        onPressed: () async {
                                                          final value =
                                                              _riwayatControllers[sekolahKey]
                                                                  ?.text ??
                                                              '';
                                                          if (value
                                                              .trim()
                                                              .isNotEmpty) {
                                                            await _addRiwayatPerbaikan(
                                                              namaSekolah,
                                                              value.trim(),
                                                            );
                                                            _riwayatControllers[sekolahKey]
                                                                ?.clear();
                                                            setState(() {});
                                                          }
                                                        },
                                                        child: const Icon(
                                                          Icons.add,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonPrimary(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _onKirimPressed,
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
        ],
      ),
    );
  }
}

class _SoftBluePurpleBackground extends StatelessWidget {
  const _SoftBluePurpleBackground();

  @override
  Widget build(BuildContext context) {
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
}

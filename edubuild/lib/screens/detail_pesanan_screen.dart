import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Tambahkan import warna
import 'package:edubuild/theme/app_colors.dart';

class DetailPesananScreen extends StatelessWidget {
  final String idPesanan;

  const DetailPesananScreen({super.key, required this.idPesanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan Renovasi'),
        backgroundColor: AppColors.surface(context).withOpacity(0.95),
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary(context)),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary(context),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background gradasi ungu-biru
          const _SoftBluePurpleBackground(),
          _AnimatedDetailContent(idPesanan: idPesanan),
        ],
      ),
    );
  }

  static int _parsePrice(dynamic price) {
    if (price == null) return 0;
    if (price is int) return price;
    return int.tryParse(price.toString()) ?? 0;
  }

  static String _formatRupiah(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}

class _AnimatedDetailContent extends StatefulWidget {
  final String idPesanan;
  const _AnimatedDetailContent({required this.idPesanan});

  @override
  State<_AnimatedDetailContent> createState() => _AnimatedDetailContentState();
}

class _AnimatedDetailContentState extends State<_AnimatedDetailContent>
    with SingleTickerProviderStateMixin {
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('renovation_items')
                  .doc(widget.idPesanan)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.buttonPrimary(context),
                ),
              );
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('Data pesanan tidak ditemukan.'));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final namaSekolah = data['title'] ?? '-';
            final status = data['status'] ?? '-';
            final buktiImage = data['buktiImage'] as String?;
            final int total = DetailPesananScreen._parsePrice(data['price']);
            final List<dynamic> tools = data['tools'] as List<dynamic>? ?? [];
            final String desc = data['desc'] ?? '';

            return Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(18),
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
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderSection(
                        namaSekolah: namaSekolah,
                        idPesanan: widget.idPesanan,
                        status: status,
                      ),
                      if (buktiImage != null && buktiImage.isNotEmpty)
                        _BuktiImageSection(buktiImage: buktiImage),
                      const SizedBox(height: 8),
                      Text(
                        'Rincian Pesanan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppColors.feedbackCardGradient(context),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gradEnd.withOpacity(0.07),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        namaSekolah,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary(context),
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        desc,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Rp ${DetailPesananScreen._formatRupiah(total)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (tools.isNotEmpty) ...[
                              Text(
                                'Rincian Alat-alat Bangunan:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              const SizedBox(height: 4),
                              ...tools.map(
                                (tool) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tool['name'] ?? '-',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      Text(
                                        'Rp ${DetailPesananScreen._formatRupiah(DetailPesananScreen._parsePrice(tool['price']))}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimary(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Total: Rp ${DetailPesananScreen._formatRupiah(total)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String namaSekolah;
  final String idPesanan;
  final String status;

  const _HeaderSection({
    required this.namaSekolah,
    required this.idPesanan,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          namaSekolah,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'ID: $idPesanan',
          style: const TextStyle(fontSize: 13, color: Color(0xFF8888AA)),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Chip(
            label: Text(
              status == 'Disetujui' ? 'Disetujui' : 'Belum Disetujui',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor:
                status == 'Disetujui'
                    ? Colors.green
                    : AppColors.textSecondary(context),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _BuktiImageSection extends StatelessWidget {
  final String buktiImage;

  const _BuktiImageSection({required this.buktiImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          buktiImage,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) =>
                  const Text('Gambar tidak tersedia'),
        ),
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

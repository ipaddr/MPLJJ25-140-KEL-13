import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/admin_bottom_nav.dart';
// Tambahkan import warna
import 'package:edubuild/theme/app_colors.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage>
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

  static String _formatTanggal(dynamic tanggal) {
    if (tanggal is Timestamp) {
      final dt = tanggal.toDate();
      return '${dt.day} ${_bulan(dt.month)} ${dt.year}';
    }
    return tanggal.toString();
  }

  static String _bulan(int bulan) {
    const namaBulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return namaBulan[bulan];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface(context).withOpacity(0.95),
        title: Text(
          'Beranda Umpan Balik',
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary(context)),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBar: const AdminBottomNav(selectedIndex: 2),
      body: Stack(
        children: [
          const _SoftBluePurpleBackground(),
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('feedback')
                        .orderBy('tanggal', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.buttonPrimary(context),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada umpan balik.',
                        style: TextStyle(color: AppColors.textPrimary(context)),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children:
                          snapshot.data!.docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return _buildFeedbackCard(
                              namaSekolah:
                                  data['namaSekolah'] ?? 'School Identity',
                              namaPekomentar: data['namaPekomentar'] ?? '-',
                              tanggal:
                                  data['tanggal'] != null
                                      ? _formatTanggal(data['tanggal'])
                                      : '-',
                              rating: data['rating'] ?? 0,
                              komentar: data['komentar'] ?? '',
                            );
                          }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard({
    required String namaSekolah,
    required String namaPekomentar,
    required String tanggal,
    required int rating,
    required String komentar,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.feedbackCardGradient(context),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradEnd.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.gradStart.withOpacity(0.13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            namaSekolah,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.person,
                color: AppColors.textSecondary(context),
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                namaPekomentar,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w500,
                  fontSize: 13.5,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.calendar_today,
                color: AppColors.textPrimary(context),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                tanggal,
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                color: index < rating ? Colors.orange : Colors.grey.shade300,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface(context).withOpacity(0.85),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              komentar,
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 14,
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

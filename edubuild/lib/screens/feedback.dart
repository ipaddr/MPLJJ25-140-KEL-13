import 'package:flutter/material.dart';
import '../widgets/admin_bottom_nav.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005A9C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF005A9C),
        title: const Text('Beranda Umpan Balik'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(3, (index) => _buildFeedbackCard()),
        ),
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF005A9C),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SMA NEGERI 3 PAYAKUMBUH',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '18 Januari 2025',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.white, size: 20)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Saya mengapresiasi pengerjaan EduBuild ini karena pekerjaannya cepat dan juga bagus, oleh karena itu saya memberikan bintang 5',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

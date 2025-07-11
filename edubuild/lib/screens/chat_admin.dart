import 'package:flutter/material.dart';
import 'package:edubuild/screens/admin_home_screen.dart';
// Tambahkan import warna
import 'package:edubuild/theme/app_colors.dart';

class ChatAdminScreen extends StatefulWidget {
  const ChatAdminScreen({super.key});

  @override
  State<ChatAdminScreen> createState() => _ChatAdminScreenState();
}

class _ChatAdminScreenState extends State<ChatAdminScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Halo, ada yang bisa kami bantu?', 'isUser': false},
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _controller.clear();
    });

    // Balasan otomatis dari admin
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _messages.add({
          'text': 'Terima kasih, pesan Anda sudah diterima oleh admin.',
          'isUser': false,
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat User'),
        backgroundColor: AppColors.buttonPrimary(context),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment:
                        msg['isUser']
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            msg['isUser']
                                ? AppColors.buttonPrimary(context)
                                : AppColors.gradSoftBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        msg['text'],
                        style: TextStyle(
                          color:
                              msg['isUser']
                                  ? AppColors.textOnPrimary(context)
                                  : AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ketik Pesan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _sendMessage,
                  child: const Text('Kirim'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

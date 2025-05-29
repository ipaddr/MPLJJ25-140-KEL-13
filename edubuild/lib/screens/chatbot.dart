import 'package:flutter/material.dart';
import 'chat_admin.dart';
import 'home_screen.dart'; // Tambahkan import ini

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Selamat datang di EduBuild!',
      'isUser': false,
    },
    {
      'text': 'Bagaimana cara melihat laporan renovasi',
      'isUser': true,
    },
    {
      'text': 'Untuk melihat laporan renovasi, silahkan klik menu “Monitoring” kemudian pilih “Progress Renovasi” pada dashboard',
      'isUser': false,
    },
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _controller.clear();
    });

    // Balasan otomatis
    Future.delayed(const Duration(milliseconds: 500), () {
      String reply;
      if (text.toLowerCase().contains('laporan')) {
        reply = 'Untuk melihat laporan renovasi, silahkan klik menu “Monitoring” kemudian pilih “Progress Renovasi” pada dashboard';
      } else if (text.toLowerCase().contains('halo') || text.toLowerCase().contains('hai')) {
        reply = 'Halo! Ada yang bisa kami bantu?';
      } else {
        reply = 'Terima kasih atas pesan Anda. Kami akan segera membalasnya atau silakan gunakan menu yang tersedia.';
      }
      setState(() {
        _messages.add({'text': reply, 'isUser': false});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ChatBot EduBuild'),
        backgroundColor: const Color(0xFF005792),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF005792),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'ChatBot EduBuild',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment: msg['isUser']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: msg['isUser']
                            ? const Color(0xFF005792)
                            : Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        msg['text'],
                        style: TextStyle(
                          color: msg['isUser'] ? Colors.white : Colors.black,
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005792),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _sendMessage,
                  child: const Text('Kirim'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005792),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatAdminScreen(),
                      ),
                    );
                  },
                  child: const Text('Chat Admin'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

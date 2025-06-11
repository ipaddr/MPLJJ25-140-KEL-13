import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'chat_admin.dart';
import 'home_screen.dart';
import 'admin_home_screen.dart'; // Tambahkan import ini

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Selamat datang di EduBuild!', 'isUser': false},
  ];

  // Initialize Gemini
  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey:
        'AIzaSyDQZLwrYTxwBPQJPqH3MbOoUZibxVomzOo', // Replace with your actual API key
  );
  late ChatSession chat;

  @override
  void initState() {
    super.initState();
    chat = model.startChat();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _controller.clear();
    });

    try {
      // Show loading indicator
      setState(() {
        _messages.add({
          'text': 'Sedang mengetik...',
          'isUser': false,
          'isLoading': true,
        });
      });

      // Get response from Gemini
      final response = await chat.sendMessage(Content.text(text));
      final responseText = response.text;

      // Remove loading indicator and add actual response
      setState(() {
        _messages.removeLast();
        _messages.add({
          'text': responseText ?? 'Maaf, terjadi kesalahan',
          'isUser': false,
        });
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add({
          'text': 'Maaf, terjadi kesalahan dalam memproses pesan Anda',
          'isUser': false,
        });
      });
    }
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
              MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
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
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
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

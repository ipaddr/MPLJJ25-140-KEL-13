import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'chat_admin.dart';
import 'admin_home_screen.dart';
import 'home_screen.dart';
// Tambahkan import warna
import 'package:edubuild/theme/app_colors.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Selamat datang di EduBuild!', 'isUser': false},
  ];

  // Initialize Gemini
  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: 'AIzaSyDQZLwrYTxwBPQJPqH3MbOoUZibxVomzOo',
  );
  late ChatSession chat;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    chat = model.startChat();
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

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _controller.clear();
    });

    try {
      setState(() {
        _messages.add({
          'text': 'Sedang mengetik...',
          'isUser': false,
          'isLoading': true,
        });
      });

      final response = await chat.sendMessage(Content.text(text));
      final responseText = response.text;

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
        title: Text(
          'ChatBot EduBuild',
          style: TextStyle(color: AppColors.textPrimary(context)),
        ),
        backgroundColor: AppColors.surface(context).withOpacity(0.95),
        centerTitle: true,
        elevation: 2,
        shadowColor: AppColors.gradEnd.withOpacity(0.10),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary(context)),
          onPressed: () async {
            final result = await showDialog<String>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Kembali ke mana?'),
                    content: const Text('Pilih tujuan kembali:'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'admin'),
                        child: const Text('Admin'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'user'),
                        child: const Text('User'),
                      ),
                    ],
                  ),
            );
            if (!mounted) return;
            if (result == 'admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminHomeScreen(),
                ),
              );
            } else if (result == 'user') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          },
        ),
      ),
      body: Stack(
        children: [
          _buildSoftBlueBackground(),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.gradStart, AppColors.gradEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gradEnd.withOpacity(0.10),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        'ChatBot EduBuild',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface(context).withOpacity(0.97),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gradEnd.withOpacity(0.07),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                          itemCount: _messages.length,
                          reverse: false,
                          itemBuilder: (context, index) {
                            final msg = _messages[index];
                            final isUser = msg['isUser'] as bool;
                            return Align(
                              alignment:
                                  isUser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient:
                                      isUser
                                          ? LinearGradient(
                                            colors: [
                                              AppColors.gradStart,
                                              AppColors.gradEnd,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                          : null,
                                  color:
                                      isUser
                                          ? null
                                          : AppColors.background(context),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    if (isUser)
                                      BoxShadow(
                                        color: AppColors.gradEnd.withOpacity(
                                          0.10,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                  ],
                                ),
                                child: Text(
                                  msg['text'],
                                  style: TextStyle(
                                    color:
                                        isUser
                                            ? Colors.white
                                            : AppColors.textPrimary(context),
                                    fontWeight:
                                        isUser
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.gradSoftPurple,
                                  width: 1.2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.gradSoftPurple,
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.gradEnd,
                                  width: 1.5,
                                ),
                              ),
                              filled: true,
                              fillColor: AppColors.background(context),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            style: TextStyle(
                              color: AppColors.textPrimary(context),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonPrimary(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            shadowColor: AppColors.gradEnd.withOpacity(0.13),
                          ),
                          onPressed: _sendMessage,
                          child: const Icon(Icons.send, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surface(context),
                            foregroundColor: AppColors.textPrimary(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatAdminScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.support_agent),
                          label: const Text('Chat Admin'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/mobile_wrapper.dart';

class FeedbackFormScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const FeedbackFormScreen({super.key, required this.onSubmit});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController komentarController = TextEditingController();
  int rating = 3;

  void _submit() {
    if (namaController.text.isEmpty || komentarController.text.isEmpty) return;

    final feedback = {
      'nama': namaController.text,
      'rating': rating,
      'komentar': komentarController.text,
    };

    widget.onSubmit(feedback);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    namaController.dispose();
    komentarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Umpan Balik'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: MobileWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Isi umpan balik Anda:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: komentarController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Rating:'),
                  const SizedBox(width: 8),
                  for (int i = 1; i <= 5; i++)
                    IconButton(
                      onPressed: () => setState(() => rating = i),
                      icon: Icon(
                        i <= rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                    )
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Kirim Umpan Balik'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

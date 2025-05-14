import 'package:flutter/material.dart';

class UmpanBalikScreen extends StatefulWidget {
  final List<Map<String, dynamic>> feedbackList;

  const UmpanBalikScreen({super.key, required this.feedbackList});

  @override
  State<UmpanBalikScreen> createState() => _UmpanBalikScreenState();
}

class _UmpanBalikScreenState extends State<UmpanBalikScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController komentarController = TextEditingController();
  int rating = 3;

  List<Map<String, dynamic>> feedbacks = [];

  @override
  void initState() {
    super.initState();
    feedbacks = List.from(widget.feedbackList);
  }

  void _submitFeedback() {
    if (namaController.text.isNotEmpty && komentarController.text.isNotEmpty) {
      setState(() {
        feedbacks.add({
          'nama': namaController.text,
          'rating': rating,
          'komentar': komentarController.text,
        });
        namaController.clear();
        komentarController.clear();
        rating = 3;
      });
    }
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
        title: const Text('Umpan Balik Pengguna'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Berikan umpan balikmu!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: komentarController,
              decoration: const InputDecoration(
                labelText: 'Komentar',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Rating:'),
                const SizedBox(width: 8),
                for (int i = 1; i <= 5; i++)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        rating = i;
                      });
                    },
                    icon: Icon(
                      i <= rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text('Kirim'),
            ),
            const Divider(height: 32),
            Expanded(
              child: feedbacks.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada umpan balik.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : ListView.separated(
                      itemCount: feedbacks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final feedback = feedbacks[index];
                        return Card(
                          elevation: 3,
                          child: ListTile(
                            leading: Icon(
                              Icons.person,
                              color: Colors.blue[800],
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(feedback['nama']),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < feedback['rating']
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(feedback['komentar']),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

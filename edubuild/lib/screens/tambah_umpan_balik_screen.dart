import 'package:flutter/material.dart';
// Uncomment jika kamu pakai Firebase
// import 'package:cloud_firestore/cloud_firestore.dart';

class UmpanBalikScreen extends StatefulWidget {
  const UmpanBalikScreen({super.key});

  @override
  State<UmpanBalikScreen> createState() => _UmpanBalikScreenState();
}

class _UmpanBalikScreenState extends State<UmpanBalikScreen> {
  final List<Map<String, dynamic>> feedbackList = [];

  void _tambahUmpanBalik() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController namaController = TextEditingController();
    final TextEditingController komentarController = TextEditingController();
    int rating = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Tambah Umpan Balik',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Pengguna',
                        hintText: 'Masukkan nama Anda',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: komentarController,
                      decoration: const InputDecoration(
                        labelText: 'Komentar',
                        hintText: 'Masukkan komentar Anda',
                        prefixIcon: Icon(Icons.comment),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) =>
                          value!.isEmpty ? 'Komentar tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Rating: ', style: TextStyle(fontSize: 16)),
                        ...List.generate(5, (index) {
                          final starIndex = index + 1;
                          return IconButton(
                            icon: Icon(
                              rating >= starIndex
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              setModalState(() {
                                rating = starIndex;
                              });
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && rating > 0) {
                          final feedback = {
                            'nama': namaController.text,
                            'komentar': komentarController.text,
                            'rating': rating,
                          };

                          setState(() {
                            feedbackList.add(feedback);
                          });

                          // Uncomment ini jika ingin simpan ke Firestore
                          /*
                          FirebaseFirestore.instance.collection('feedbacks').add({
                            ...feedback,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          */

                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Isi semua data dan pilih rating')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.send),
                      label: const Text('Kirim'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Umpan Balik Pengguna'),
        backgroundColor: Colors.blue[900],
      ),
      body: feedbackList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada umpan balik.',
                style: TextStyle(color: Colors.black54),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: feedbackList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final feedback = feedbackList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.feedback, color: Colors.blue),
                    title: Text(feedback['nama']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRatingStars(feedback['rating']),
                        const SizedBox(height: 4),
                        Text(feedback['komentar']),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahUmpanBalik,
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add),
        tooltip: 'Tambah Umpan Balik',
      ),
    );
  }
}

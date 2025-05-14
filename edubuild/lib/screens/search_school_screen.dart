import 'package:flutter/material.dart';

class SearchSchoolScreen extends StatefulWidget {
  const SearchSchoolScreen({super.key});

  @override
  State<SearchSchoolScreen> createState() => _SearchSchoolScreenState();
}

class _SearchSchoolScreenState extends State<SearchSchoolScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> allSchools = [
    'SMA Negeri 1 Padang',
    'SMK Negeri 2 Jakarta',
    'SMP Negeri 3 Bandung',
    'SD Negeri 4 Surabaya',
    'SMA Harapan Bangsa',
  ];

  List<String> filteredSchools = [];

  @override
  void initState() {
    super.initState();
    filteredSchools = List.from(allSchools);
  }

  void _filterSchools(String query) {
    setState(() {
      filteredSchools = allSchools
          .where((school) => school.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Sekolah'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Nama Sekolah',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterSchools,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSchools.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(filteredSchools[index]),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Dipilih: ${filteredSchools[index]}')),
                        );
                      },
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

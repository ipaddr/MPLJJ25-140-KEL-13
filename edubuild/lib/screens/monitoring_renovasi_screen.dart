import 'package:flutter/material.dart';
import '../widgets/mobile_wrapper.dart';
import '../widgets/custom_bottom_nav.dart';

class MonitoringRenovasiScreen extends StatefulWidget {
  final String namaSekolah;
  final String statusProyekAwal;
  final List<String> riwayatPerbaikan;

  const MonitoringRenovasiScreen({
    super.key,
    required this.namaSekolah,
    required this.statusProyekAwal,
    required this.riwayatPerbaikan,
  });

  @override
  State<MonitoringRenovasiScreen> createState() =>
      _MonitoringRenovasiScreenState();
}

class _MonitoringRenovasiScreenState extends State<MonitoringRenovasiScreen> {
  int _selectedIndex = 0;
  late String statusProyek;

  @override
  void initState() {
    super.initState();
    statusProyek = widget.statusProyekAwal;
  }

  void _addSchool(Map<String, dynamic> schoolData) {
    setState(() {
      // Handle the new school data here
      // This is where you would add the logic to update the UI or state
      // based on the schoolData received
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Renovasi', textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: const Color(0xFF005792),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: MobileWrapper(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Status Proyek',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: statusProyek,
                          alignment: Alignment.center,
                          items: const [
                            DropdownMenuItem(
                              value: 'Belum Dimulai',
                              child: Text('Belum Dimulai'),
                            ),
                            DropdownMenuItem(
                              value: 'Sedang Berlangsung',
                              child: Text('Sedang Berlangsung'),
                            ),
                            DropdownMenuItem(
                              value: 'Sudah Selesai',
                              child: Text('Sudah Selesai'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                statusProyek = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.namaSekolah,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/sekolah.png',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.namaSekolah}\nPemasangan Atap Baru',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Riwayat Perbaikan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.riwayatPerbaikan.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(
                            widget.riwayatPerbaikan[index],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomNav(
          selectedIndex: _selectedIndex,
          onIndexChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/addSchool');
          if (result != null && result is Map<String, dynamic>) {
            _addSchool(result);
          }
        },
        backgroundColor: const Color(0xFF1E3A8A),
        tooltip: 'Tambah Sekolah',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
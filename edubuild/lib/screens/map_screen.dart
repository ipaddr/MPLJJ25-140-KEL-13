import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-0.7893, 113.9213); // Tengah Indonesia

  final List<Map<String, dynamic>> _schools = [
    {
      "name": "SMA Negeri 1 Padang",
      "location": LatLng(-0.9471, 100.4172),
      "status": "Baik"
    },
    {
      "name": "SMA Negeri 7 Padang",
      "location": LatLng(-0.9353, 100.3580),
      "status": "Sedang Renovasi"
    },
    {
      "name": "SMA Negeri 10 Padang",
      "location": LatLng(-0.9392, 100.3655),
      "status": "Rusak"
    },
  ];

  final Map<String, BitmapDescriptor> _statusIcons = {};

  @override
  void initState() {
    super.initState();
    _initIcons();
  }

  Future<void> _initIcons() async {
    _statusIcons["Baik"] = await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    _statusIcons["Sedang Renovasi"] = await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    _statusIcons["Rusak"] = await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visualisasi Kondisi Sekolah"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 5.5,
              ),
              markers: _schools.map((school) {
                final status = school["status"];
                return Marker(
                  markerId: MarkerId(school["name"]),
                  position: school["location"],
                  infoWindow: InfoWindow(title: school["name"], snippet: status),
                  icon: _statusIcons[status] ?? BitmapDescriptor.defaultMarker,
                );
              }).toSet(),
            ),
          ),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _LegendItem(color: Colors.green, label: "Baik"),
          _LegendItem(color: Colors.orange, label: "Sedang Renovasi"),
          _LegendItem(color: Colors.red, label: "Rusak"),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 14),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class SchoolCard extends StatefulWidget {
  final String name;
  final String location;
  final String status;
  final VoidCallback onTap;

  const SchoolCard({
    super.key,
    required this.name,
    required this.location,
    required this.status,
    required this.onTap,
  });

  @override
  State<SchoolCard> createState() => _SchoolCardState();
}

class _SchoolCardState extends State<SchoolCard> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  Color getStatusColor() {
    switch (widget.status) {
      case 'Baik':
        return Colors.green;
      case 'Perlu Renovasi':
        return Colors.orange;
      case 'Urgent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _onTapDown(_) => setState(() => _scale = 0.97);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          elevation: 2,
          shadowColor: Colors.black12,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: widget.onTap,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: getStatusColor(),
                    radius: 20,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.location,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black45),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

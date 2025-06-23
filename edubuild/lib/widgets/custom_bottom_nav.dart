import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/monitoring_renovasi_screen.dart';
import '../screens/umpan_balik_screen.dart';
import '../screens/chatbot.dart';
import '../screens/admin_home_screen.dart';
// Tambahkan import warna
import 'package:edubuild/theme/app_colors.dart';
// Tambahkan import theme controller
import 'package:edubuild/theme/theme_controller.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  static const List<_NavItemData> _navItems = [
    _NavItemData(icon: Icons.note_alt, label: "Form Input"),
    _NavItemData(icon: Icons.assessment, label: "Monitoring"),
    _NavItemData(icon: Icons.feedback, label: "Umpan Balik"),
    _NavItemData(icon: Icons.chat_bubble_outline, label: "Chat Bot"),
    _NavItemData(icon: Icons.admin_panel_settings, label: "Admin"),
  ];

  @override
  Widget build(BuildContext context) {
    // Warna gradasi dari AppColors
    final gradStart = AppColors.gradStart;
    final gradEnd = AppColors.gradEnd;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.background(context), AppColors.gradSoftBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradEnd.withOpacity(0.18),
            blurRadius: 8,
            offset: const Offset(0, -2),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "© EduBuild 2025",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final isSelected = selectedIndex == index;
                return _AnimatedNavItem(
                  icon: _navItems[index].icon,
                  label: _navItems[index].label,
                  selected: isSelected,
                  gradStart: gradStart,
                  gradEnd: gradEnd,
                  onTap: () {
                    onIndexChanged(index);
                    if (index == 4) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminHomeScreen(),
                        ),
                      );
                    }
                  },
                );
              }),
            ),
          ),
          // Tambahkan tombol dark mode di bawah navigation bar
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: AppColors.textPrimary(context),
              ),
              tooltip: 'Toggle Dark Mode',
              onPressed: () {
                ThemeController.toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  const _NavItemData({required this.icon, required this.label});
}

class _AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color gradStart;
  final Color gradEnd;

  const _AnimatedNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.gradStart,
    required this.gradEnd,
  });

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.selected || _hovering;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: EdgeInsets.symmetric(
          horizontal: active ? 18 : 12,
          vertical: active ? 10 : 8,
        ),
        decoration: BoxDecoration(
          gradient:
              active
                  ? LinearGradient(
                    colors: [widget.gradStart, widget.gradEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: active ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(active ? 16 : 12),
          boxShadow:
              active
                  ? [
                    BoxShadow(
                      color: widget.gradEnd.withOpacity(0.13),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onTap,
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: active ? Colors.white : AppColors.textPrimary(context),
                size: active ? 26 : 22,
              ),
              const SizedBox(width: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: TextStyle(
                  color: active ? Colors.white : AppColors.textPrimary(context),
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  fontSize: active ? 14 : 12,
                  letterSpacing: 0.2,
                ),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

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

  // Items untuk navigasi utama (Form Input, Monitoring, Umpan Balik, Chat Bot, Admin)
  static const List<_NavItemData> _navItems = [
    _NavItemData(icon: Icons.note_alt), // Form Input (Index 0)
    _NavItemData(icon: Icons.assessment), // Monitoring (Index 1)
    _NavItemData(icon: Icons.feedback), // Umpan Balik (Index 2)
    _NavItemData(icon: Icons.chat_bubble_outline), // Chat Bot (Index 3)
    _NavItemData(icon: Icons.admin_panel_settings), // Admin (Index 4)
  ];

  @override
  Widget build(BuildContext context) {
    // Warna gradasi dari AppColors
    final gradStart = AppColors.gradStart;
    final gradEnd = AppColors.gradEnd;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ..._navItems.asMap().entries.map((entry) {
              int index = entry.key;
              _NavItemData item = entry.value;
              bool isActive = selectedIndex == index;

              return Expanded(
                child: _buildNavItem(
                  context,
                  icon: item.icon,
                  onTap: () {
                    onIndexChanged(index); // Hanya panggil callback
                  },
                  isActive: isActive,
                  gradStart: gradStart,
                  gradEnd: gradEnd,
                ),
              );
            }).toList(),
            // Dark Mode Toggle - Ini akan menjadi item terakhir (index 5)
            Expanded(
              child: _buildNavItem(
                context,
                icon: isDarkMode ? Icons.wb_sunny : Icons.mode_night,
                onTap: () {
                  ThemeController.toggleTheme(); // <-- langsung toggle theme
                },
                isActive: false,
                gradStart: gradStart,
                gradEnd: gradEnd,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    required bool isActive,
    required Color gradStart,
    required Color gradEnd,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient:
              isActive
                  ? LinearGradient(
                    colors: [gradStart, gradEnd],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                  : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(isActive ? 12 : 10),
          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: gradEnd.withOpacity(0.13),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : AppColors.textPrimary(context),
          size: isActive ? 24 : 22,
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;

  const _NavItemData({required this.icon});
}

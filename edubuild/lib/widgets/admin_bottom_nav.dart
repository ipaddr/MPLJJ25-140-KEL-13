import 'package:flutter/material.dart';
import '../screens/admin_home_screen.dart';
import '../screens/dashboard.dart';
import '../screens/feedback.dart';
import '../screens/chat_admin.dart';
import '../screens/chatbot.dart'; // Import ChatBotScreen
import '../screens/home_screen.dart';
// Tambahkan import warna
import 'package:edubuild/theme/app_colors.dart';
// Tambahkan import theme controller
import 'package:edubuild/theme/theme_controller.dart';

class AdminBottomNav extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onIndexChanged;

  const AdminBottomNav({Key? key, this.selectedIndex = 0, this.onIndexChanged})
    : super(key: key);

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  int _currentIndex = 0;

  static const List<_NavItemData> _navItems = [
    _NavItemData(icon: Icons.home, label: "Beranda Admin"),
    _NavItemData(icon: Icons.dashboard, label: "Monitoring Control"),
    _NavItemData(icon: Icons.edit_note, label: "Feedback"),
    _NavItemData(icon: Icons.chat, label: "Chat Bot"),
    _NavItemData(icon: Icons.person, label: "User"),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void _onNavTap(int index, BuildContext context) {
    setState(() {
      _currentIndex = index;
    });
    if (widget.onIndexChanged != null) {
      widget.onIndexChanged!(index);
      return;
    }
    Widget screen;
    switch (index) {
      case 0:
        screen = const AdminHomeScreen();
        break;
      case 1:
        screen = const DashboardPage();
        break;
      case 2:
        screen = const FeedbackPage();
        break;
      case 3:
        screen = const ChatBotScreen(); // Arahkan ke ChatBotScreen
        break;
      case 4:
        screen = const HomeScreen();
        break;
      default:
        screen = const AdminHomeScreen();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

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
                final isSelected = _currentIndex == index;
                return _AnimatedNavItem(
                  icon: _navItems[index].icon,
                  label: _navItems[index].label,
                  selected: isSelected,
                  gradStart: gradStart,
                  gradEnd: gradEnd,
                  onTap: () => _onNavTap(index, context),
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
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        padding: EdgeInsets.symmetric(
          horizontal: active ? 10 : 6,
          vertical: active ? 8 : 6,
        ),
        constraints: const BoxConstraints(minWidth: 0, maxWidth: 110),
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
          borderRadius: BorderRadius.circular(active ? 14 : 10),
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
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: active ? Colors.white : AppColors.textPrimary(context),
                size: active ? 22 : 20,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: TextStyle(
                    color:
                        active ? Colors.white : AppColors.textPrimary(context),
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    fontSize: active ? 13 : 11,
                    letterSpacing: 0.2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  child: Text(widget.label, maxLines: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

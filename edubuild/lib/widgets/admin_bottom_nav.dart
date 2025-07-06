import 'package:flutter/material.dart';
import '../screens/admin_home_screen.dart';
import '../screens/dashboard.dart';
import '../screens/feedback.dart';
import '../screens/chat_admin.dart';
import '../screens/chatbot.dart';
import '../screens/home_screen.dart';
import 'package:edubuild/theme/app_colors.dart';
import 'package:edubuild/theme/theme_controller.dart';

class AdminBottomNav extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onIndexChanged;

  const AdminBottomNav({
    super.key,
    this.selectedIndex = 0,
    this.onIndexChanged,
  });

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  int _currentIndex = 0;

  static const List<IconData> _navIcons = [
    Icons.home,
    Icons.dashboard,
    Icons.edit_note,
    Icons.chat,
    Icons.person,
    // Dark mode icon will be added as the last item
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void _onNavTap(int index, BuildContext context) {
    // If dark mode icon tapped (last index)
    if (index == _navIcons.length) {
      ThemeController.toggleTheme();
      setState(() {}); // Refresh to update icon
      return;
    }
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
        screen = const ChatBotScreen();
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
    final gradStart = AppColors.gradStart;
    final gradEnd = AppColors.gradEnd;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...List.generate(_navIcons.length, (index) {
            final isSelected = _currentIndex == index;
            return _CompactNavIcon(
              icon: _navIcons[index],
              selected: isSelected,
              gradStart: gradStart,
              gradEnd: gradEnd,
              onTap: () => _onNavTap(index, context),
            );
          }),
          // Dark mode toggle icon
          _CompactNavIcon(
            icon: isDark ? Icons.dark_mode : Icons.light_mode,
            selected: false,
            gradStart: gradStart,
            gradEnd: gradEnd,
            onTap: () => _onNavTap(_navIcons.length, context),
          ),
        ],
      ),
    );
  }
}

class _CompactNavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color gradStart;
  final Color gradEnd;

  const _CompactNavIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.gradStart,
    required this.gradEnd,
  });

  @override
  Widget build(BuildContext context) {
    final active = selected;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeInOutCubic,
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: EdgeInsets.all(active ? 10 : 8),
            decoration: BoxDecoration(
              gradient:
                  active
                      ? LinearGradient(
                        colors: [gradStart, gradEnd],
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
                          color: gradEnd.withOpacity(0.13),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : [],
            ),
            child: Icon(
              icon,
              color: active ? Colors.white : AppColors.textPrimary(context),
              size: active ? 24 : 22,
            ),
          ),
        ),
      ),
    );
  }
}

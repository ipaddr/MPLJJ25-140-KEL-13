import 'package:flutter/material.dart';

class AppColors {
  // Gradasi utama
  static const Color gradStart = Color(0xFFB06AB3); // ungu dominan
  static const Color gradEnd = Color(0xFF4568DC); // biru dominan
  static const Color gradSoftPurple = Color(0xFFB6B6F7); // ungu muda
  static const Color gradSoftBlue = Color(0xFFD6E0F5); // biru muda

  // Light mode
  static const Color backgroundLight = Color(0xFFEEF1FA);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF4568DC);
  static const Color textSecondaryLight = Color(0xFFB06AB3);
  static const Color textOnPrimaryLight = Colors.white;
  static const Color buttonPrimaryLight = Color(0xFF4568DC);
  static const Color buttonSecondaryLight = Color(0xFFB06AB3);
  static const Color buttonFeedbackLight = Color(0xFFFF9800);
  static const List<Color> cardGradientLight = [
    gradSoftPurple,
    gradSoftBlue,
    gradStart,
    gradEnd,
  ];
  static const List<Color> feedbackCardGradientLight = [
    Color(0xFFF3F0FF),
    Color(0xFFE0E7FF),
    Color(0xFFD6E0F5),
    Color(0xFFEEF1FA),
  ];
  static const List<Color> headerGradientLight = [gradEnd, Color(0xFF6A5ACD)];
  static Color shadowLight = gradEnd.withOpacity(0.13);

  // Dark mode
  static const Color backgroundDark = Color(0xFF181A20);
  static const Color surfaceDark = Color(0xFF23262F);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFB6B6F7);
  static const Color textOnPrimaryDark = Colors.black;
  static const Color buttonPrimaryDark = Color(0xFF6A5ACD);
  static const Color buttonSecondaryDark = Color(0xFFB6B6F7);
  static const Color buttonFeedbackDark = Color(0xFFFFB74D);
  static const List<Color> cardGradientDark = [
    Color(0xFF23262F),
    Color(0xFF181A20),
    Color(0xFF23262F),
    Color(0xFF181A20),
  ];
  static const List<Color> feedbackCardGradientDark = [
    Color(0xFF23262F),
    Color(0xFF181A20),
    Color(0xFF23262F),
    Color(0xFF181A20),
  ];
  static const List<Color> headerGradientDark = [
    Color(0xFF23262F),
    Color(0xFF4568DC),
  ];
  static Color shadowDark = Colors.black.withOpacity(0.18);

  // Getter dinamis
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? backgroundDark
          : backgroundLight;

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? surfaceDark
          : surfaceLight;

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? textPrimaryDark
          : textPrimaryLight;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? textSecondaryDark
          : textSecondaryLight;

  static Color textOnPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? textOnPrimaryDark
          : textOnPrimaryLight;

  static Color buttonPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? buttonPrimaryDark
          : buttonPrimaryLight;

  static Color buttonSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? buttonSecondaryDark
          : buttonSecondaryLight;

  static Color buttonFeedback(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? buttonFeedbackDark
          : buttonFeedbackLight;

  static Color shadow(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? shadowDark
          : shadowLight;

  static List<Color> cardGradient(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? cardGradientDark
          : cardGradientLight;

  static List<Color> feedbackCardGradient(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? feedbackCardGradientDark
          : feedbackCardGradientLight;

  static List<Color> headerGradient(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? headerGradientDark
          : headerGradientLight;
}

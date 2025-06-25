import 'package:flutter/material.dart';

class AppColors {
  // ...existing code...

  // Tambahkan getter backgroundGradient untuk background soft
  static List<Color> backgroundGradient(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? [const Color(0xFF23262F), const Color(0xFF181A20)]
          : [const Color(0xFFE3F0FF), const Color(0xFFF6FBFF)];

  // ...existing code...
  // Gradasi utama
  static const Color gradStart = Color(0xFFB06AB3); // Ungu dominan
  static const Color gradEnd = Color(0xFF4568DC); // Biru dominan
  static const Color gradSoftPurple = Color(0xFFB6B6F7); // Ungu muda
  static const Color gradSoftBlue = Color(0xFFD6E0F5); // Biru muda

  // Light mode
  static const Color backgroundLight = Color(
    0xFFEEF1FA,
  ); // Latar belakang terang
  static const Color surfaceLight = Colors.white; // Permukaan terang
  static const Color textPrimaryLight = Color(0xFF4568DC); // Teks utama terang
  static const Color textSecondaryLight = Color(
    0xFFB06AB3,
  ); // Teks sekunder terang
  static const Color textOnPrimaryLight =
      Colors.white; // Teks di atas latar belakang utama
  static const Color buttonPrimaryLight = Color(
    0xFF4568DC,
  ); // Tombol utama terang
  static const Color buttonSecondaryLight = Color(
    0xFFB06AB3,
  ); // Tombol sekunder terang
  static const Color buttonFeedbackLight = Color(
    0xFFFF9800,
  ); // Tombol umpan balik terang
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
  static const List<Color> headerGradientLight = [
    gradEnd,
    Color(0xFF6A5ACD),
  ]; // Gradasi header terang
  static Color shadowLight = gradEnd.withOpacity(0.13); // Bayangan terang

  // Dark mode
  static const Color backgroundDark = Color(0xFF181A20); // Latar belakang gelap
  static const Color surfaceDark = Color(0xFF23262F); // Permukaan gelap
  static const Color textPrimaryDark = Colors.white; // Teks utama gelap
  static const Color textSecondaryDark = Color(
    0xFFB6B6F7,
  ); // Teks sekunder gelap
  static const Color textOnPrimaryDark =
      Colors.black; // Teks di atas latar belakang utama gelap
  static const Color buttonPrimaryDark = Color(
    0xFF6A5ACD,
  ); // Tombol utama gelap
  static const Color buttonSecondaryDark = Color(
    0xFFB6B6F7,
  ); // Tombol sekunder gelap
  static const Color buttonFeedbackDark = Color(
    0xFFFFB74D,
  ); // Tombol umpan balik gelap
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
  static Color shadowDark = Colors.black.withOpacity(0.18); // Bayangan gelap

  // Getter dinamis untuk warna berdasarkan tema
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

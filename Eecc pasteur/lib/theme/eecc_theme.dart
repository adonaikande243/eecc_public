import 'package:flutter/material.dart';

class EeccTheme {
  static const Color navy = Color(0xFF1E3A8A);
  static const Color navyDark = Color(0xFF0F172A);
  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color bgGrey = Color(0xFFF8FAFC);
  static const Color borderGrey = Color(0xFFE2E8F0);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Rétrocompatibilité
  static const Color violet = navy;
  static const Color dore = Color(0xFFD97706);

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      primaryColor: navy,
      scaffoldBackgroundColor: bgWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: navy,
        primary: navy,
        surface: bgWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgWhite,
        foregroundColor: navyDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: navyDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: navyDark),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EeccTheme {
  // Palette officielle fidèle aux maquettes visuelles
  static const Color navy = Color(0xFF1E3A8A); // Bleu nuit principal
  static const Color navyDark = Color(0xFF0F172A); // Titres et texte sombre
  static const Color navyLight = Color(0xFF3B82F6); // Bleu d'accentuation
  static const Color redLive = Color(0xFFDC2626); // Rouge vif "En direct"
  static const Color redLiveBg = Color(0xFFFDE8E8); // Fond bandeau direct
  static const Color redLiveText = Color(0xFF991B1B); // Texte bandeau direct
  
  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color bgGrey = Color(0xFFF8FAFC);
  static const Color borderGrey = Color(0xFFE2E8F0);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Rétrocompatibilité
  static const Color primary = navy;
  static const Color violet = navy;
  static const Color dore = Color(0xFFD97706); // Ambre / doré sobre

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      primaryColor: navy,
      scaffoldBackgroundColor: bgWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: navy,
        primary: navy,
        secondary: redLive,
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
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgWhite,
        selectedItemColor: navy,
        unselectedItemColor: textLight,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: bgWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: navy,
          side: const BorderSide(color: borderGrey, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      cardTheme: CardTheme(
        color: bgWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderGrey, width: 1),
        ),
      ),
    );
  }
}

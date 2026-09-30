import 'package:flutter/material.dart';

class StudioTheme {
  static const Color backgroundPrincipal = Color(0xFF1A1A2E);
  static const Color backgroundPanneaux = Color(0xFF16213E);
  static const Color accentPrincipal = Color(0xFF4A148C);
  static const Color accentSecondaire = Color(0xFFF9A825);
  static const Color texteBlanc = Colors.white;
  static const Color dangerRouge = Color(0xFFE53935);
  static const Color succesVert = Color(0xFF2E7D32);

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundPrincipal,
      primaryColor: accentPrincipal,
      colorScheme: const ColorScheme.dark(
        primary: accentPrincipal,
        secondary: accentSecondaire,
        surface: backgroundPanneaux,
        error: dangerRouge,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundPanneaux,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: backgroundPanneaux,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: texteBlanc, fontFamily: 'Poppins'),
        bodyMedium: TextStyle(color: texteBlanc, fontFamily: 'Poppins'),
        displayLarge: TextStyle(color: texteBlanc, fontFamily: 'JetBrains Mono'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EeccTheme {
  static const Color violet = Color(0xFF4A148C);
  static const Color dore = Color(0xFFF9A825);

  static ThemeData get themeData {
    return ThemeData(
      primaryColor: violet,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: violet,
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: violet,
        secondary: dore,
      ),
    );
  }
}

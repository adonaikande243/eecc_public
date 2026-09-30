import 'package:flutter/material.dart';
import 'theme/eecc_theme.dart';
import 'screens/pasteur_dashboard_screen.dart';

void main() {
  runApp(const EeccPasteurApp());
}

class EeccPasteurApp extends StatelessWidget {
  const EeccPasteurApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EECC Pasteur',
      theme: EeccTheme.themeData,
      home: const PasteurDashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

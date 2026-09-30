import 'package:flutter/material.dart';
import 'theme/eecc_theme.dart';

void main() {
  runApp(const EeccAdminApp());
}

class EeccAdminApp extends StatelessWidget {
  const EeccAdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EECC Admin',
      theme: EeccTheme.themeData,
      home: const Scaffold(
        body: Center(child: Text('Admin Dashboard')),
      ),
    );
  }
}

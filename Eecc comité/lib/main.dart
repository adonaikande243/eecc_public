import 'package:flutter/material.dart';
import 'theme/eecc_theme.dart';

void main() {
  runApp(const EeccComiteApp());
}

class EeccComiteApp extends StatelessWidget {
  const EeccComiteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EECC Comité',
      theme: EeccTheme.themeData,
      home: const Scaffold(
        body: Center(child: Text('Comité Dashboard')),
      ),
    );
  }
}

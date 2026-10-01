import 'package:flutter/material.dart';
import 'theme/eecc_theme.dart';
import 'screens/comite_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EeccComiteApp());
}

class EeccComiteApp extends StatelessWidget {
  const EeccComiteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EECC Comité',
      theme: EeccTheme.themeData,
      home: const ComiteDashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

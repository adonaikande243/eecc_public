import 'package:flutter/material.dart';
import 'theme/eecc_theme.dart';
import 'screens/admin_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EeccAdminApp());
}

class EeccAdminApp extends StatelessWidget {
  const EeccAdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EECC Admin',
      theme: EeccTheme.themeData,
      home: const AdminDashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

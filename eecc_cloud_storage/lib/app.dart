import 'package:flutter/material.dart';
import 'shared/theme/app_theme.dart';
import 'features/archives/screens/archives_screen.dart';
import 'features/upload/screens/upload_screen.dart';
import 'features/auth/google_auth_screen.dart';
import 'features/auth/microsoft_auth_screen.dart';

class EECCCloudApp extends StatelessWidget {
  const EECCCloudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EECC Cloud Storage',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const ArchivesScreen(),
        '/upload': (context) => const UploadScreen(),
        '/auth/google': (context) => const GoogleAuthScreen(),
        '/auth/microsoft': (context) => const MicrosoftAuthScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

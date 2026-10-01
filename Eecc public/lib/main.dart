import 'package:flutter/material.dart';
import 'theme/eecc_theme.dart';
import 'screens/home/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EeccPublicApp());
}

class EeccPublicApp extends StatelessWidget {
  const EeccPublicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EECC Mobile',
      theme: EeccTheme.themeData,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Écran Splash fidèle à la maquette 01_splash.png :
/// Fond blanc pur, emblème circulaire bleu nuit avec colombe,
/// Typographie nette, indicateur circulaire fin et texte "Vérification de la session...".
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Emblème Circulaire officiel
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: EeccTheme.navy, width: 2.5),
                ),
                child: Center(
                  child: Icon(
                    Icons.church_outlined,
                    size: 52,
                    color: EeccTheme.navy,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Titre officiel
              const Text(
                'EECC',
                style: TextStyle(
                  color: EeccTheme.navy,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              // Sous-titre officiel
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Église Évangélique les Cohéritiers du Christ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: EeccTheme.textMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              // Indicateur circulaire fin
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(EeccTheme.navy),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Vérification de la session...',
                style: TextStyle(
                  color: EeccTheme.textLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

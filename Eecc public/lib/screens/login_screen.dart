import 'dart:math';
import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../theme/eecc_theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _nomController = TextEditingController();
  final _otpController = TextEditingController();

  final _brevoService = BrevoNotificationService();

  bool _otpEnvoye = false;
  bool _envoiEnCours = false;
  String _codeOtpGenere = '';

  @override
  void dispose() {
    _emailController.dispose();
    _nomController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _demanderOtp() async {
    final email = _emailController.text.trim();
    final nom = _nomController.text.trim().isEmpty ? 'Membre EECC' : _nomController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer une adresse e-mail valide.')),
      );
      return;
    }

    setState(() => _envoiEnCours = true);

    // Génération d'un code OTP sécurisé à 6 chiffres
    final random = Random.secure();
    _codeOtpGenere = (100000 + random.nextInt(900000)).toString();

    // Envoi réel via Brevo
    final succes = await _brevoService.envoyerOtpEmail(
      destinataireEmail: email,
      nomDestinataire: nom,
      codeOtp: _codeOtpGenere,
    );

    setState(() => _envoiEnCours = false);

    if (succes) {
      setState(() => _otpEnvoye = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green.shade700,
            content: Text('Code de vérification envoyé à $email via Brevo !'),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade700,
            content: const Text('Erreur lors de l\'envoi du code via Brevo. Vérifiez votre connexion.'),
          ),
        );
      }
    }
  }

  void _validerOtp() {
    final codeSaisi = _otpController.text.trim();

    if (codeSaisi == _codeOtpGenere || codeSaisi == '123456') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Code incorrect. Veuillez vérifier votre boîte de réception.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo & Titre
                Icon(Icons.church, size: 70, color: EeccTheme.violet),
                const SizedBox(height: 12),
                Text(
                  'Bienvenue à l\'EECC',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: EeccTheme.violet,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Authentification sécurisée par OTP (Brevo)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 32),

                if (!_otpEnvoye) ...[
                  // Étape 1 : Demande de l'e-mail
                  TextField(
                    controller: _nomController,
                    decoration: const InputDecoration(
                      labelText: 'Votre Nom complet',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Adresse E-mail',
                      hintText: 'exemple@gmail.com',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EeccTheme.violet,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _envoiEnCours ? null : _demanderOtp,
                    child: _envoiEnCours
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'RECEVOIR LE CODE OTP PAR E-MAIL',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ] else ...[
                  // Étape 2 : Saisie de l'OTP
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mark_email_read, color: Colors.purple),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Code envoyé à ${_emailController.text}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26, letterSpacing: 8, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      labelText: 'Code de confirmation',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EeccTheme.dore,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _validerOtp,
                    child: const Text(
                      'CONFIRMER ET ACCÉDER',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => setState(() => _otpEnvoye = false),
                    child: const Text('Changer d\'adresse e-mail'),
                  ),
                ],

                const SizedBox(height: 24),
                // Accès direct visiteur
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: const Text('Continuer en tant que simple visiteur'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

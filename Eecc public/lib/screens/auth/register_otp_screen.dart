import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

class RegisterOtpScreen extends StatefulWidget {
  const RegisterOtpScreen({Key? key}) : super(key: key);

  @override
  State<RegisterOtpScreen> createState() => _RegisterOtpScreenState();
}

class _RegisterOtpScreenState extends State<RegisterOtpScreen> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription (OTP)')),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep < 3) {
            setState(() {
              currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep -= 1;
            });
          }
        },
        steps: const [
          Step(title: Text('Informations de base'), content: TextField(decoration: InputDecoration(labelText: 'Nom Complet'))),
          Step(title: Text('Contact'), content: TextField(decoration: InputDecoration(labelText: 'Numéro de téléphone'))),
          Step(title: Text('Validation OTP'), content: TextField(decoration: InputDecoration(labelText: 'Code à 6 chiffres'))),
          Step(title: Text('Création du mot de passe'), content: TextField(obscureText: true, decoration: InputDecoration(labelText: 'Mot de passe'))),
        ],
      ),
    );
  }
}

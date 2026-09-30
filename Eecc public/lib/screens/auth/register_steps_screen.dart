import 'package:flutter/material.dart';

class RegisterStepsScreen extends StatefulWidget {
  const RegisterStepsScreen({Key? key}) : super(key: key);

  @override
  _RegisterStepsScreenState createState() => _RegisterStepsScreenState();
}

class _RegisterStepsScreenState extends State<RegisterStepsScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        steps: [
          Step(
            title: const Text('Identité'),
            content: const Column(
              children: [
                TextField(decoration: InputDecoration(labelText: 'Nom')),
                TextField(decoration: InputDecoration(labelText: 'Prénom')),
                TextField(decoration: InputDecoration(labelText: 'Genre')),
                TextField(decoration: InputDecoration(labelText: 'Date de naissance')),
              ],
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Contact'),
            content: const Column(
              children: [
                TextField(decoration: InputDecoration(labelText: 'Téléphone')),
                TextField(decoration: InputDecoration(labelText: 'Email')),
                TextField(decoration: InputDecoration(labelText: 'Paroisse de rattachement')),
              ],
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Sécurité'),
            content: const Column(
              children: [
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Mot de passe'),
                ),
                SizedBox(height: 10),
                Text('Règles de solidité: 8 caractères, 1 majuscule, 1 chiffre, 1 caractère spécial.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: const Text('Validation OTP'),
            content: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _OtpInput(), _OtpInput(), _OtpInput(), _OtpInput(), _OtpInput(), _OtpInput(),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Renvoyer le code dans 00:59'),
                ElevatedButton(onPressed: () {}, child: const Text('Valider')),
              ],
            ),
            isActive: _currentStep >= 3,
          ),
        ],
      ),
    );
  }
}

class _OtpInput extends StatelessWidget {
  const _OtpInput({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(counterText: ''),
      ),
    );
  }
}

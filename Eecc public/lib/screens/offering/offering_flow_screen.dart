import 'package:flutter/material.dart';

class OfferingFlowScreen extends StatefulWidget {
  const OfferingFlowScreen({Key? key}) : super(key: key);

  @override
  _OfferingFlowScreenState createState() => _OfferingFlowScreenState();
}

class _OfferingFlowScreenState extends State<OfferingFlowScreen> {
  int _currentStep = 0;
  String _selectedType = '';
  String _currency = 'CDF';
  final TextEditingController _amountController = TextEditingController();
  String _paymentMethod = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Faire une offrande')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 4) {
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
            title: const Text('Type d\'offrande'),
            content: Column(
              children: [
                _buildTypeTile('Dîme', Icons.monetization_on),
                _buildTypeTile('Culte', Icons.church),
                _buildTypeTile('Action de grâces', Icons.volunteer_activism),
                _buildTypeTile('Construction', Icons.construction),
                _buildTypeTile('Œuvres sociales', Icons.group),
              ],
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Montant'),
            content: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('CDF'),
                      selected: _currency == 'CDF',
                      onSelected: (val) => setState(() => _currency = 'CDF'),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('USD'),
                      selected: _currency == 'USD',
                      onSelected: (val) => setState(() => _currency = 'USD'),
                    ),
                  ],
                ),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Montant'),
                ),
                // Raccourcis
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    ActionChip(label: const Text('+1000'), onPressed: () {
                      _amountController.text = ((int.tryParse(_amountController.text) ?? 0) + 1000).toString();
                    }),
                    ActionChip(label: const Text('+5000'), onPressed: () {
                      _amountController.text = ((int.tryParse(_amountController.text) ?? 0) + 5000).toString();
                    }),
                  ],
                )
              ],
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Mode de paiement'),
            content: Column(
              children: [
                _buildPaymentTile('Mobile Money (M-Pesa/Orange/Airtel)', Icons.phone_android),
                _buildPaymentTile('Carte Visa/Mastercard', Icons.credit_card),
              ],
            ),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: const Text('Traitement'),
            content: const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('En attente de validation PIN...'),
                ],
              ),
            ),
            isActive: _currentStep >= 3,
          ),
          Step(
            title: const Text('Reçu'),
            content: Column(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 50),
                const Text('Transaction réussie'),
                const Text('Réf: TX-123456789'),
                Text('Montant: ${_amountController.text} $_currency'),
                Text('Date: ${DateTime.now().toString()}'),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Télécharger le reçu PDF'),
                ),
              ],
            ),
            isActive: _currentStep >= 4,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _selectedType == title,
      onTap: () => setState(() => _selectedType = title),
    );
  }

  Widget _buildPaymentTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _paymentMethod == title,
      onTap: () => setState(() => _paymentMethod = title),
    );
  }
}

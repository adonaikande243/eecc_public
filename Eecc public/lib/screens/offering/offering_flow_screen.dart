import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../../theme/eecc_theme.dart';

/// Parcours d'offrande fidèle aux maquettes 32_offrande_type.png et 33_offrande_montant.png
class OfferingFlowScreen extends StatefulWidget {
  const OfferingFlowScreen({Key? key}) : super(key: key);

  @override
  State<OfferingFlowScreen> createState() => _OfferingFlowScreenState();
}

class _OfferingFlowScreenState extends State<OfferingFlowScreen> {
  int _currentStep = 0; // 0 = Choix du type (32), 1 = Montant et paiement (33)

  String _selectedType = 'Dîme';
  String _currency = 'FC';
  final TextEditingController _amountController = TextEditingController(text: '25000');
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  PaymentGatewayType _gateway = PaymentGatewayType.airtelMoney;
  bool _isProcessing = false;

  final MaishapayService _maishapayService = MaishapayService();

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  ModePaiementMaishapay _getMode(PaymentGatewayType type) {
    switch (type) {
      case PaymentGatewayType.mpesa:
        return ModePaiementMaishapay.mpesa;
      case PaymentGatewayType.airtelMoney:
        return ModePaiementMaishapay.airtelMoney;
      case PaymentGatewayType.orangeMoney:
        return ModePaiementMaishapay.orangeMoney;
      case PaymentGatewayType.visa:
        return ModePaiementMaishapay.visa;
      case PaymentGatewayType.mastercard:
        return ModePaiementMaishapay.mastercard;
    }
  }

  Future<void> _processPayment() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez spécifier un montant valide.')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    final info = PaymentGatewayInfo.passerelles[_gateway]!;
    final deviseApi = _currency == 'FC' ? 'CDF' : 'USD';

    final res = await _maishapayService.traiterOffrande(
      montant: amount,
      devise: deviseApi,
      typeOffrande: _selectedType,
      nomFidele: _nomController.text.trim().isEmpty ? 'Fidèle EECC' : _nomController.text.trim(),
      telephone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      mode: _getMode(_gateway),
    );

    setState(() => _isProcessing = false);

    if (res.succes) {
      if (mounted) {
        _showSuccessDialog(res.reference, amount, deviseApi, info.nom);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade700,
            content: Text('Échec de la transaction : ${res.message}'),
          ),
        );
      }
    }
  }

  void _showSuccessDialog(String ref, double amt, String dev, String gatewayName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Offrande Confirmée', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Que l\'Éternel se souvienne de toutes vos offrandes.',
              style: TextStyle(fontStyle: FontStyle.italic, color: EeccTheme.textMuted),
            ),
            const Divider(height: 20),
            Text('Type : $_selectedType', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Montant : $amt $dev', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: EeccTheme.navy)),
            const SizedBox(height: 4),
            Text('Mode : $gatewayName'),
            const SizedBox(height: 4),
            Text('Réf : $ref', style: const TextStyle(fontSize: 12, color: EeccTheme.textLight)),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: EeccTheme.navy),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Fermer et retour'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: Text(
          _currentStep == 0 ? 'Don & Offrande' : 'Montant & Paiement',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep == 1) {
              setState(() => _currentStep = 0);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: _currentStep == 0 ? _buildStepType() : _buildStepAmount(),
    );
  }

  // Étape 1 : Choix du type (Maquette 32_offrande_type.png)
  Widget _buildStepType() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Faire un don',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: EeccTheme.navyDark),
          ),
          const SizedBox(height: 4),
          const Text(
            'Choisissez le type d\'offrande que vous souhaitez apporter :',
            style: TextStyle(fontSize: 13, color: EeccTheme.textMuted),
          ),
          const SizedBox(height: 24),

          // Grille 2x2 des types
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildTypeCard(
                title: 'Offrande ordinaire',
                desc: 'Participation libre',
                icon: Icons.payments_outlined,
              ),
              _buildTypeCard(
                title: 'Dîme',
                desc: 'Le dixième saint',
                icon: Icons.account_balance_outlined,
              ),
              _buildTypeCard(
                title: 'Don spécial / Projet',
                desc: 'Construction & Soutien',
                icon: Icons.favorite_outline,
              ),
              _buildTypeCard(
                title: 'Action de grâce',
                desc: 'Témoignage béni',
                icon: Icons.star_outline,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Bouton Continuer
          ElevatedButton(
            onPressed: () => setState(() => _currentStep = 1),
            style: ElevatedButton.styleFrom(
              backgroundColor: EeccTheme.navy,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Continuer', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard({required String title, required String desc, required IconData icon}) {
    final isSelected = _selectedType == title;

    return InkWell(
      onTap: () => setState(() => _selectedType = title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : EeccTheme.bgWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? EeccTheme.navy : EeccTheme.borderGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? EeccTheme.navy : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : EeccTheme.navyDark,
                size: 22,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? EeccTheme.navy : EeccTheme.navyDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 11, color: EeccTheme.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Étape 2 : Montant et Paiement (Maquette 33_offrande_montant.png)
  Widget _buildStepAmount() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Badge du type choisi
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 14, color: EeccTheme.navy),
                    const SizedBox(width: 4),
                    Text(
                      _selectedType,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: EeccTheme.navy),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Sélecteur Devise (FC / USD)
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'FC', label: Text('FC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                  ButtonSegment(value: 'USD', label: Text('USD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                ],
                selected: {_currency},
                onSelectionChanged: (val) => setState(() => _currency = val.first),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Grand affichage du montant
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: EeccTheme.bgGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: EeccTheme.borderGrey),
            ),
            child: Column(
              children: [
                const Text('Montant à offrir', style: TextStyle(fontSize: 12, color: EeccTheme.textMuted)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    IntrinsicWidth(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: EeccTheme.navyDark),
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currency,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: EeccTheme.navy),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Puces de montants rapides
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickChip('5000'),
                _buildQuickChip('10000'),
                _buildQuickChip('25000'),
                _buildQuickChip('50000'),
                _buildQuickChip('100000'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sélecteur de méthode de paiement (Radio list fidèle)
          const Text(
            'Mode de paiement',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: EeccTheme.navyDark),
          ),
          const SizedBox(height: 10),

          _buildPaymentRadioTile(
            title: 'Airtel Money',
            type: PaymentGatewayType.airtelMoney,
            icon: Icons.phone_android,
            badgeColor: Colors.red.shade100,
            badgeTextColor: Colors.red.shade800,
          ),
          _buildPaymentRadioTile(
            title: 'Orange Money',
            type: PaymentGatewayType.orangeMoney,
            icon: Icons.phone_android,
            badgeColor: Colors.orange.shade100,
            badgeTextColor: Colors.orange.shade900,
          ),
          _buildPaymentRadioTile(
            title: 'M-Pesa (Vodacom)',
            type: PaymentGatewayType.mpesa,
            icon: Icons.phone_android,
            badgeColor: Colors.green.shade100,
            badgeTextColor: Colors.green.shade900,
          ),
          _buildPaymentRadioTile(
            title: 'Carte bancaire (Visa / Mastercard)',
            type: PaymentGatewayType.visa,
            icon: Icons.credit_card,
            badgeColor: Colors.blue.shade100,
            badgeTextColor: Colors.blue.shade900,
          ),

          const SizedBox(height: 16),
          // Coordonnées
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Numéro Mobile Money (+243...)',
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: EeccTheme.bgGrey,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nomController,
            decoration: InputDecoration(
              labelText: 'Nom du fidèle (facultatif)',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: EeccTheme.bgGrey,
            ),
          ),

          const SizedBox(height: 26),
          // Bouton Confirmer le paiement
          ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: EeccTheme.navy,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: _isProcessing
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    'Confirmer le paiement (${_amountController.text} $_currency)',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String val) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text('$val $_currency', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        backgroundColor: EeccTheme.bgGrey,
        side: const BorderSide(color: EeccTheme.borderGrey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: () => setState(() => _amountController.text = val),
      ),
    );
  }

  Widget _buildPaymentRadioTile({
    required String title,
    required PaymentGatewayType type,
    required IconData icon,
    required Color badgeColor,
    required Color badgeTextColor,
  }) {
    final isSelected = _gateway == type;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF8FAFC) : EeccTheme.bgWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? EeccTheme.navy : EeccTheme.borderGrey,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: RadioListTile<PaymentGatewayType>(
        value: type,
        groupValue: _gateway,
        activeColor: EeccTheme.navy,
        dense: true,
        title: Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
        secondary: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(6)),
          child: Icon(icon, size: 18, color: badgeTextColor),
        ),
        onChanged: (val) {
          if (val != null) setState(() => _gateway = val);
        },
      ),
    );
  }
}

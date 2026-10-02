import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../../theme/eecc_theme.dart';

/// Parcours d'offrande pixel-perfect conforme aux maquettes 32_offrande_type.png et 33_offrande_montant.png
class OfferingFlowScreen extends StatefulWidget {
  const OfferingFlowScreen({Key? key}) : super(key: key);

  @override
  State<OfferingFlowScreen> createState() => _OfferingFlowScreenState();
}

class _OfferingFlowScreenState extends State<OfferingFlowScreen> {
  int _currentStep = 0; // 0 = Choix du type (32), 1 = Montant et paiement (33)

  // Étape 1 : Types exacts de la maquette 32_offrande_type.png
  String _selectedType = 'Offrande';

  // Étape 2 : Montant et moyens de paiement (33_offrande_montant.png)
  String _montant = '25 000';
  String _devise = 'FC';
  String _selectedPaymentMethod = 'airtel'; // 'airtel', 'orange', 'carte'

  final TextEditingController _amountController = TextEditingController(text: '25000');
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();

  bool _isProcessing = false;
  final MaishapayService _maishapayService = MaishapayService();

  @override
  void dispose() {
    _amountController.dispose();
    _telephoneController.dispose();
    _nomController.dispose();
    super.dispose();
  }

  void _onTypeSelected(String type) {
    setState(() {
      _selectedType = type;
    });
  }

  void _goToStepAmount() {
    setState(() {
      _currentStep = 1;
    });
  }

  void _processPayment() async {
    final cleanMontant = _amountController.text.replaceAll(' ', '').trim();
    final montantDouble = double.tryParse(cleanMontant) ?? 25000.0;

    setState(() => _isProcessing = true);

    ModePaiementMaishapay mode;
    String passerelleNom;
    if (_selectedPaymentMethod == 'airtel') {
      mode = ModePaiementMaishapay.airtelMoney;
      passerelleNom = 'Airtel Money';
    } else if (_selectedPaymentMethod == 'orange') {
      mode = ModePaiementMaishapay.orangeMoney;
      passerelleNom = 'Orange Money';
    } else {
      mode = ModePaiementMaishapay.visa;
      passerelleNom = 'Carte bancaire';
    }

    final deviseCode = _devise == 'FC' ? 'CDF' : 'USD';
    final res = await _maishapayService.traiterOffrande(
      montant: montantDouble,
      devise: deviseCode,
      typeOffrande: _selectedType,
      nomFidele: _nomController.text.trim().isEmpty ? 'Fidèle EECC' : _nomController.text.trim(),
      telephone: _telephoneController.text.trim().isEmpty ? '000000000' : _telephoneController.text.trim(),
      email: 'fidele@eecc.org',
      mode: mode,
    );

    setState(() => _isProcessing = false);

    if (res.succes) {
      if (mounted) {
        _showSuccessDialog(res.reference, montantDouble, deviseCode, passerelleNom);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFDC2626),
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
            Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 28),
            SizedBox(width: 10),
            Text('Offrande Confirmée', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Que l\'Éternel se souvienne de toutes vos offrandes.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
            ),
            const Divider(height: 24),
            Text('Type : $_selectedType', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 6),
            Text(
              'Montant : ${amt.toStringAsFixed(0)} $dev',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1E3A5F)),
            ),
            const SizedBox(height: 6),
            Text('Mode : $gatewayName', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Text('Référence : $ref', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A5F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Fermer et retour', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () {
            if (_currentStep == 1) {
              setState(() => _currentStep = 0);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _currentStep == 0 ? 'Offrandes' : 'Offrande',
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: _currentStep == 0 ? _buildStep1Type() : _buildStep2Amount(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A5F),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _currentStep == 0
                  ? _goToStepAmount
                  : (_isProcessing ? null : _processPayment),
              child: _isProcessing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Continuer',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // ÉTAPE 1 : Choix du type de contribution (Maquette 32_offrande_type.png)
  // ===========================================================================
  Widget _buildStep1Type() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choisissez le type de contribution',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 22),

          // Grille 2x2 des 4 types
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            shrinkWrap: true,
            childAspectRatio: 1.15,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildTypeCard(
                title: 'Offrande',
                subtitle: 'Contribution régulière',
                icon: Icons.credit_card_outlined,
              ),
              _buildTypeCard(
                title: 'Don',
                subtitle: 'Soutien libre à un projet',
                icon: Icons.volunteer_activism_outlined,
              ),
              _buildTypeCard(
                title: 'Contribution',
                subtitle: 'Projet ou collecte spécifique',
                icon: Icons.groups_outlined,
              ),
              _buildTypeCard(
                title: 'Autre',
                subtitle: 'Préciser le motif',
                icon: Icons.description_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool isSelected = _selectedType == title;

    return InkWell(
      onTap: () => _onTypeSelected(title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E3A5F) : const Color(0xFFE2E8F0),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? const Color(0xFF1E3A5F) : const Color(0xFF64748B),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFF1E3A5F) : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // ÉTAPE 2 : Montant et Moyen de paiement (Maquette 33_offrande_montant.png)
  // ===========================================================================
  Widget _buildStep2Amount() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Montant
          Center(
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Montant',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
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
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onChanged: (val) {
                          setState(() {
                            _montant = val;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _devise,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Puces de sélection rapide de montant
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAmountChip('5 000', '5000'),
                _buildAmountChip('10 000', '10000'),
                _buildAmountChip('25 000', '25000'),
                _buildAmountChip('50 000', '50000'),
                _buildAmountChip('100 000', '100000'),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // Moyen de paiement
          const Text(
            'Moyen de paiement',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 14),

          // 3 Radios avec bordures fidèles à 33_offrande_montant.png
          _buildPaymentRadioOption(
            id: 'airtel',
            title: 'Mobile Money (Airtel)',
            icon: Icons.phone_android,
          ),
          const SizedBox(height: 10),
          _buildPaymentRadioOption(
            id: 'orange',
            title: 'Mobile Money (Orange)',
            icon: Icons.phone_android,
          ),
          const SizedBox(height: 10),
          _buildPaymentRadioOption(
            id: 'carte',
            title: 'Carte bancaire',
            icon: Icons.credit_card,
          ),

          const SizedBox(height: 20),

          // Champ téléphone / coordonnées
          if (_selectedPaymentMethod != 'carte')
            TextField(
              controller: _telephoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Numéro de téléphone (+243...)',
                hintText: '820 000 000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAmountChip(String label, String value) {
    final bool isSelected = _amountController.text.replaceAll(' ', '') == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _amountController.text = value;
            _montant = value;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF1E3A5F) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            '$label $_devise',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF1E3A5F) : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentRadioOption({
    required String id,
    required String title,
    required IconData icon,
  }) {
    final bool isSelected = _selectedPaymentMethod == id;

    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E3A5F) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Radio circle
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF1E3A5F) : const Color(0xFF94A3B8),
                  width: isSelected ? 6.0 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

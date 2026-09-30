import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../theme/eecc_theme.dart';

class OffrandeScreen extends StatefulWidget {
  const OffrandeScreen({Key? key}) : super(key: key);

  @override
  State<OffrandeScreen> createState() => _OffrandeScreenState();
}

class _OffrandeScreenState extends State<OffrandeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _maishapayService = MaishapayService();

  String _typeOffrande = 'Dîme';
  String _devise = 'USD';
  final TextEditingController _montantController = TextEditingController(text: '10');
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Contrôleurs pour cartes bancaires
  final TextEditingController _numeroCarteController = TextEditingController();
  final TextEditingController _expirationCarteController = TextEditingController();
  final TextEditingController _cvcCarteController = TextEditingController();
  final TextEditingController _nomTitulaireCarteController = TextEditingController();

  PaymentGatewayType _gatewaySelectionnee = PaymentGatewayType.mpesa;
  bool _enCoursDeTraitement = false;

  final List<String> _types = [
    'Dîme',
    'Offrande ordinaire',
    'Don de construction',
    'Action de grâce',
    'Soutien Écodim & Jeunesse',
  ];

  @override
  void dispose() {
    _montantController.dispose();
    _nomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _numeroCarteController.dispose();
    _expirationCarteController.dispose();
    _cvcCarteController.dispose();
    _nomTitulaireCarteController.dispose();
    super.dispose();
  }

  ModePaiementMaishapay _convertirVersModeMaishapay(PaymentGatewayType type) {
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

  Future<void> _lancerPaiement() async {
    if (!_formKey.currentState!.validate()) return;

    final montant = double.tryParse(_montantController.text.trim());
    if (montant == null || montant <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un montant valide.')),
      );
      return;
    }

    setState(() => _enCoursDeTraitement = true);

    final info = PaymentGatewayInfo.passerelles[_gatewaySelectionnee]!;
    final telephoneFinal = info.estCarteBancaire ? '' : _telephoneController.text.trim();

    final resultat = await _maishapayService.traiterOffrande(
      montant: montant,
      devise: _devise,
      typeOffrande: _typeOffrande,
      nomFidele: _nomController.text.trim().isEmpty ? 'Fidèle EECC' : _nomController.text.trim(),
      telephone: telephoneFinal,
      email: _emailController.text.trim(),
      mode: _convertirVersModeMaishapay(_gatewaySelectionnee),
    );

    setState(() => _enCoursDeTraitement = false);

    if (resultat.succes) {
      if (mounted) {
        _afficherRecuOfficiel(
          reference: resultat.reference,
          montant: montant,
          devise: _devise,
          type: _typeOffrande,
          nomPasserelle: info.nom,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade700,
            content: Text('Échec du paiement : ${resultat.message}'),
          ),
        );
      }
    }
  }

  void _afficherRecuOfficiel({
    required String reference,
    required double montant,
    required String devise,
    required String type,
    required String nomPasserelle,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Offrande Validée !', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Merci pour votre offrande dans la maison du Seigneur.',
                style: TextStyle(color: Colors.grey.shade700)),
            const Divider(height: 24),
            _buildRecuLigne('Référence :', reference),
            _buildRecuLigne('Type :', type),
            _buildRecuLigne('Montant :', '$montant $devise', estGras: true, couleur: Colors.green.shade800),
            _buildRecuLigne('Passerelle :', nomPasserelle),
            _buildRecuLigne('Statut :', 'Validé via Maishapay'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: const [
                  Icon(Icons.mail_outline, size: 18, color: Colors.amber),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Un reçu officiel et un SMS de confirmation vous ont été transmis via Brevo.',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: EeccTheme.violet,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Fermer & Retour'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecuLigne(String titre, String valeur, {bool estGras = false, Color? couleur}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titre, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(
            valeur,
            style: TextStyle(
              fontWeight: estGras ? FontWeight.bold : FontWeight.w500,
              color: couleur ?? Colors.black87,
              fontSize: estGras ? 15 : 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = PaymentGatewayInfo.passerelles[_gatewaySelectionnee]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dîmes, Dons & Offrandes'),
        backgroundColor: EeccTheme.violet,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bannière d'encouragement spirituel
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [EeccTheme.violet, const Color(0xFF6A1B9A)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(Icons.volunteer_activism, size: 36, color: EeccTheme.dore),
                    const SizedBox(height: 6),
                    const Text(
                      '« Apportez à la maison du trésor toutes les dîmes... »',
                      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Malachie 3:10',
                      style: TextStyle(color: EeccTheme.dore, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 1. Choix du type de contribution
              const Text('1. Type d\'offrande', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _typeOffrande,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _types
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _typeOffrande = val);
                },
              ),
              const SizedBox(height: 16),

              // 2. Devise & Montant
              const Text('2. Montant à verser', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _montantController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Montant',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Montant obligatoire';
                        if (double.tryParse(val.trim()) == null) return 'Nombre invalide';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'USD', label: Text('USD')),
                        ButtonSegment(value: 'CDF', label: Text('CDF')),
                      ],
                      selected: {_devise},
                      onSelectionChanged: (val) {
                        setState(() => _devise = val.first);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. SÉLECTEUR SÉPARÉ D'AGRÉGATEURS AVEC LOGOS OFFICIELS
              const Text('3. Choisissez votre mode de paiement',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              PaymentGatewaySelector(
                selectionActuelle: _gatewaySelectionnee,
                onSelectionChange: (nouveauType) {
                  setState(() => _gatewaySelectionnee = nouveauType);
                },
              ),
              const SizedBox(height: 18),

              // 4. CHAMPS DE FORMULAIRE ADAPTÉS À L'AGRÉGATEUR SÉLECTIONNÉ
              PaymentGatewayFormFields(
                gatewayType: _gatewaySelectionnee,
                telephoneController: _telephoneController,
                numeroCarteController: _numeroCarteController,
                expirationCarteController: _expirationCarteController,
                cvcCarteController: _cvcCarteController,
                nomTitulaireCarteController: _nomTitulaireCarteController,
              ),
              const SizedBox(height: 16),

              // 5. Coordonnées pour le reçu électronique officiel Brevo
              const Text('4. Coordonnées pour le reçu Brevo',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom complet du fidèle',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Adresse E-mail (pour le reçu PDF)',
                  hintText: 'exemple@gmail.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 28),

              // Bouton d'action sécurisé
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: info.couleurPrimaire,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                ),
                icon: _enCoursDeTraitement
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.lock),
                label: Text(
                  _enCoursDeTraitement
                      ? 'Connexion sécurisée à ${info.nom}...'
                      : 'PAYER MON OFFRANDE VIA ${info.nom.toUpperCase()} (${_montantController.text} $_devise)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                onPressed: _enCoursDeTraitement ? null : _lancerPaiement,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

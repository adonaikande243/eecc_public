import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../theme/eecc_theme.dart';

// ============================================================================
// PAGE PRINCIPALE – ONGLETS : [MON OFFRANDE] + [RAPPORT GÉNÉRAL]
// ============================================================================

class PasteurOffrandeScreen extends StatefulWidget {
  const PasteurOffrandeScreen({Key? key}) : super(key: key);

  @override
  State<PasteurOffrandeScreen> createState() => _PasteurOffrandeScreenState();
}

class _PasteurOffrandeScreenState extends State<PasteurOffrandeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dîmes, Dons & Offrandes'),
        backgroundColor: EeccTheme.violet,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: EeccTheme.dore,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(icon: Icon(Icons.volunteer_activism), text: 'MON OFFRANDE'),
            Tab(icon: Icon(Icons.bar_chart), text: 'RAPPORT GÉNÉRAL'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _FormulaireOffrandePasteur(),
          _RapportOffrandesEglise(),
        ],
      ),
    );
  }
}

// ============================================================================
// ONGLET 1 : FORMULAIRE COMPLET — LE PASTEUR FAIT SON OFFRANDE
// Identique aux fidèles, avec les mêmes agrégateurs et logos officiels
// ============================================================================

class _FormulaireOffrandePasteur extends StatefulWidget {
  const _FormulaireOffrandePasteur({Key? key}) : super(key: key);

  @override
  State<_FormulaireOffrandePasteur> createState() =>
      _FormulaireOffrandePasteurState();
}

class _FormulaireOffrandePasteurState
    extends State<_FormulaireOffrandePasteur> {
  final _formKey = GlobalKey<FormState>();
  final _maishapayService = MaishapayService();

  String _typeOffrande = 'Dîme pastorale';
  String _devise = 'USD';
  final _montantController = TextEditingController(text: '50');
  final _nomController = TextEditingController(text: 'Pasteur');
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _numeroCarteController = TextEditingController();
  final _expirationCarteController = TextEditingController();
  final _cvcCarteController = TextEditingController();
  final _nomTitulaireCarteController = TextEditingController();

  PaymentGatewayType _gateway = PaymentGatewayType.mpesa;
  bool _enCours = false;

  final List<String> _typesOffrande = [
    'Dîme pastorale',
    'Offrande ordinaire',
    'Don de construction',
    'Action de grâce',
    'Contribution missionnaire',
    'Fonds d\'urgence de l\'église',
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

  ModePaiementMaishapay _toModeMaishapay(PaymentGatewayType type) {
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
    if (montant == null || montant <= 0) return;

    setState(() => _enCours = true);

    final info = PaymentGatewayInfo.passerelles[_gateway]!;
    final resultat = await _maishapayService.traiterOffrande(
      montant: montant,
      devise: _devise,
      typeOffrande: _typeOffrande,
      nomFidele: _nomController.text.trim().isEmpty
          ? 'Pasteur EECC'
          : _nomController.text.trim(),
      telephone: info.estCarteBancaire ? '' : _telephoneController.text.trim(),
      email: _emailController.text.trim(),
      mode: _toModeMaishapay(_gateway),
    );

    setState(() => _enCours = false);

    if (!mounted) return;

    if (resultat.succes) {
      _afficherRecu(
        reference: resultat.reference,
        montant: montant,
        nomPasserelle: info.nom,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: Text('Échec: ${resultat.message}'),
        ),
      );
    }
  }

  void _afficherRecu({
    required String reference,
    required double montant,
    required String nomPasserelle,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 32),
            SizedBox(width: 10),
            Text('Offrande Validée !',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  _recuLigne('Référence', reference),
                  _recuLigne('Type', _typeOffrande),
                  _recuLigne(
                    'Montant',
                    '$montant $_devise',
                    estGras: true,
                    couleur: Colors.green.shade800,
                  ),
                  _recuLigne('Via', nomPasserelle),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '« Apportez à la maison du trésor toutes les dîmes... »\nMalachie 3:10',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                  fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.mail_outline, color: Colors.amber, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Reçu transmis par email & SMS via Brevo.',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: EeccTheme.violet,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Dieu merci — Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _recuLigne(String titre, String valeur,
      {bool estGras = false, Color? couleur}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titre,
              style:
                  TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(
            valeur,
            style: TextStyle(
              fontWeight:
                  estGras ? FontWeight.bold : FontWeight.w500,
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
    final info = PaymentGatewayInfo.passerelles[_gateway]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bannière spirituelle pastorale
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [EeccTheme.violet, const Color(0xFF6A1B9A)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Icon(Icons.volunteer_activism,
                      size: 38, color: EeccTheme.dore),
                  const SizedBox(height: 8),
                  const Text(
                    'En tant que pasteur, je sers d\'exemple à la communauté en offrant avec joie et engagement.',
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text('2 Corinthiens 9:7',
                      style: TextStyle(
                          color: EeccTheme.dore,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 1. Type d'offrande
            const Text('1. Type de contribution',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _typeOffrande,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _typesOffrande
                  .map((t) =>
                      DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _typeOffrande = val);
              },
            ),
            const SizedBox(height: 16),

            // 2. Montant & Devise
            const Text('2. Montant',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _montantController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Montant',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Obligatoire';
                      }
                      if (double.tryParse(val.trim()) == null) {
                        return 'Nombre invalide';
                      }
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
                    onSelectionChanged: (val) =>
                        setState(() => _devise = val.first),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 3. Sélection de l'agrégateur de paiement avec logos officiels
            const Text('3. Mode de paiement',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            PaymentGatewaySelector(
              selectionActuelle: _gateway,
              onSelectionChange: (type) =>
                  setState(() => _gateway = type),
            ),
            const SizedBox(height: 18),

            // 4. Formulaire adapté (Mobile Money OU Carte Bancaire)
            PaymentGatewayFormFields(
              gatewayType: _gateway,
              telephoneController: _telephoneController,
              numeroCarteController: _numeroCarteController,
              expirationCarteController: _expirationCarteController,
              cvcCarteController: _cvcCarteController,
              nomTitulaireCarteController: _nomTitulaireCarteController,
            ),
            const SizedBox(height: 16),

            // 5. Coordonnées pour le reçu Brevo
            const Text('4. Coordonnées pour le reçu',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom & Prénom',
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
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 28),

            // Bouton de paiement dynamique selon l'agrégateur
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: info.couleurPrimaire,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
              icon: _enCours
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.lock_outline),
              label: Text(
                _enCours
                    ? 'Connexion à ${info.nom}...'
                    : 'VALIDER MON OFFRANDE — ${_montantController.text} $_devise via ${info.nom}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14),
              ),
              onPressed: _enCours ? null : _lancerPaiement,
            ),
            const SizedBox(height: 8),
            Text(
              'Paiement sécurisé via Maishapay · ${info.nom}',
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ONGLET 2 : RAPPORT GÉNÉRAL DES OFFRANDES DE L'ÉGLISE
// ============================================================================

class _RapportOffrandesEglise extends StatefulWidget {
  const _RapportOffrandesEglise({Key? key}) : super(key: key);

  @override
  State<_RapportOffrandesEglise> createState() =>
      _RapportOffrandesEgliseState();
}

class _RapportOffrandesEgliseState extends State<_RapportOffrandesEglise> {
  bool _chargement = true;
  List<Map<String, dynamic>> _offrandes = [];
  double _totalUsd = 0;
  double _totalCdf = 0;
  double _totalDimesUsd = 0;
  double _totalConstructionUsd = 0;
  Timer? _timer;

  // Compteurs par agrégateur
  final Map<PaymentGatewayType, int> _compteurs = {
    PaymentGatewayType.mpesa: 0,
    PaymentGatewayType.airtelMoney: 0,
    PaymentGatewayType.orangeMoney: 0,
    PaymentGatewayType.visa: 0,
    PaymentGatewayType.mastercard: 0,
  };
  final Map<PaymentGatewayType, double> _totauxParGateway = {
    PaymentGatewayType.mpesa: 0,
    PaymentGatewayType.airtelMoney: 0,
    PaymentGatewayType.orangeMoney: 0,
    PaymentGatewayType.visa: 0,
    PaymentGatewayType.mastercard: 0,
  };

  @override
  void initState() {
    super.initState();
    _charger();
    // Actualisation automatique toutes les 30 secondes
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _charger());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  PaymentGatewayType _gwDepuisCanal(String? canal) {
    if (canal == null) return PaymentGatewayType.mpesa;
    final c = canal.toUpperCase();
    if (c.contains('AIRTEL')) return PaymentGatewayType.airtelMoney;
    if (c.contains('ORANGE')) return PaymentGatewayType.orangeMoney;
    if (c.contains('VISA')) return PaymentGatewayType.visa;
    if (c.contains('MASTER')) return PaymentGatewayType.mastercard;
    return PaymentGatewayType.mpesa;
  }

  Future<void> _charger() async {
    if (mounted) setState(() => _chargement = true);

    try {
      final url = Uri.parse(
        '${EeccApiConfig.supabaseUrl}/rest/v1/eecc_offrandes?order=created_at.desc&limit=100',
      );
      final response = await http.get(
        url,
        headers: {
          'apikey': EeccApiConfig.supabaseServiceRoleKey,
          'Authorization': 'Bearer ${EeccApiConfig.supabaseServiceRoleKey}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _offrandes = List<Map<String, dynamic>>.from(data);

        _totalUsd = 0;
        _totalCdf = 0;
        _totalDimesUsd = 0;
        _totalConstructionUsd = 0;

        for (var key in _compteurs.keys) {
          _compteurs[key] = 0;
          _totauxParGateway[key] = 0;
        }

        for (final off in _offrandes) {
          final m = (off['montant'] as num?)?.toDouble() ?? 0.0;
          final d = (off['devise'] ?? 'USD') as String;
          final type = (off['type_offrande'] ?? '') as String;
          final canal = off['canal'] as String?;
          final gw = _gwDepuisCanal(canal);

          if (d == 'USD') {
            _totalUsd += m;
            if (type.toLowerCase().contains('dîme') ||
                type.toLowerCase().contains('dime')) {
              _totalDimesUsd += m;
            } else if (type.toLowerCase().contains('construction')) {
              _totalConstructionUsd += m;
            }
          } else {
            _totalCdf += m;
          }

          _compteurs[gw] = (_compteurs[gw] ?? 0) + 1;
          if (d == 'USD') {
            _totauxParGateway[gw] =
                (_totauxParGateway[gw] ?? 0) + m;
          }
        }
      }
    } catch (e) {
      debugPrint('[PasteurOffrandes] Erreur: $e');
    }

    if (mounted) setState(() => _chargement = false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _charger,
      child: _chargement
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Totaux généraux
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1B5E20),
                          const Color(0xFF2E7D32)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.account_balance,
                                color: Colors.white70, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'TRÉSORERIE GLOBALE DE L\'ÉGLISE',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  letterSpacing: 0.8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            _statCard('Total (USD)',
                                '\$${_totalUsd.toStringAsFixed(2)}', true),
                            _statCard('Total (CDF)',
                                '${_totalCdf.toStringAsFixed(0)} FC',
                                false),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            _statCardSmall('Dîmes USD',
                                '\$${_totalDimesUsd.toStringAsFixed(2)}'),
                            _statCardSmall('Construction USD',
                                '\$${_totalConstructionUsd.toStringAsFixed(2)}'),
                            _statCardSmall('Transactions',
                                '${_offrandes.length}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Répartition par agrégateur
                  const Text(
                    'Répartition par agrégateur de paiement',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...PaymentGatewayInfo.passerelles.entries
                      .map((entry) {
                    final type = entry.key;
                    final info = entry.value;
                    final count = _compteurs[type] ?? 0;
                    final total = _totauxParGateway[type] ?? 0;
                    final pct = _offrandes.isEmpty
                        ? 0.0
                        : count / _offrandes.length;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          PaymentGatewayLogo(
                              type: type, width: 52, height: 34),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(info.nom,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor:
                                      Colors.grey.shade100,
                                  color: info.couleurPrimaire,
                                  minHeight: 5,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$count transaction${count > 1 ? 's' : ''}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: info.couleurPrimaire,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${(pct * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 22),

                  // Historique détaillé
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Historique des contributions',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh,
                            size: 20),
                        onPressed: _charger,
                        tooltip: 'Actualiser',
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  if (_offrandes.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      child: Text(
                        'Aucune transaction enregistrée.',
                        style:
                            TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: _offrandes.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final item = _offrandes[i];
                        final gw = _gwDepuisCanal(
                            item['canal'] as String?);
                        final dateStr = item['created_at'] != null
                            ? (DateTime.tryParse(
                                        item['created_at'])
                                    ?.toLocal()
                                    .toString()
                                    .substring(0, 16) ??
                                '')
                            : '';

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          leading: PaymentGatewayLogo(
                              type: gw, width: 48, height: 30),
                          title: Text(
                            item['nom_fidele'] ??
                                'Fidèle Anonyme',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                          subtitle: Text(
                            '${item['type_offrande'] ?? 'Offrande'} · $dateStr',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600),
                          ),
                          trailing: Text(
                            '+${item['montant']} ${item['devise']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }

  Widget _statCard(String titre, String valeur, bool principal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titre,
            style: const TextStyle(
                color: Colors.white70, fontSize: 12)),
        Text(
          valeur,
          style: TextStyle(
            color: Colors.white,
            fontSize: principal ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _statCardSmall(String titre, String valeur) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titre,
            style: const TextStyle(
                color: Colors.white60, fontSize: 11)),
        Text(valeur,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
      ],
    );
  }
}

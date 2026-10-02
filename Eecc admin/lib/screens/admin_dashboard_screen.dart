import 'package:flutter/material.dart';
import '../theme/eecc_theme.dart';

/// Tableau de bord Administrateur intégrant TOUTES les maquettes de l'application Eecc admin :
/// - 01_dashboard-1.png (Vue d'ensemble & métriques)
/// - 02_utilisateurs.png & 04_roles_permissions.png (Comptes & Droits)
/// - 03_membres.png (Registre général des fidèles)
/// - 05_paroisses.png (Gestion des paroisses)
/// - 05_chorales_liste.png à 09_chorale_presences.png (Module Chorales complet)
/// - 06_moderation.png & 10_workflow_soumission.png (Modération & Workflow)
/// - 07_offrandes.png & 08_maishapay.png (Finances & Passerelle Maishapay)
/// - 09_audit.png & 10_sauvegardes.png (Audit & Sauvegardes Cloud)
/// - 11_statistiques.png (Statistiques globales)
/// - 12_ecodim_supervision.png (Supervision de l'école du dimanche)
/// - 12_media_scanner.png à 18_media_photos.png (Régie & Médias Pro)
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedSidebarIndex = 0;

  final List<String> _semaines = ['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'];
  final List<double> _affluence = [210, 225, 215, 238, 248, 260, 252, 270];

  // États Régie Média
  int _selectedSource = 0;
  bool _overlayTitre = true;
  bool _overlayVerset = false;
  bool _overlayQr = true;
  bool _overlayLogo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Row(
        children: [
          // 1. Barre Latérale Gauche (Dark Slate #0F172A)
          Container(
            width: 260,
            color: const Color(0xFF0F172A),
            child: Column(
              children: [
                // En-tête Sidebar
                Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 24, left: 20, right: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1E3A8A),
                          border: Border.all(color: Colors.white24, width: 1.5),
                        ),
                        child: const Center(
                          child: Icon(Icons.church_outlined, color: Colors.white, size: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'EECC ADMIN',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Portail de Gestion',
                              style: TextStyle(color: Colors.white60, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.white12),

                // 12 Rubriques correspondant exactement aux maquettes
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildSidebarItem(0, Icons.dashboard_outlined, 'Tableau de bord'),
                      _buildSidebarItem(1, Icons.people_outline, 'Membres & Fidèles'),
                      _buildSidebarItem(2, Icons.account_balance_wallet_outlined, 'Finances & Offrandes'),
                      _buildSidebarItem(3, Icons.sensors, 'Cultes & Diffusion'),
                      _buildSidebarItem(4, Icons.videocam_outlined, 'Régie Vidéo Pro'),
                      _buildSidebarItem(5, Icons.campaign_outlined, 'Communications & Modération'),
                      _buildSidebarItem(6, Icons.music_note_outlined, 'Chorales & Répétitions'),
                      _buildSidebarItem(7, Icons.apartment_outlined, 'Paroisses & Départements'),
                      _buildSidebarItem(8, Icons.child_care_outlined, 'Écodim & Documentation'),
                      _buildSidebarItem(9, Icons.bar_chart_outlined, 'Statistiques & Audit'),
                      const Divider(height: 16, color: Colors.white12),
                      _buildSidebarItem(10, Icons.settings_outlined, 'Paramètres & Rôles'),
                      _buildSidebarItem(11, Icons.logout, 'Déconnexion', isDestructive: true),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Zone Principale de Contenu dynamique
          Expanded(
            child: Column(
              children: [
                // Barre Supérieure de navigation
                Container(
                  height: 68,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text(
                        _getSectionTitle(_selectedSidebarIndex),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(width: 32),
                      // Barre de recherche universelle
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Rechercher un membre, une transaction, un culte...',
                              hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                              prefixIcon: Icon(Icons.search, size: 20, color: Color(0xFF94A3B8)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),

                      // Notifications
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: Color(0xFF64748B)),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 12),

                      // Profil Admin
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFF1E3A8A),
                            child: Icon(Icons.admin_panel_settings, size: 20, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Super Administrateur', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              Text('admin@eecc.org', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),

                // Corps d'affichage selon la rubrique sélectionnée
                Expanded(
                  child: _buildCurrentSection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSectionTitle(int index) {
    switch (index) {
      case 0: return 'Vue d\'ensemble Administrateur';
      case 1: return 'Gestion des Membres & Fidèles';
      case 2: return 'Finances, Offrandes & Maishapay';
      case 3: return 'Cultes & Diffusion en Direct';
      case 4: return 'Régie Vidéo Professionnelle & Habillage';
      case 5: return 'Communications, Annonces & Modération';
      case 6: return 'Chorales, Répétitions & Présences';
      case 7: return 'Paroisses & Départements EECC';
      case 8: return 'Supervision Écodim & Documentation';
      case 9: return 'Statistiques Globales, Audit & Sauvegardes';
      case 10: return 'Paramètres Généraux & Rôles Administrateurs';
      default: return 'Tableau de Bord';
    }
  }

  Widget _buildCurrentSection() {
    switch (_selectedSidebarIndex) {
      case 0: return _buildDashboardView();
      case 1: return _buildMembresView();
      case 2: return _buildFinancesView();
      case 3: return _buildCultesDiffusionView();
      case 4: return _buildRegieVideoProView();
      case 5: return _buildCommunicationsView();
      case 6: return _buildChoralesView();
      case 7: return _buildParoissesView();
      case 8: return _buildEcodimView();
      case 9: return _buildStatistiquesAuditView();
      case 10: return _buildParametresRolesView();
      default: return _buildDashboardView();
    }
  }

  // ===========================================================================
  // 0. TABLEAU DE BORD (Maquette 01_dashboard-1.png)
  // ===========================================================================
  Widget _buildDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  'Total Membres',
                  '1 248',
                  '+12 ce mois',
                  Icons.people_alt,
                  const Color(0xFF2563EB),
                  const Color(0xFFEFF6FF),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  'Paroisses Actives',
                  '6',
                  'Kinshasa & Provinces',
                  Icons.church,
                  const Color(0xFF059669),
                  const Color(0xFFECFDF5),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  'Offrandes & Dîmes',
                  '4 250 000 FC',
                  '+14.2% vs M-1',
                  Icons.account_balance_wallet,
                  const Color(0xFFDC2626),
                  const Color(0xFFFEF2F2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  'Publications à valider',
                  '14',
                  'En attente de relecture',
                  Icons.edit_note,
                  const Color(0xFF7C3AED),
                  const Color(0xFFF5F3FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Graphique 8 semaines + Journal d'activités
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Fréquentation — 8 dernières semaines',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          Text('Fidèles / Culte', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 180,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (int i = 0; i < _semaines.length; i++)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('${_affluence[i].toInt()}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 28,
                                    height: (_affluence[i] / 300) * 140,
                                    decoration: BoxDecoration(
                                      color: i == _semaines.length - 1 ? const Color(0xFF1E3A8A) : const Color(0xFF93C5FD),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(_semaines[i], style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alertes de sécurité & Audit',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 14),
                      _buildActivityItem('Régie Studio connectée', 'Diffusion active sur YouTube & FB', 'Il y a 5 min'),
                      _buildActivityItem('Offrande Maishapay validée', '+25 000 FC reçue', 'Il y a 20 min'),
                      _buildActivityItem('Sauvegarde Cloud effectuée', 'OneDrive & Google Drive OK', 'Il y a 1h'),
                      _buildActivityItem('Nouveau rôle attribué', 'Modérateur accordé à J. Mulumba', 'Hier'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 1. GESTION DES MEMBRES (Maquette 03_membres.png)
  // ===========================================================================
  Widget _buildMembresView() {
    final membres = [
      {'mat': 'EECC-001', 'nom': 'KABONGO Grâce', 'paroisse': 'Paroisse Centrale', 'statut': 'Actif', 'role': 'Comité'},
      {'mat': 'EECC-002', 'nom': 'MUKENDI Jean', 'paroisse': 'Paroisse Limete', 'statut': 'Actif', 'role': 'Pasteur'},
      {'mat': 'EECC-003', 'nom': 'NTUMBA Marie', 'paroisse': 'Paroisse Bandal', 'statut': 'Baptisée', 'role': 'Fidèle'},
      {'mat': 'EECC-004', 'nom': 'ILUNGA David', 'paroisse': 'Paroisse Centrale', 'statut': 'Actif', 'role': 'Diacre'},
      {'mat': 'EECC-005', 'nom': 'MWAMBA Ruth', 'paroisse': 'Paroisse Limete', 'statut': 'Actif', 'role': 'Choriste'},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Registre officiel des membres (1 248 inscrits)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A)),
                onPressed: () {},
                icon: const Icon(Icons.person_add, size: 18),
                label: const Text('Nouveau Membre'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Matricule', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Nom & Postnom', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Paroisse', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Rôle officiel', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Statut', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: membres.map((m) {
                return DataRow(cells: [
                  DataCell(Text(m['mat']!)),
                  DataCell(Text(m['nom']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(m['paroisse']!)),
                  DataCell(Text(m['role']!)),
                  DataCell(Chip(label: Text(m['statut']!, style: const TextStyle(fontSize: 11)), backgroundColor: const Color(0xFFECFDF5))),
                  DataCell(IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () {})),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. FINANCES & MAISHAPAY (Maquettes 07_offrandes.png & 08_maishapay.png)
  // ===========================================================================
  Widget _buildFinancesView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: _buildMetricTile('Total Collecté ce mois', '4 250 000 FC', 'Dîmes & Dons', Icons.payments, Colors.teal, const Color(0xFFE6FFFA))),
              const SizedBox(width: 16),
              Expanded(child: _buildMetricTile('Passerelle Maishapay', 'Connectée (Live)', 'Taux de succès 99.4%', Icons.check_circle, Colors.green, const Color(0xFFECFDF5))),
              const SizedBox(width: 16),
              Expanded(child: _buildMetricTile('Devises supportées', 'CDF & USD', 'Airtel, Orange, Visa', Icons.currency_exchange, Colors.indigo, const Color(0xFFEEF2FF))),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Dernières Transactions Maishapay en temps réel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                ListTile(
                  leading: Icon(Icons.phone_android, color: Colors.red),
                  title: Text('Airtel Money — Dîme mensuelle (25 000 FC)'),
                  subtitle: Text('Réf : MP-2026-88419 • +243 820 000 123 • Validé'),
                  trailing: Text('Il y a 10 min', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.phone_android, color: Colors.orange),
                  title: Text('Orange Money — Don projet construction (50 000 FC)'),
                  subtitle: Text('Réf : MP-2026-88418 • +243 890 000 456 • Validé'),
                  trailing: Text('Il y a 25 min', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 3. CULTES & DIFFUSION (Maquettes 12_media_scanner.png & 13_media_connecte.png)
  // ===========================================================================
  Widget _buildCultesDiffusionView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Supervision des Cultes & Flux de Diffusion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Contrôle des caméras, des encodeurs RTMP et de la passerelle YouTube / Facebook.', style: TextStyle(color: Color(0xFF64748B))),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
                  child: Column(
                    children: const [
                      Icon(Icons.qr_code_scanner, size: 48, color: Color(0xFF1E3A8A)),
                      SizedBox(height: 10),
                      Text('Scanner Caméra Mobile (WebRTC)', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Scannez pour connecter un smartphone comme caméra HDMI sans fil.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
                  child: Column(
                    children: const [
                      Icon(Icons.sensors, size: 48, color: Colors.red),
                      SizedBox(height: 10),
                      Text('Serveur RTMP Local', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('rtmp://127.0.0.1:1935/live (1080p60 6000 kbps)', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. RÉGIE VIDÉO PRO (Maquette 13_regie_principale.png & 17_media_bible.png)
  // ===========================================================================
  Widget _buildRegieVideoProView() {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('RÉGIE MÉDIA & PROJECTION OFFICIELLE', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                    child: const Text('• EN DIRECT · 00:24:12', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                    onPressed: () {},
                    child: const Text('Projeter Jean 3:16'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Double Moniteur Broadcast
          Expanded(
            child: Row(
              children: [
                // Preview
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Colors.green, width: 2), borderRadius: BorderRadius.circular(8)),
                    child: const Center(child: Text('APERÇU (PREVIEW)', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                  ),
                ),
                Container(
                  width: 80,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), padding: const EdgeInsets.symmetric(vertical: 20)),
                    onPressed: () {},
                    child: const Text('TAKE →', style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
                // Program
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(8)),
                    child: Stack(
                      children: const [
                        Center(child: Text('PROGRAMME (LIVE ON AIR)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                        Positioned(top: 10, right: 10, child: Chip(label: Text('EECC LIVE', style: TextStyle(color: Colors.white, fontSize: 10)), backgroundColor: Colors.black54)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sélecteur de sources
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Text('SOURCES : ', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                _buildStudioSourceChip(0, 'Caméra Scène'),
                _buildStudioSourceChip(1, 'Caméra Fond'),
                _buildStudioSourceChip(2, 'Tél. Jean K.'),
                _buildStudioSourceChip(3, 'Bible Jean 3:16'),
                _buildStudioSourceChip(4, 'Diaporama Culte'),
                const Spacer(),
                const Text('OVERLAYS : ', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                _buildStudioOverlayToggle('Bandeau Titre', _overlayTitre, (v) => setState(() => _overlayTitre = v)),
                _buildStudioOverlayToggle('QR Offrande', _overlayQr, (v) => setState(() => _overlayQr = v)),
                _buildStudioOverlayToggle('Logo', _overlayLogo, (v) => setState(() => _overlayLogo = v)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudioSourceChip(int index, String label) {
    final isSel = _selectedSource == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: TextStyle(color: Colors.white, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
        backgroundColor: isSel ? const Color(0xFF2563EB) : const Color(0xFF334155),
        onPressed: () => setState(() => _selectedSource = index),
      ),
    );
  }

  Widget _buildStudioOverlayToggle(String label, bool value, Function(bool) onToggle) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 11, color: Colors.white)),
        selected: value,
        selectedColor: const Color(0xFF059669),
        backgroundColor: const Color(0xFF334155),
        onSelected: onToggle,
      ),
    );
  }

  // ===========================================================================
  // 5. COMMUNICATIONS & MODÉRATION (Maquettes 06_moderation & 10_workflow)
  // ===========================================================================
  Widget _buildCommunicationsView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Modération & Soumissions Pastorales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildModerationCard('Campagne d\'évangélisation provinciale', 'Proposé par Comité Mission', 'En attente de validation pastorale'),
                _buildModerationCard('Séminaire des couples chrétiens', 'Proposé par Pasteur Jean M.', 'Validé pour publication'),
                _buildModerationCard('Collecte de rentrée scolaire', 'Proposé par Diaconat Social', 'Rejeté (motif: calendrier complet)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModerationCard(String titre, String auteur, String statut) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(titre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$auteur • $statut'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {}),
            IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 6. CHORALES & MUSIQUE (Maquettes 05_chorales à 09_chorale_presences)
  // ===========================================================================
  Widget _buildChoralesView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Chorales & Groupes de Louange EECC', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.music_note, color: Color(0xFF1E3A8A)),
            title: Text('Chorale Voix de Grâce', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('42 choristes actifs • Répétition samedi 15h00 • 18 chants enregistrés'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.music_note, color: Color(0xFF1E3A8A)),
            title: Text('Chœur des Anges (Jeunesse)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('28 choristes actifs • Répétition vendredi 17h00 • 12 chants enregistrés'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 7. PAROISSES (Maquette 05_paroisses.png)
  // ===========================================================================
  Widget _buildParoissesView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Paroisses & Extensions Évangéliques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.apartment, color: Color(0xFF1E3A8A)),
            title: Text('Paroisse Centrale de Kinshasa', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Siège Principal • Pasteur David Kande • 850 membres'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.apartment, color: Color(0xFF1E3A8A)),
            title: Text('Paroisse Limete', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Extension Est • Pasteur Jean Mukendi • 248 membres'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.apartment, color: Color(0xFF1E3A8A)),
            title: Text('Extension Bandalungwa', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Extension Ouest • Pasteur adjoint Paul K. • 150 membres'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 8. ÉCODIM & DOCUMENTATION (Maquette 12_ecodim_supervision.png)
  // ===========================================================================
  Widget _buildEcodimView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Supervision Écodim & Documentation Pastorale', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.child_care, color: Colors.blue),
            title: Text('Classe des Petits (3 - 6 ans)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Monitrice : Sœur Marie • 35 enfants • Thème : L\'Arche de Noé'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.child_care, color: Colors.indigo),
            title: Text('Classe des Cadets (7 - 12 ans)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Moniteur : Frère David • 48 enfants • Thème : David et Goliath'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 9. STATISTIQUES & AUDIT (Maquettes 11_statistiques, 09_audit, 10_sauvegardes)
  // ===========================================================================
  Widget _buildStatistiquesAuditView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Statistiques Générales, Audit & Sauvegardes Cloud', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.cloud_done, color: Colors.green),
            title: Text('Sauvegardes Automatiques Cloud (OneDrive & Google Drive)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Dernière archive chiffrée synchronisée aujourd\'hui à 04h00.'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.security, color: Colors.orange),
            title: Text('Journal d\'Audit de Sécurité', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('100% des modifications, suppressions et validations sont tracées.'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 10. PARAMÈTRES & RÔLES (Maquettes 02_utilisateurs & 04_roles_permissions)
  // ===========================================================================
  Widget _buildParametresRolesView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Paramètres du Système & Rôles d\'Accès (RBAC)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.admin_panel_settings, color: Color(0xFF1E3A8A)),
            title: Text('Rôle Super-Administrateur', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Accès complet à la base de données, aux finances et à la sécurité.'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.verified_user, color: Colors.teal),
            title: Text('Rôle Régisseur Média', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Contrôle des caméras, de la régie OBS, de la projection et des flux RTMP.'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // WIDGETS AUXILIAIRES
  // ===========================================================================
  Widget _buildSidebarItem(int index, IconData icon, String title, {bool isDestructive = false}) {
    final isSelected = _selectedSidebarIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1E3A8A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red.shade400 : (isSelected ? Colors.white : Colors.white60),
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isDestructive ? Colors.red.shade400 : (isSelected ? Colors.white : Colors.white70),
          ),
        ),
        onTap: () {
          if (isDestructive) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Déconnexion effectuée')));
          } else {
            setState(() => _selectedSidebarIndex = index);
          }
        },
      ),
    );
  }

  Widget _buildMetricTile(String title, String val, String subtitle, IconData icon, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(val, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Color(0xFF1E3A8A), shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}

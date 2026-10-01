import 'package:flutter/material.dart';
import '../theme/eecc_theme.dart';

/// Tableau de bord Administrateur fidèle à la maquette Eecc admin/01_dashboard-1.png
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedSidebarIndex = 0;

  final List<String> _semaines = ['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'];
  final List<double> _affluence = [210, 225, 215, 238, 248, 260, 252, 270];

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

                // 12 Rubriques de menu de la maquette
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildSidebarItem(0, Icons.dashboard_outlined, 'Tableau de bord'),
                      _buildSidebarItem(1, Icons.people_outline, 'Membres & Fidèles'),
                      _buildSidebarItem(2, Icons.account_balance_wallet_outlined, 'Finances & Offrandes'),
                      _buildSidebarItem(3, Icons.sensors, 'Cultes & Diffusion'),
                      _buildSidebarItem(4, Icons.videocam_outlined, 'Régie Vidéo Pro'),
                      _buildSidebarItem(5, Icons.campaign_outlined, 'Communications'),
                      _buildSidebarItem(6, Icons.event_note_outlined, 'Événements'),
                      _buildSidebarItem(7, Icons.apartment_outlined, 'Départements'),
                      _buildSidebarItem(8, Icons.description_outlined, 'Documentation'),
                      _buildSidebarItem(9, Icons.bar_chart_outlined, 'Rapports & Statistiques'),
                      const Divider(height: 16, color: Colors.white12),
                      _buildSidebarItem(10, Icons.settings_outlined, 'Paramètres généraux'),
                      _buildSidebarItem(11, Icons.logout, 'Déconnexion', isDestructive: true),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Zone Principale de Contenu
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
                      const Text(
                        'Vue d\'ensemble Administrateur',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(width: 32),
                      // Barre de recherche
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

                // Corps Défilable
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 4 Cartes Métriques (Ligne de 4)
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricTile(
                                'Total Membres',
                                '248',
                                '+12 ce mois',
                                Icons.people_alt,
                                const Color(0xFF2563EB),
                                const Color(0xFFEFF6FF),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMetricTile(
                                'Recettes du mois',
                                '3 450 \$',
                                '+8.4% vs M-1',
                                Icons.account_balance_wallet,
                                const Color(0xFF059669),
                                const Color(0xFFECFDF5),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMetricTile(
                                'Cultes diffusés',
                                '12',
                                '100% opérationnel',
                                Icons.live_tv,
                                const Color(0xFFDC2626),
                                const Color(0xFFFEF2F2),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMetricTile(
                                'Taux de présence',
                                '88 %',
                                '+4% de croissance',
                                Icons.trending_up,
                                const Color(0xFF7C3AED),
                                const Color(0xFFF5F3FF),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Graphique d'affluence sur 8 semaines + Journal de bord
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Graphique 8 semaines
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
                                          'Affluence des Cultes Dominicaux (8 dernières semaines)',
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

                            // Journal Sécurité & Activités
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
                                      'Journal d\'activités récentes',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                    ),
                                    const SizedBox(height: 14),
                                    _buildActivityItem('Régie Studio lancée', 'Diffusion YouTube/FB active', 'Il y a 10 min'),
                                    _buildActivityItem('Offrande reçue (Maishapay)', '+50 000 FC de Dîme', 'Il y a 35 min'),
                                    _buildActivityItem('Nouveau membre baptisé', 'Inscrit dans le registre', 'Il y a 2h'),
                                    _buildActivityItem('Rapport mensuel exporté', 'Archive PDF téléversée sur Cloud', 'Hier'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Déconnexion')));
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
          Text(val, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
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

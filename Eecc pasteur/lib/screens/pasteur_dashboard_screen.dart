import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../theme/eecc_theme.dart';
import 'pasteur_direct_screen.dart';
import 'pasteur_offrande_screen.dart';

class PasteurDashboardScreen extends StatefulWidget {
  const PasteurDashboardScreen({Key? key}) : super(key: key);

  @override
  State<PasteurDashboardScreen> createState() => _PasteurDashboardScreenState();
}

class _PasteurDashboardScreenState extends State<PasteurDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _PasteurAccueilOnglet(),
    const PasteurDirectScreen(),
    const PasteurOffrandeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: EeccTheme.violet,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors_outlined),
            activeIcon: Icon(Icons.sensors, color: Colors.red),
            label: 'Cultes en Direct',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Offrandes',
          ),
        ],
      ),
    );
  }
}

/// Onglet d'accueil général du Pasteur
class _PasteurAccueilOnglet extends StatelessWidget {
  const _PasteurAccueilOnglet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supabase = EeccSupabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Pastoral EECC'),
        backgroundColor: EeccTheme.violet,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bandeau de bienvenue
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [EeccTheme.violet, const Color(0xFF6A1B9A)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: EeccTheme.dore,
                    child: const Icon(Icons.person, size: 36, color: Colors.black87),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Paix du Christ, Pasteur',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Supervision spirituelle & financière de l\'église',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Indicateur de culte en direct en cours
            StreamBuilder<EeccLiveSession?>(
              stream: supabase.ecouterLiveEnCours(),
              builder: (context, snapshot) {
                final live = snapshot.data;
                if (live != null && live.isLive) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade300, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sensors, color: Colors.red, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CULTE EN DIRECT MAINTENANT',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                live.titre,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PasteurDirectScreen()),
                            );
                          },
                          child: const Text('SUPERVISER'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Raccourcis rapides
            const Text('Modules Pastoraux', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    context,
                    titre: 'Cultes en Direct',
                    sousTitre: 'Supervision & Prières',
                    icon: Icons.sensors,
                    couleur: Colors.red.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PasteurDirectScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionTile(
                    context,
                    titre: 'Offrandes & Dîmes',
                    sousTitre: 'Finances & Reçus',
                    icon: Icons.account_balance_wallet,
                    couleur: const Color(0xFF007A3D),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PasteurOffrandeScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    context,
                    titre: 'Archives Cloud',
                    sousTitre: 'Google Drive EECC',
                    icon: Icons.video_library,
                    couleur: Colors.indigo,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionTile(
                    context,
                    titre: 'Membres & Fidèles',
                    sousTitre: 'Registre & Visites',
                    icon: Icons.people,
                    couleur: Colors.orange.shade800,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String titre,
    required String sousTitre,
    required IconData icon,
    required Color couleur,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: couleur.withOpacity(0.12),
              radius: 24,
              child: Icon(icon, color: couleur, size: 24),
            ),
            const SizedBox(height: 12),
            Text(titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 2),
            Text(sousTitre, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

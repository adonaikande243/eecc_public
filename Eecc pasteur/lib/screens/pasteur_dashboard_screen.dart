import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../theme/eecc_theme.dart';
import 'pasteur_direct_screen.dart';
import 'pasteur_offrande_screen.dart';

/// Tableau de bord Pastoral pixel-perfect conforme à la maquette Eecc pasteur/01_dashboard.png
class PasteurDashboardScreen extends StatefulWidget {
  const PasteurDashboardScreen({Key? key}) : super(key: key);

  @override
  State<PasteurDashboardScreen> createState() => _PasteurDashboardScreenState();
}

class _PasteurDashboardScreenState extends State<PasteurDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const _PasteurOverviewTab(),
    const _PasteurMembresTab(),
    const _PasteurChatTab(),
    const _PasteurReunionsTab(),
    const _PasteurPublicationsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: const Color(0xFF1E3A5F),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Membres',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Réunions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              activeIcon: Icon(Icons.article),
              label: 'Publications',
            ),
          ],
        ),
      ),
    );
  }
}

/// Onglet Vue d'ensemble fidèle à 01_dashboard.png
class _PasteurOverviewTab extends StatelessWidget {
  const _PasteurOverviewTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF0F172A), size: 24),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salutation Pasteur
            const Text(
              'Bonjour, Pasteur Jean Mukendi',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 22),

            // 4 Cartes Métriques (2x2) de la maquette 01_dashboard.png
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    number: '248',
                    label: 'Membres',
                    icon: Icons.people_outline,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildMetricCard(
                    number: '3',
                    label: 'Paroisses',
                    icon: Icons.home_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    number: '6',
                    label: 'Prières en attente',
                    icon: Icons.pan_tool_outlined,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildMetricCard(
                    number: '2',
                    label: 'Publications à valider',
                    icon: Icons.description_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Section "Réunions à venir" (Maquette 01_dashboard.png)
            const Text(
              'Réunions à venir',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // Carte Réunion
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Conseil pastoral',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Aujourd\'hui, 17h00',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF94A3B8),
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Boutons d'action rapide
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFFCA5A5)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PasteurDirectScreen()));
                    },
                    icon: const Icon(Icons.sensors, size: 18),
                    label: const Text('Live Direct', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1E3A5F),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PasteurOffrandeScreen()));
                    },
                    icon: const Icon(Icons.account_balance_wallet_outlined, size: 18),
                    label: const Text('Offrandes', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String number,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF64748B)),
          const SizedBox(height: 12),
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Onglet Membres Pastoral
class _PasteurMembresTab extends StatelessWidget {
  const _PasteurMembresTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final membres = [
      {'nom': 'Jean Kabongo', 'paroisse': 'Paroisse Centrale', 'statut': 'Actif'},
      {'nom': 'Marie Ntumba', 'paroisse': 'Paroisse Limete', 'statut': 'Baptisée'},
      {'nom': 'Paul Kalala', 'paroisse': 'Paroisse Bandal', 'statut': 'Responsable JPC'},
      {'nom': 'Ruth Mwamba', 'paroisse': 'Paroisse Centrale', 'statut': 'Choriste'},
      {'nom': 'David Ilunga', 'paroisse': 'Paroisse Limete', 'statut': 'Diacre'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Membres & Fidèles', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: membres.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
        itemBuilder: (context, index) {
          final m = membres[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFF1F5F9),
              child: Text(m['nom']![0], style: const TextStyle(color: Color(0xFF1E3A5F), fontWeight: FontWeight.bold)),
            ),
            title: Text(m['nom']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text('${m['paroisse']} • ${m['statut']}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          );
        },
      ),
    );
  }
}

/// Onglet Chat Pastoral
class _PasteurChatTab extends StatelessWidget {
  const _PasteurChatTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Messagerie Pastorale', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.chat_bubble_outline, size: 48, color: Color(0xFF94A3B8)),
            SizedBox(height: 12),
            Text('Aucun nouveau message', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            SizedBox(height: 4),
            Text('Les demandes d\'entretien et messages s\'affichent ici.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }
}

/// Onglet Réunions Pastoral
class _PasteurReunionsTab extends StatelessWidget {
  const _PasteurReunionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Réunions Pastorales', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildReunionCard('Conseil pastoral', 'Aujourd\'hui, 17h00', 'Bureau pastoral'),
          const SizedBox(height: 10),
          _buildReunionCard('Comité des diacres', 'Vendredi, 18h00', 'Salle Annexe'),
          const SizedBox(height: 10),
          _buildReunionCard('Prière des serviteurs', 'Samedi, 06h30', 'Temple Principal'),
        ],
      ),
    );
  }

  Widget _buildReunionCard(String titre, String date, String lieu) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text('$date • $lieu', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            ],
          ),
          const Icon(Icons.calendar_today_outlined, size: 20, color: Color(0xFF1E3A5F)),
        ],
      ),
    );
  }
}

/// Onglet Publications Pastoral
class _PasteurPublicationsTab extends StatelessWidget {
  const _PasteurPublicationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Publications à Valider', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPubCard('Programme de jeûne et prière du mois', 'Rédigé par Secrétariat', 'En attente'),
          const SizedBox(height: 10),
          _buildPubCard('Annonce Campagne d\'Évangélisation', 'Rédigé par Comité Mission', 'En attente'),
        ],
      ),
    );
  }

  Widget _buildPubCard(String titre, String auteur, String statut) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(auteur, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A5F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () {},
            child: const Text('Valider', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

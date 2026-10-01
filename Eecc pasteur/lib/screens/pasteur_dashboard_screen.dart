import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../theme/eecc_theme.dart';
import 'pasteur_direct_screen.dart';
import 'pasteur_offrande_screen.dart';

/// Tableau de bord Pastoral fidèle à la maquette 01_dashboard.png
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
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: EeccTheme.bgWhite,
          border: Border(top: BorderSide(color: EeccTheme.borderGrey, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: EeccTheme.navy,
          unselectedItemColor: EeccTheme.textLight,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          backgroundColor: EeccTheme.bgWhite,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
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
    final supabase = EeccSupabaseService();

    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('Tableau de bord', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: EeccTheme.navyDark),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEFF6FF),
              child: const Icon(Icons.person, color: EeccTheme.navy, size: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titre & Salutation
            const Text(
              'Paix du Christ, Pasteur David',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: EeccTheme.navyDark),
            ),
            const SizedBox(height: 2),
            const Text(
              'Supervision générale de l\'église et des paroisses',
              style: TextStyle(fontSize: 12.5, color: EeccTheme.textMuted),
            ),
            const SizedBox(height: 18),

            // Bandeau Culte en direct si actif
            StreamBuilder<EeccLiveSession?>(
              stream: supabase.ecouterLiveEnCours(),
              builder: (context, snapshot) {
                final live = snapshot.data;
                if (live != null && live.isLive) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8E8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sensors, color: Colors.red, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('CULTE EN DIRECT ACTIF', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
                              Text(live.titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const PasteurDirectScreen()));
                          },
                          child: const Text('Régie', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // 4 Cartes Métriques (2x2) de la maquette 01_dashboard.png
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    number: '248',
                    label: 'Membres',
                    subtitle: 'Actifs enregistrés',
                    icon: Icons.people_outline,
                    iconColor: const Color(0xFF2563EB),
                    bgIcon: const Color(0xFFEFF6FF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    number: '3',
                    label: 'Paroisses',
                    subtitle: 'Kinshasa & Extension',
                    icon: Icons.church_outlined,
                    iconColor: const Color(0xFF059669),
                    bgIcon: const Color(0xFFECFDF5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    number: '6',
                    label: 'Prières',
                    subtitle: 'En attente de suivi',
                    icon: Icons.pan_tool_outlined,
                    iconColor: const Color(0xFFD97706),
                    bgIcon: const Color(0xFFFFFBEB),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    number: '2',
                    label: 'Publications',
                    subtitle: 'À valider avant envoi',
                    icon: Icons.edit_note_outlined,
                    iconColor: const Color(0xFF7C3AED),
                    bgIcon: const Color(0xFFF5F3FF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section "Réunions à venir" (Maquette 01_dashboard.png)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Réunions à venir',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: EeccTheme.navyDark),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Voir tout >', style: TextStyle(fontSize: 12.5, color: EeccTheme.navy)),
                ),
              ],
            ),
            const SizedBox(height: 6),

            _buildMeetingItem(
              title: 'Conseil pastoral & diaconat',
              time: 'Mercredi 07 Octobre • 17h30',
              location: 'Bureau Pastoral / Visio',
            ),
            _buildMeetingItem(
              title: 'Entretien d\'accompagnement spirituel',
              time: 'Jeudi 08 Octobre • 10h00',
              location: 'Salle d\'entretien',
            ),
            _buildMeetingItem(
              title: 'Répétition générale & Prière des ouvriers',
              time: 'Samedi 10 Octobre • 16h00',
              location: 'Grand Temple EECC',
            ),

            const SizedBox(height: 20),
            // Actions pastorales rapides
            const Text(
              'Actions pastorales rapides',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: EeccTheme.navyDark),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PasteurDirectScreen()));
                    },
                    icon: const Icon(Icons.sensors, size: 18, color: Colors.red),
                    label: const Text('Lancer le Live', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PasteurOffrandeScreen()));
                    },
                    icon: const Icon(Icons.account_balance_wallet_outlined, size: 18, color: Colors.teal),
                    label: const Text('Finances & Dîmes', style: TextStyle(fontSize: 12)),
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
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EeccTheme.bgWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EeccTheme.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                number,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: EeccTheme.navyDark),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: bgIcon, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: EeccTheme.navyDark)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: EeccTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _buildMeetingItem({required String title, required String time, required String location}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: EeccTheme.bgGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EeccTheme.borderGrey),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.event_available, color: EeccTheme.navy, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: EeccTheme.navyDark)),
                const SizedBox(height: 2),
                Text('$time • $location', style: const TextStyle(fontSize: 11, color: EeccTheme.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Onglet Membres
class _PasteurMembresTab extends StatelessWidget {
  const _PasteurMembresTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(title: const Text('Registre des Membres')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        separatorBuilder: (_, __) => const Divider(height: 1, color: EeccTheme.borderGrey),
        itemBuilder: (context, i) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFEFF6FF),
              child: Text('M${i + 1}', style: const TextStyle(color: EeccTheme.navy, fontWeight: FontWeight.bold)),
            ),
            title: Text('Membre Fidèle #${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
            subtitle: const Text('Paroisse Centrale • Baptisé', style: TextStyle(fontSize: 11.5, color: EeccTheme.textMuted)),
            trailing: const Icon(Icons.chevron_right, size: 18, color: EeccTheme.textLight),
          );
        },
      ),
    );
  }
}

/// Onglet Chat
class _PasteurChatTab extends StatelessWidget {
  const _PasteurChatTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(title: const Text('Discussions Pastorales')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.chat_bubble_outline, size: 54, color: EeccTheme.textLight),
            SizedBox(height: 12),
            Text('Messagerie pastorale sécurisée', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 4),
            Text('Échanges avec le conseil et les diacres', style: TextStyle(color: EeccTheme.textMuted, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

/// Onglet Réunions
class _PasteurReunionsTab extends StatelessWidget {
  const _PasteurReunionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(title: const Text('Calendrier des Réunions')),
      body: const Center(
        child: Text('Gestion et planification des réunions de prière et pastorat'),
      ),
    );
  }
}

/// Onglet Publications
class _PasteurPublicationsTab extends StatelessWidget {
  const _PasteurPublicationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(title: const Text('Validation des Publications')),
      body: const Center(
        child: Text('Approbation des annonces et communications officielles'),
      ),
    );
  }
}

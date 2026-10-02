import 'package:flutter/material.dart';
import '../theme/eecc_theme.dart';

/// Tableau de bord Comité pixel-perfect conforme à la maquette Eecc comité/01_dashboard.png
class ComiteDashboardScreen extends StatefulWidget {
  const ComiteDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ComiteDashboardScreen> createState() => _ComiteDashboardScreenState();
}

class _ComiteDashboardScreenState extends State<ComiteDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const _ComiteOverviewTab(),
    const _ComitesTab(),
    const _ChoralesTab(),
    const _MessagesTab(),
    const _ProfilTab(),
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
              icon: Icon(Icons.groups_outlined),
              activeIcon: Icon(Icons.groups),
              label: 'Comités',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note_outlined),
              activeIcon: Icon(Icons.music_note),
              label: 'Chorales',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

/// Onglet Vue d'ensemble fidèle à 01_dashboard.png de Eecc comité
class _ComiteOverviewTab extends StatelessWidget {
  const _ComiteOverviewTab({Key? key}) : super(key: key);

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
            // Salutation fidèle à la maquette
            const Text(
              'Bonjour, Grâce Kabongo',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 28),

            // Section "Mes rattachements" (Maquette 01_dashboard.png)
            const Text(
              'Mes rattachements',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // Carte 1 : Comité d'accueil / Responsable
            _buildRattachementCard(
              title: 'Comité d\'accueil',
              role: 'Responsable',
              onTap: () {},
            ),
            const SizedBox(height: 10),

            // Carte 2 : Chorale Voix de Grâce / Membre
            _buildRattachementCard(
              title: 'Chorale Voix de Grâce',
              role: 'Membre',
              onTap: () {},
            ),

            const SizedBox(height: 28),

            // Section "À venir" (Maquette 01_dashboard.png)
            const Text(
              'À venir',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // Carte Événement à venir
            Container(
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
                        'Répétition générale',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Samedi, 15h00',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xFF1E3A5F),
                    size: 22,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRattachementCard({
    required String title,
    required String role,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: const TextStyle(
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
    );
  }
}

/// Onglet Comités
class _ComitesTab extends StatelessWidget {
  const _ComitesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comites = [
      {'nom': 'Comité d\'accueil & Protocole', 'role': 'Responsable', 'membres': 18},
      {'nom': 'Comité Multimédia & Régie', 'role': 'Membre', 'membres': 12},
      {'nom': 'Comité Intercession', 'role': 'Membre', 'membres': 24},
      {'nom': 'Comité Social & Entraide', 'role': 'Observateur', 'membres': 9},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mes Comités', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: comites.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final c = comites[index];
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
                    Text(c['nom'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('${c['role']} • ${c['membres']} membres', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Onglet Chorales
class _ChoralesTab extends StatelessWidget {
  const _ChoralesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chorales & Louange', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Chorale Voix de Grâce', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Chip(
                      label: Text('Membre Actif', style: TextStyle(fontSize: 11, color: Color(0xFF1E3A5F), fontWeight: FontWeight.bold)),
                      backgroundColor: Color(0xFFEFF6FF),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Pupitre : Alto • Répétitions le jeudi 17h et samedi 15h.', style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
                const Divider(height: 20),
                Row(
                  children: const [
                    Icon(Icons.library_music_outlined, size: 16, color: Color(0xFF1E3A5F)),
                    SizedBox(width: 6),
                    Text('Répertoire : 14 cantiques au programme ce mois', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Onglet Messages
class _MessagesTab extends StatelessWidget {
  const _MessagesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Messages & Circulaires', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMessageItem(
            titre: 'Ordre du jour - Répétition générale',
            expediteur: 'Direction Chorale Voix de Grâce',
            date: 'Hier, 18h20',
          ),
          const SizedBox(height: 10),
          _buildMessageItem(
            titre: 'Planning des permanences d\'accueil de dimanche',
            expediteur: 'Secrétariat Comité d\'accueil',
            date: '02 Octobre',
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem({required String titre, required String expediteur, required String date}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
            child: const Icon(Icons.mail_outline, size: 18, color: Color(0xFF1E3A5F)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                const SizedBox(height: 3),
                Text(expediteur, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Onglet Profil
class _ProfilTab extends StatelessWidget {
  const _ProfilTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mon Profil Responsable', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFEFF6FF),
              child: Text('GK', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
            ),
            const SizedBox(height: 14),
            const Text('Grâce Kabongo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Matricule : EECC-COM-0042', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone_outlined, color: Color(0xFF1E3A5F)),
              title: const Text('+243 820 000 042', style: TextStyle(fontSize: 14)),
              subtitle: const Text('Téléphone principal'),
            ),
            ListTile(
              leading: const Icon(Icons.church_outlined, color: Color(0xFF1E3A5F)),
              title: const Text('Paroisse Centrale de Kinshasa', style: TextStyle(fontSize: 14)),
              subtitle: const Text('Paroisse d\'attachement'),
            ),
            ListTile(
              leading: const Icon(Icons.badge_outlined, color: Color(0xFF1E3A5F)),
              title: const Text('Responsable Comité d\'accueil', style: TextStyle(fontSize: 14)),
              subtitle: const Text('Rôle officiel'),
            ),
          ],
        ),
      ),
    );
  }
}

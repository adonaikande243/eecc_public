import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../../theme/eecc_theme.dart';
import '../communication/communications_screen.dart';
import '../auth/login_screen.dart';

/// Écran d'accueil fidèle aux maquettes 02_ecran_principal.png et 04_accueil_visiteur.png
class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({Key? key, this.onNavigateTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supabase = EeccSupabaseService();

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: EeccTheme.navyDark),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: EeccTheme.navy, width: 1.5),
              ),
              child: const Icon(Icons.church_outlined, size: 16, color: EeccTheme.navy),
            ),
            const SizedBox(width: 8),
            const Text('EECC', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: EeccTheme.navyDark),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CommunicationsScreen()),
                  );
                },
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: EeccTheme.redLive,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titre & Sous-titre de bienvenue
            const Text(
              'Bienvenue à l\'EECC',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: EeccTheme.navyDark,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Église Évangélique les Cohéritiers du Christ',
              style: TextStyle(
                fontSize: 13,
                color: EeccTheme.textMuted,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),

            // Bandeau dynamique du direct (Écoute en temps réel Supabase)
            StreamBuilder<EeccLiveSession?>(
              stream: supabase.ecouterLiveEnCours(),
              builder: (context, snapshot) {
                final live = snapshot.data;
                final isStreaming = live != null && live.isLive && live.surAppMobile;

                return InkWell(
                  onTap: () {
                    if (onNavigateTab != null) {
                      onNavigateTab!(1); // Onglet Direct
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: EeccTheme.redLiveBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: EeccTheme.redLive,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isStreaming
                                    ? '• En direct — ${live.titre}'
                                    : '• En direct — Culte de dimanche',
                                style: const TextStyle(
                                  color: EeccTheme.redLiveText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isStreaming
                                    ? 'Prédication en cours • Avec ${live.predicateur}'
                                    : 'Prédication en cours • Avec Pasteur David Kande',
                                style: TextStyle(
                                  color: Colors.red.shade900.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: EeccTheme.redLiveText, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Carte du Verset du jour (Jérémie 29:11)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EeccTheme.bgGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: EeccTheme.borderGrey, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'VERSET DU JOUR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: EeccTheme.textLight,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '« Car je connais les projets que j\'ai formés sur vous, dit l\'Éternel, projets de paix et non de malheur, afin de vous donner un avenir et de l\'espérance. »',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontStyle: FontStyle.italic,
                      color: EeccTheme.navyDark,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '— Jérémie 29:11',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: EeccTheme.navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3 Cartes d'actions rapides (Lire la Bible, Prédications, JPC)
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.menu_book_outlined,
                    label: 'Lire la Bible',
                    onTap: () {
                      if (onNavigateTab != null) onNavigateTab!(3);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.ondemand_video_outlined,
                    label: 'Prédications',
                    onTap: () {
                      if (onNavigateTab != null) onNavigateTab!(2);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.groups_outlined,
                    label: 'JPC & Jeunesse',
                    onTap: () {
                      if (onNavigateTab != null) onNavigateTab!(4);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section "Communications récentes"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Communications récentes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: EeccTheme.navyDark,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CommunicationsScreen()),
                    );
                  },
                  child: const Text(
                    'Voir tout >',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: EeccTheme.navy,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Liste des annonces
            _buildCommunicationItem(
              tag: 'Annonce',
              tagColor: const Color(0xFFE0E7FF),
              tagTextColor: const Color(0xFF3730A3),
              title: 'Programme du jeûne et prières du mois de consécration',
              date: 'Aujourd\'hui, 08:30',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CommunicationsScreen()),
                );
              },
            ),
            _buildCommunicationItem(
              tag: 'Événement',
              tagColor: const Color(0xFFDCFCE7),
              tagTextColor: const Color(0xFF166534),
              title: 'Grand Concert de louange & d\'adoration de la jeunesse JPC',
              date: '12 Octobre 2026',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CommunicationsScreen()),
                );
              },
            ),
            _buildCommunicationItem(
              tag: 'Note pastorale',
              tagColor: const Color(0xFFFEF3C7),
              tagTextColor: const Color(0xFF92400E),
              title: 'Horaires des cultes d\'enseignement et d\'intercession en semaine',
              date: '05 Octobre 2026',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CommunicationsScreen()),
                );
              },
            ),
            const SizedBox(height: 24),

            // Boutons d'actions visiteurs (Maquette 04_accueil_visiteur.png)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vous naviguez en mode visiteur')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: EeccTheme.borderGrey, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Visiteur',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: EeccTheme.navyDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EeccTheme.navy,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: EeccTheme.bgWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EeccTheme.borderGrey, width: 1),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: EeccTheme.navy, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: EeccTheme.navyDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunicationItem({
    required String tag,
    required Color tagColor,
    required Color tagTextColor,
    required String title,
    required String date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: EeccTheme.bgWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: EeccTheme.borderGrey, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tagColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: tagTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: EeccTheme.navyDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 11,
                      color: EeccTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: EeccTheme.textLight),
          ],
        ),
      ),
    );
  }
}

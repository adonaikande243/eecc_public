import 'package:flutter/material.dart';
import '../theme/eecc_theme.dart';
import '../screens/communication/communications_screen.dart';
import '../screens/media/sermons_screen.dart';
import '../screens/media/praise_screen.dart';
import '../screens/resources/events_screen.dart';
import '../screens/offering/offering_flow_screen.dart';
import '../screens/prayer/priere_screen.dart';
import '../screens/resources/documentation_screen.dart';
import '../screens/resources/books_screen.dart';

/// Menu secondaire latéral fidèle à la maquette 03_menu_secondaire.png
class SecondaryMenuDrawer extends StatelessWidget {
  const SecondaryMenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: EeccTheme.bgWhite,
      child: Column(
        children: [
          // En-tête du Menu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            color: EeccTheme.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(color: Colors.white38, width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(Icons.church_outlined, color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'EECC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Église Évangélique les Cohéritiers du Christ',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Liste des 10 rubriques de la maquette
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.campaign_outlined,
                  title: 'Communications',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CommunicationsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.ondemand_video_outlined,
                  title: 'Prédications',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SermonsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.library_music_outlined,
                  title: 'Louanges & Cantiques',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PraiseScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.event_note_outlined,
                  title: 'Événements',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EventsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.volunteer_activism_outlined,
                  title: 'Dîmes & Offrandes',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OfferingFlowScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.pan_tool_outlined,
                  title: 'Demandes de prière',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PriereScreen()),
                    );
                  },
                ),
                const Divider(height: 16, color: EeccTheme.borderGrey),
                _buildDrawerItem(
                  context,
                  icon: Icons.menu_book_outlined,
                  title: 'Documentation & Statuts',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DocumentationScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.auto_stories_outlined,
                  title: 'Livres recommandés',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BooksScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Paramètres',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Paramètres de l\'application')),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Aide & Contact',
                  onTap: () {
                    Navigator.pop(context);
                    showAboutDialog(
                      context: context,
                      applicationName: 'EECC Mobile',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2026 Église Évangélique les Cohéritiers du Christ',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: EeccTheme.navy, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: EeccTheme.navyDark,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18, color: EeccTheme.textLight),
      dense: true,
      horizontalTitleGap: 12,
      onTap: onTap,
    );
  }
}

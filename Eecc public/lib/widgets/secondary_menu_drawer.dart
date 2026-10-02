import 'package:flutter/material.dart';
import '../screens/communication/communications_screen.dart';
import '../screens/media/sermons_screen.dart';
import '../screens/media/praise_screen.dart';
import '../screens/resources/events_screen.dart';
import '../screens/offering/offering_flow_screen.dart';
import '../screens/prayer/priere_screen.dart';
import '../screens/resources/documentation_screen.dart';
import '../screens/resources/books_screen.dart';

/// Menu secondaire latéral identique pixel-perfect à 03_menu_secondaire.png
class SecondaryMenuDrawer extends StatelessWidget {
  const SecondaryMenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.78,
      child: SafeArea(
        child: Column(
          children: [
            // En-tête : "Menu" à gauche, chevron "<" à droite (Maquette 03_menu_secondaire.png)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Color(0xFF0F172A), size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Liste exacte des 10 rubriques avec séparateurs fins
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.wifi,
                    title: 'Communications',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunicationsScreen()));
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.play_circle_outline,
                    title: 'Prédications',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SermonsScreen()));
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.people_outline,
                    title: 'Louanges',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PraiseScreen()));
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.calendar_today_outlined,
                    title: 'Événements',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const EventsScreen()));
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.credit_card_outlined,
                    title: 'Offrandes',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const OfferingFlowScreen()));
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.pan_tool_outlined,
                    title: 'Demandes de prière',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PriereScreen()));
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Documentation',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentationScreen()));
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.menu_book_outlined,
                    title: 'Livres',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const BooksScreen()));
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'Paramètres',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paramètres')));
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.smartphone_outlined,
                    title: 'Aide',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assistance')));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          leading: Icon(icon, color: const Color(0xFF1E3A5F), size: 22),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0F172A),
            ),
          ),
          onTap: onTap,
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
      ],
    );
  }
}

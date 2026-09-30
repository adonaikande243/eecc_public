import 'package:flutter/material.dart';
import '../live/live_screen.dart';
import '../archives/archives_list_screen.dart';
import '../bible/bible_home_screen.dart';
import '../../theme/eecc_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accueil EECC')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuCard(context, 'Direct', Icons.live_tv, const LiveScreen()),
          _buildMenuCard(context, 'Archives', Icons.video_library, const ArchivesListScreen()),
          _buildMenuCard(context, 'Bible', Icons.menu_book, const BibleHomeScreen()),
          _buildMenuCard(context, 'Offrandes', Icons.volunteer_activism, null), // Placeholder
          _buildMenuCard(context, 'Prière', Icons.front_hand, null), // Placeholder
          _buildMenuCard(context, 'Profil', Icons.person, null), // Placeholder
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Widget? targetScreen) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          if (targetScreen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetScreen),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: EeccTheme.violet),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';
import 'bible_reading_screen.dart';

/// Écran d'accueil de la Bible fidèle à la maquette 24_bible_accueil.png
class BibleHomeScreen extends StatefulWidget {
  const BibleHomeScreen({Key? key}) : super(key: key);

  @override
  State<BibleHomeScreen> createState() => _BibleHomeScreenState();
}

class _BibleHomeScreenState extends State<BibleHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _ancienTestament = [
    {'nom': 'Genèse', 'chapitres': 50},
    {'nom': 'Exode', 'chapitres': 40},
    {'nom': 'Lévitique', 'chapitres': 27},
    {'nom': 'Nombres', 'chapitres': 36},
    {'nom': 'Deutéronome', 'chapitres': 34},
    {'nom': 'Josué', 'chapitres': 24},
    {'nom': 'Juges', 'chapitres': 21},
    {'nom': 'Ruth', 'chapitres': 4},
    {'nom': '1 Samuel', 'chapitres': 31},
    {'nom': '2 Samuel', 'chapitres': 24},
    {'nom': '1 Rois', 'chapitres': 22},
    {'nom': '2 Rois', 'chapitres': 25},
    {'nom': 'Psaumes', 'chapitres': 150},
    {'nom': 'Proverbes', 'chapitres': 31},
    {'nom': 'Ésaïe', 'chapitres': 66},
    {'nom': 'Jérémie', 'chapitres': 52},
  ];

  final List<Map<String, dynamic>> _nouveauTestament = [
    {'nom': 'Matthieu', 'chapitres': 28},
    {'nom': 'Marc', 'chapitres': 16},
    {'nom': 'Luc', 'chapitres': 24},
    {'nom': 'Jean', 'chapitres': 21},
    {'nom': 'Actes', 'chapitres': 28},
    {'nom': 'Romains', 'chapitres': 16},
    {'nom': '1 Corinthiens', 'chapitres': 16},
    {'nom': '2 Corinthiens', 'chapitres': 13},
    {'nom': 'Galates', 'chapitres': 6},
    {'nom': 'Éphésiens', 'chapitres': 6},
    {'nom': 'Philippiens', 'chapitres': 4},
    {'nom': 'Colossiens', 'chapitres': 4},
    {'nom': 'Hébreux', 'chapitres': 13},
    {'nom': 'Apocalypse', 'chapitres': 22},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('La Sainte Bible', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un livre, un mot, un verset...',
                prefixIcon: const Icon(Icons.search, color: EeccTheme.textLight),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: EeccTheme.borderGrey),
                ),
                filled: true,
                fillColor: EeccTheme.bgGrey,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),

          // 3 Cartes de raccourcis (Favoris, Notes, Historique)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildShortcutCard(
                    icon: Icons.bookmark_outline,
                    label: 'Favoris',
                    color: const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildShortcutCard(
                    icon: Icons.edit_note,
                    label: 'Notes',
                    color: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildShortcutCard(
                    icon: Icons.history,
                    label: 'Historique',
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Onglets Ancien Testament & Nouveau Testament
          TabBar(
            controller: _tabController,
            indicatorColor: EeccTheme.navy,
            labelColor: EeccTheme.navy,
            unselectedLabelColor: EeccTheme.textMuted,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: 'Ancien Testament (39)'),
              Tab(text: 'Nouveau Testament (27)'),
            ],
          ),

          // Liste des livres
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBooksList(_ancienTestament),
                _buildBooksList(_nouveauTestament),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutCard({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: EeccTheme.bgGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EeccTheme.borderGrey),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: EeccTheme.navyDark)),
        ],
      ),
    );
  }

  Widget _buildBooksList(List<Map<String, dynamic>> books) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: EeccTheme.borderGrey),
      itemBuilder: (context, index) {
        final b = books[index];
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          title: Text(
            b['nom'],
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EeccTheme.navyDark),
          ),
          subtitle: Text(
            '${b['chapitres']} chapitres',
            style: const TextStyle(fontSize: 11.5, color: EeccTheme.textMuted),
          ),
          trailing: const Icon(Icons.chevron_right, size: 18, color: EeccTheme.textLight),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BibleReadingScreen(livre: b['nom'], chapitre: 1),
              ),
            );
          },
        );
      },
    );
  }
}

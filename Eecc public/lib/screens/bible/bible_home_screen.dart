import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';
import 'bible_reading_screen.dart';

/// Écran d'accueil de la Bible pixel-perfect conforme à la maquette 24_bible_accueil.png
class BibleHomeScreen extends StatefulWidget {
  const BibleHomeScreen({Key? key}) : super(key: key);

  @override
  State<BibleHomeScreen> createState() => _BibleHomeScreenState();
}

class _BibleHomeScreenState extends State<BibleHomeScreen> {
  final List<String> _ancienTestament = const [
    'Genèse',
    'Exode',
    'Lévitique',
    'Nombres',
    'Deutéronome',
    'Josué',
    'Juges',
    'Ruth',
    '1 Samuel',
    '2 Samuel',
    '1 Rois',
    '2 Rois',
    'Psaumes',
    'Proverbes',
    'Ecclésiaste',
    'Cantique des Cantiques',
    'Ésaïe',
    'Jérémie',
    'Lamentations',
    'Ézéchiel',
    'Daniel',
    'Osée',
    'Joël',
    'Amos',
    'Abdias',
    'Jonas',
    'Michée',
    'Nahum',
    'Habacuc',
    'Sophonie',
    'Aggée',
    'Zacharie',
    'Malachie',
  ];

  final List<String> _nouveauTestament = const [
    'Matthieu',
    'Marc',
    'Luc',
    'Jean',
    'Actes',
    'Romains',
    '1 Corinthiens',
    '2 Corinthiens',
    'Galates',
    'Éphésiens',
    'Philippiens',
    'Colossiens',
    '1 Thessaloniciens',
    '2 Thessaloniciens',
    '1 Timothée',
    '2 Timothée',
    'Tite',
    'Philémon',
    'Hébreux',
    'Jacques',
    '1 Pierre',
    '2 Pierre',
    '1 Jean',
    '2 Jean',
    '3 Jean',
    'Jude',
    'Apocalypse',
  ];

  void _openBook(String livre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BibleReadingScreen(
          livre: livre,
          chapitre: livre == 'Psaumes' ? 23 : 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Bible',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 3 Cartes de raccourcis : Favoris, Notes, Historique
          Row(
            children: [
              Expanded(
                child: _buildShortcutCard(
                  icon: Icons.check,
                  label: 'Favoris',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildShortcutCard(
                  icon: Icons.description_outlined,
                  label: 'Notes',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildShortcutCard(
                  icon: Icons.calendar_today_outlined,
                  label: 'Historique',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // En-tête ANCIEN TESTAMENT
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'ANCIEN TESTAMENT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.8,
              ),
            ),
          ),

          // Liste des livres de l'Ancien Testament
          ..._ancienTestament.map((livre) => _buildBookTile(livre)),

          const SizedBox(height: 18),

          // En-tête NOUVEAU TESTAMENT
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'NOUVEAU TESTAMENT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.8,
              ),
            ),
          ),

          // Liste des livres du Nouveau Testament
          ..._nouveauTestament.map((livre) => _buildBookTile(livre)),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildShortcutCard({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF1E3A5F)),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookTile(String livre) {
    return InkWell(
      onTap: () => _openBook(livre),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              livre,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}

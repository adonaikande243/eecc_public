import 'package:flutter/material.dart';

/// Écran de lecture biblique identique pixel-perfect à 26_bible_lecture.png (Psaumes 23)
class BibleReadingScreen extends StatefulWidget {
  final String livre;
  final int chapitre;

  const BibleReadingScreen({
    Key? key,
    this.livre = 'Psaumes',
    this.chapitre = 23,
  }) : super(key: key);

  @override
  State<BibleReadingScreen> createState() => _BibleReadingScreenState();
}

class _BibleReadingScreenState extends State<BibleReadingScreen> {
  int _selectedBottomIndex = 0; // 0: Favori, 1: Note, 2: Écouter, 3: Partager

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF0F172A), size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.livre} ${widget.chapitre}',
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF0F172A), size: 26),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.livre} ${widget.chapitre}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Verset 1
                  _buildVerseLine(
                    number: '1',
                    text: 'L\'Éternel est mon berger : je ne manquerai de rien.',
                  ),
                  const SizedBox(height: 16),

                  // Verset 2
                  _buildVerseLine(
                    number: '2',
                    text: 'Il me fait reposer dans de verts pâturages, il me dirige près des eaux paisibles.',
                  ),
                  const SizedBox(height: 16),

                  // Verset 3 (Surligné avec fond gris très doux comme dans la maquette 26_bible_lecture.png)
                  _buildVerseLine(
                    number: '3',
                    text: 'Il restaure mon âme, il me conduit dans les sentiers\nde la justice, à cause de son nom.',
                    isHighlighted: true,
                  ),
                  const SizedBox(height: 16),

                  // Verset 4
                  _buildVerseLine(
                    number: '4',
                    text: 'Quand je marche dans la vallée de l\'ombre de la mort, je ne crains aucun mal, car tu es avec moi.',
                  ),
                ],
              ),
            ),
          ),

          // Barre inférieure à 4 onglets : Favori, Note, Écouter, Partager (Maquette 26_bible_lecture.png)
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomTab(0, Icons.check, 'Favori'),
                _buildBottomTab(1, Icons.description_outlined, 'Note'),
                _buildBottomTab(2, Icons.play_circle_outline, 'Écouter'),
                _buildBottomTab(3, Icons.people_outline, 'Partager'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerseLine({required String number, required String text, bool isHighlighted = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 1.0),
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: isHighlighted ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2) : EdgeInsets.zero,
            color: isHighlighted ? const Color(0xFFF1F5F9) : Colors.transparent,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.45,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomTab(int index, IconData icon, String label) {
    final isSelected = _selectedBottomIndex == index;
    final color = isSelected ? const Color(0xFFD97706) : const Color(0xFF64748B);

    return InkWell(
      onTap: () => setState(() => _selectedBottomIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Module de projection biblique fidèle à la maquette 17_media_bible.png
class BibleProjectionDialog extends StatefulWidget {
  const BibleProjectionDialog({Key? key}) : super(key: key);

  @override
  State<BibleProjectionDialog> createState() => _BibleProjectionDialogState();
}

class _BibleProjectionDialogState extends State<BibleProjectionDialog> {
  String _selectedBook = 'Jean';
  int _selectedChapter = 3;
  int _selectedVerse = 16;
  int _selectedThemeIndex = 1; // 0: Noir/Or, 1: Bleu Nuit, 2: Blanc, 3: Pourpre

  final List<String> _books = ['Genèse', 'Exode', 'Psaumes', 'Proverbes', 'Ésaïe', 'Matthieu', 'Marc', 'Luc', 'Jean', 'Romains', 'Apocalypse'];

  final Map<int, String> _themes = {
    0: 'Noir & Or',
    1: 'Bleu Nuit Pro',
    2: 'Blanc Épuré',
    3: 'Pourpre Royal',
  };

  final List<Color> _bgColors = [
    const Color(0xFF0F172A),
    const Color(0xFF1E3A8A),
    Colors.white,
    const Color(0xFF581C87),
  ];

  final List<Color> _textColors = [
    const Color(0xFFFBBF24), // Or
    Colors.white,
    const Color(0xFF0F172A),
    Colors.white,
  ];

  String _getVerseText() {
    if (_selectedBook == 'Jean' && _selectedChapter == 3 && _selectedVerse == 16) {
      return '« Car Dieu a tant aimé le monde qu\'il a donné son Fils unique, afin que quiconque croit en lui ne périsse point, mais qu\'il ait la vie éternelle. »';
    }
    return '« Ta parole est une lampe à mes pieds, et une lumière sur mon sentier. »';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 950,
        height: 620,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // En-tête
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.menu_book, color: Color(0xFF3B82F6), size: 24),
                    SizedBox(width: 10),
                    Text(
                      'PROJECTION BIBLIQUE EN DIRECT',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.8),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: Colors.white12, height: 20),

            // Corps : Sélecteur gauche + Aperçu projection droite
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Sélecteur Livre / Chapitre / Verset (Gauche)
                  SizedBox(
                    width: 280,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('SÉLECTION DU PASSAGE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _selectedBook,
                            dropdownColor: const Color(0xFF1E293B),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Livre',
                              labelStyle: TextStyle(color: Colors.white60),
                              border: OutlineInputBorder(),
                            ),
                            items: _books.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                            onChanged: (val) => setState(() => _selectedBook = val!),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: '$_selectedChapter',
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    labelText: 'Chapitre',
                                    labelStyle: TextStyle(color: Colors.white60),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) => setState(() => _selectedChapter = int.tryParse(val) ?? 1),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  initialValue: '$_selectedVerse',
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    labelText: 'Verset',
                                    labelStyle: TextStyle(color: Colors.white60),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) => setState(() => _selectedVerse = int.tryParse(val) ?? 1),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Choix du thème visuel (4 vignettes 17_media_bible.png)
                          const Text('THÈME DE PROJECTION', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (int i = 0; i < 4; i++)
                                InkWell(
                                  onTap: () => setState(() => _selectedThemeIndex = i),
                                  child: Container(
                                    width: 52,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: _bgColors[i],
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: _selectedThemeIndex == i ? Colors.white : Colors.white30,
                                        width: _selectedThemeIndex == i ? 2.5 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text('Aa', style: TextStyle(color: _textColors[i], fontWeight: FontWeight.bold, fontSize: 13)),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'Thème actif : ${_themes[_selectedThemeIndex]}',
                            style: const TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Aperçu Diapositive Vidéoprojecteur (Droite)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('APERÇU SORTIE VIDÉOPROJECTEUR (16:9)', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _bgColors[_selectedThemeIndex],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white24),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 10),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$_selectedBook $_selectedChapter : $_selectedVerse',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: _selectedThemeIndex == 0 ? const Color(0xFFFBBF24) : _textColors[_selectedThemeIndex].withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  _getVerseText(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    height: 1.5,
                                    fontWeight: FontWeight.w600,
                                    color: _textColors[_selectedThemeIndex],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Boutons de déclenchement broadcast
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white24),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Verset envoyé dans la fenêtre de Prévisualisation')),
                                  );
                                },
                                child: const Text('Envoyer vers Preview'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDC2626),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('Verset projeté DIRECTEMENT sur l\'écran On-Air & Projecteur !'),
                                    ),
                                  );
                                },
                                child: const Text('PROJETER DIRECT (ON AIR)', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

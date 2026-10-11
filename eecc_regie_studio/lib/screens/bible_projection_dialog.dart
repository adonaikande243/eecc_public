import 'package:flutter/material.dart';
import '../core/services/bible_api_service.dart';

enum AnimationType { fondu, glissementBas, zoomIn, machineAEcrire }

/// Module de projection biblique avec animations avancées et personnalisation complète des couleurs
class BibleProjectionDialog extends StatefulWidget {
  const BibleProjectionDialog({Key? key}) : super(key: key);

  @override
  State<BibleProjectionDialog> createState() => _BibleProjectionDialogState();
}

class _BibleProjectionDialogState extends State<BibleProjectionDialog> with SingleTickerProviderStateMixin {
  final BibleApiService _bibleApi = BibleApiService();

  String _selectedVersion = 'LSG';
  String _selectedBook = 'Jean';
  int _selectedChapter = 3;
  int _selectedVerse = 16;

  // Personnalisation dynamique des couleurs
  Color _customBgColor = const Color(0xFF0F172A);
  Color _customTextColor = const Color(0xFFFBBF24); // Or
  double _fontSize = 24.0;

  // Type d'animation de projection
  AnimationType _animationType = AnimationType.fondu;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _scaleAnim;

  String _verseText = '« Car Dieu a tant aimé le monde qu\'il a donné son Fils unique, afin que quiconque croit en lui ne périsse point, mais qu\'il ait la vie éternelle. »';
  bool _isLoading = false;

  final List<String> _books = [
    'Genèse', 'Exode', 'Psaumes', 'Proverbes', 'Ésaïe', 'Jérémie',
    'Matthieu', 'Marc', 'Luc', 'Jean', 'Actes', 'Romains', 'Philippiens', 'Apocalypse'
  ];

  final List<Color> _paletteCouleursBg = [
    const Color(0xFF0F172A), // Noir Slate
    const Color(0xFF1E3A8A), // Bleu Nuit
    const Color(0xFF064E3B), // Vert Émeraude
    const Color(0xFF581C87), // Pourpre Royal
    const Color(0xFF7F1D1D), // Bordeaux
    const Color(0xFF18181B), // Noir Carbone
    const Color(0xFFF8FAFC), // Blanc Pur
  ];

  final List<Color> _paletteCouleursTexte = [
    const Color(0xFFFBBF24), // Or Sacré
    Colors.white,
    const Color(0xFF38BDF8), // Bleu Cyan
    const Color(0xFF4ADE80), // Vert Lumineux
    const Color(0xFFF472B6), // Rose Doux
    const Color(0xFF0F172A), // Noir Profond
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic),
    );
    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic),
    );

    _fetchVerse();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchVerse() async {
    setState(() => _isLoading = true);
    final text = await _bibleApi.chargerVerset(
      livre: _selectedBook,
      chapitre: _selectedChapter,
      verset: _selectedVerse,
      version: _selectedVersion,
    );
    if (mounted) {
      setState(() {
        _verseText = text;
        _isLoading = false;
      });
      _animCtrl.forward(from: 0.0);
    }
  }

  void _rejouerAnimation() {
    _animCtrl.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1E293B), width: 1.5),
      ),
      child: Container(
        width: 1080,
        height: 680,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // En-tête
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.menu_book, color: Color(0xFF38BDF8), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'PROJECTION BIBLIQUE : ANIMATIONS & HABILLAGE BROADCAST',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.8),
                        ),
                        Text(
                          'Transitions animées, sélection libre de palette chromatique et API multi-traductions',
                          style: TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ],
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
                  // Colonne Gauche : Sélecteurs de Texte & de Style (340px)
                  SizedBox(
                    width: 340,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF020617),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: ListView(
                        children: [
                          const Text('VERSION DE LA BIBLE (API)', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedVersion,
                            dropdownColor: const Color(0xFF1E293B),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF0F172A),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                            ),
                            items: BibleApiService.versionsDisponibles.map((v) {
                              return DropdownMenuItem(value: v.code, child: Text(v.name));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedVersion = val);
                                _fetchVerse();
                              }
                            },
                          ),
                          const SizedBox(height: 12),

                          // Livre & Chapitre & Verset
                          const Text('PASSAGE BIBLIQUE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedBook,
                                  dropdownColor: const Color(0xFF1E293B),
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFF0F172A),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                  ),
                                  items: _books.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedBook = val);
                                      _fetchVerse();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _selectedChapter,
                                  dropdownColor: const Color(0xFF1E293B),
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFF0F172A),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                  ),
                                  items: List.generate(50, (i) => i + 1).map((c) => DropdownMenuItem(value: c, child: Text('Ch. $c'))).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedChapter = val);
                                      _fetchVerse();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _selectedVerse,
                                  dropdownColor: const Color(0xFF1E293B),
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFF0F172A),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                  ),
                                  items: List.generate(80, (i) => i + 1).map((v) => DropdownMenuItem(value: v, child: Text('V. $v'))).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedVerse = val);
                                      _fetchVerse();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white12, height: 20),

                          // 1. Choix du type d'Animation
                          const Text('ANIMATION DE TRANSITION', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              _buildAnimChip('Fondu Enchaîné', AnimationType.fondu),
                              _buildAnimChip('Glissement (Slide)', AnimationType.glissementBas),
                              _buildAnimChip('Zoom Dynamique', AnimationType.zoomIn),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 2. Choix de la couleur de FOND (Background)
                          const Text('COULEUR DU FOND DE PROJECTION', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            children: _paletteCouleursBg.map((color) {
                              final isSel = _customBgColor == color;
                              return InkWell(
                                onTap: () => setState(() => _customBgColor = color),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSel ? Colors.amberAccent : Colors.white24,
                                      width: isSel ? 3.0 : 1.0,
                                    ),
                                  ),
                                  child: isSel ? const Icon(Icons.check, size: 16, color: Colors.amberAccent) : null,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),

                          // 3. Choix de la couleur du TEXTE
                          const Text('COULEUR DE TYPOGRAPHIE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            children: _paletteCouleursTexte.map((color) {
                              final isSel = _customTextColor == color;
                              return InkWell(
                                onTap: () => setState(() => _customTextColor = color),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSel ? const Color(0xFF38BDF8) : Colors.white24,
                                      width: isSel ? 3.0 : 1.0,
                                    ),
                                  ),
                                  child: isSel ? const Icon(Icons.check, size: 16, color: Colors.blue) : null,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),

                          // 4. Taille de police
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('TAILLE DU TEXTE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                              Text('${_fontSize.toInt()} px', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Slider(
                            value: _fontSize,
                            min: 16.0,
                            max: 36.0,
                            activeColor: const Color(0xFF38BDF8),
                            onChanged: (val) => setState(() => _fontSize = val),
                          ),

                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF38BDF8),
                              side: const BorderSide(color: Color(0xFF38BDF8)),
                              minimumSize: const Size(double.infinity, 36),
                            ),
                            icon: const Icon(Icons.play_arrow, size: 16),
                            label: const Text('REJOUER L\'ANIMATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            onPressed: _rejouerAnimation,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Aperçu Projection 16:9 Animé (Droite)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('APERÇU DU SIGNAL PROJETÉ (ÉCRAN TEMPLE & STREAMING)', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                            if (_isLoading)
                              const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amberAccent)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _customBgColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white24, width: 2),
                              boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10)],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                            child: AnimatedBuilder(
                              animation: _animCtrl,
                              builder: (context, child) {
                                Widget animatedContent = Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _verseText,
                                      style: TextStyle(
                                        color: _customTextColor,
                                        fontSize: _fontSize,
                                        fontWeight: FontWeight.bold,
                                        height: 1.45,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: _customTextColor.withOpacity(0.3)),
                                      ),
                                      child: Text(
                                        '$_selectedBook $_selectedChapter:$_selectedVerse ($_selectedVersion)',
                                        style: TextStyle(
                                          color: _customTextColor.withOpacity(0.95),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                );

                                if (_animationType == AnimationType.fondu) {
                                  return FadeTransition(opacity: _fadeAnim, child: animatedContent);
                                } else if (_animationType == AnimationType.glissementBas) {
                                  return SlideTransition(
                                    position: _slideAnim,
                                    child: FadeTransition(opacity: _fadeAnim, child: animatedContent),
                                  );
                                } else {
                                  return ScaleTransition(
                                    scale: _scaleAnim,
                                    child: FadeTransition(opacity: _fadeAnim, child: animatedContent),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Boutons de pilotage
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF059669),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                icon: const Icon(Icons.tv, size: 20),
                                label: const Text('ENVOYER EN STANDBY (PREVIEW)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Verset animé préparé en Prévisualisation'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDC2626),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                icon: const Icon(Icons.live_tv, size: 20),
                                label: const Text('PROJETER EN DIRECT (ON AIR)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Color(0xFFDC2626),
                                      content: Text('Verset projeté immédiatement à l\'antenne avec transition animée !'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                },
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

  Widget _buildAnimChip(String label, AnimationType type) {
    final isSel = _animationType == type;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : Colors.white70, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
      selected: isSel,
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: const Color(0xFF0F172A),
      onSelected: (val) {
        if (val) {
          setState(() => _animationType = type);
          _rejouerAnimation();
        }
      },
    );
  }
}

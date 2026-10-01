import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

/// Écran de lecture biblique fidèle à la maquette 26_bible_lecture.png
class BibleReadingScreen extends StatefulWidget {
  final String livre;
  final int chapitre;

  const BibleReadingScreen({
    Key? key,
    this.livre = 'Jean',
    this.chapitre = 3,
  }) : super(key: key);

  @override
  State<BibleReadingScreen> createState() => _BibleReadingScreenState();
}

class _BibleReadingScreenState extends State<BibleReadingScreen> {
  double _fontSize = 16.0;
  bool _isBookmarked = false;

  final List<String> _versets = [
    'Il y eut un homme d\'entre les pharisiens, nommé Nicodème, un chef des Juifs,',
    'qui vint, lui, auprès de Jésus, de nuit, et lui dit : Rabbi, nous savons que tu es un docteur venu de Dieu ; car personne ne peut faire ces miracles que tu fais, si Dieu n\'est avec lui.',
    'Jésus lui répondit : En vérité, en vérité, je te le dis, si un homme ne naît de nouveau, il ne peut voir le royaume de Dieu.',
    'Nicodème lui dit : Comment un homme peut-il naître quand il est vieux ? Peut-il rentrer dans le sein de sa mère et naître ?',
    'Jésus répondit : En vérité, en vérité, je te le dis, si un homme ne naît d\'eau et d\'Esprit, il ne peut entrer dans le royaume de Dieu.',
    'Ce qui est né de la chair est chair, et ce qui est né de l\'Esprit est esprit.',
    'Ne t\'étonne pas que je t\'aie dit : Il faut que vous naissiez de nouveau.',
    'Le vent souffle où il veut, et tu en entends le bruit ; mais tu ne sais d\'où il vient, ni où il va. Il en est ainsi de tout homme qui est né de l\'Esprit.',
    'Nicodème lui dit : Comment cela peut-il se faire ?',
    'Jésus lui répondit : Tu es le docteur d\'Israël, et tu ne sais pas ces choses !',
    'En vérité, en vérité, je te le dis, nous disons ce que nous savons, et nous rendons témoignage de ce que nous avons vu ; et vous ne recevez pas notre témoignage.',
    'Si vous ne croyez pas quand je vous ai parlé des choses terrestres, comment croirez-vous quand je vous parlerai des choses célestes ?',
    'Personne n\'est monté au ciel, si ce n\'est celui qui est descendu du ciel, le Fils de l\'homme qui est dans le ciel.',
    'Et comme Moïse éleva le serpent dans le désert, il faut de même que le Fils de l\'homme soit élevé,',
    'afin que quiconque croit en lui ait la vie éternelle.',
    'Car Dieu a tant aimé le monde qu\'il a donné son Fils unique, afin que quiconque croit en lui ne périsse point, mais qu\'il ait la vie éternelle.',
    'Dieu, en effet, n\'a pas envoyé son Fils dans le monde pour qu\'il juge le monde, mais pour que le monde soit sauvé par lui.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: Text('${widget.livre} ${widget.chapitre}', style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size),
            onPressed: () {
              setState(() {
                _fontSize = _fontSize == 16.0 ? 19.0 : (_fontSize == 19.0 ? 14.0 : 16.0);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.headphones_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lecture audio du chapitre démarrée')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'CHAPITRE ${widget.chapitre}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: EeccTheme.textLight,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: EeccTheme.navyDark,
                      height: 1.6,
                      fontFamily: 'Roboto',
                    ),
                    children: [
                      for (int i = 0; i < _versets.length; i++) ...[
                        WidgetSpan(
                          alignment: PlaceholderAlignment.top,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: _fontSize * 0.72,
                                fontWeight: FontWeight.bold,
                                color: EeccTheme.navy,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(text: '${_versets[i]} '),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Barre flottante inférieure à 4 actions (Maquette 26_bible_lecture.png)
          Positioned(
            left: 20,
            right: 20,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: EeccTheme.navy,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomAction(
                    icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    label: 'Favori',
                    onTap: () {
                      setState(() => _isBookmarked = !_isBookmarked);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_isBookmarked ? 'Ajouté aux favoris' : 'Retiré des favoris')),
                      );
                    },
                  ),
                  _buildBottomAction(
                    icon: Icons.note_add_outlined,
                    label: 'Note',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ajouter une note personnelle')),
                      );
                    },
                  ),
                  _buildBottomAction(
                    icon: Icons.headphones_outlined,
                    label: 'Écouter',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lecture audio')),
                      );
                    },
                  ),
                  _buildBottomAction(
                    icon: Icons.share_outlined,
                    label: 'Partager',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passage copié pour partage')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

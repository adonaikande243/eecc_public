import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

class PraiseScreen extends StatefulWidget {
  const PraiseScreen({Key? key}) : super(key: key);

  @override
  State<PraiseScreen> createState() => _PraiseScreenState();
}

class _PraiseScreenState extends State<PraiseScreen> {
  final List<Map<String, dynamic>> _cantiques = [
    {
      'titre': 'Jésus, nous célébrons ta victoire',
      'compositeur': 'Recueil Chants de Victoire',
      'duree': '4:12',
      'paroles': 'Jésus, nous célébrons ta victoire !\nJésus, nous te louons !\nTu as triomphé de la mort\nEt tu règnes à jamais !',
    },
    {
      'titre': 'Kumama Yahweh Kumama',
      'compositeur': 'Adoration Lingala',
      'duree': '5:30',
      'paroles': 'Kumama Yahweh kumama !\nYahweh mokonzi na biso, kumama !\nOza Nzambe ya nguya, kumama !',
    },
    {
      'titre': 'Mon Dieu est si bon',
      'compositeur': 'Chorale EECC',
      'duree': '3:45',
      'paroles': 'Mon Dieu est si grand, si fort et si puissant !\nRien n\'est impossible à mon Dieu !',
    },
    {
      'titre': 'Bikuke Ya Lola Efungwama',
      'compositeur': 'Chant d\'intercession',
      'duree': '6:10',
      'paroles': 'Bikuke ya lola efungwama lelo !\nMpe nguya ya Molimo esopana likolo na biso !',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('Louanges & Cantiques', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _cantiques.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: EeccTheme.borderGrey),
        itemBuilder: (context, index) {
          final c = _cantiques[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.music_note, color: EeccTheme.navy, size: 22),
            ),
            title: Text(
              c['titre'],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: EeccTheme.navyDark),
            ),
            subtitle: Text(
              '${c['compositeur']} • ${c['duree']}',
              style: const TextStyle(fontSize: 11.5, color: EeccTheme.textMuted),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.lyrics_outlined, color: EeccTheme.navy),
              onPressed: () {
                _afficherParolesModal(c['titre'], c['paroles']);
              },
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lecture de "${c['titre']}"...')),
              );
            },
          );
        },
      ),
    );
  }

  void _afficherParolesModal(String titre, String paroles) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              titre,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: EeccTheme.navyDark),
            ),
            const SizedBox(height: 14),
            Text(
              paroles,
              style: const TextStyle(fontSize: 15, height: 1.6, color: EeccTheme.navyDark),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: EeccTheme.navy),
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final books = [
      {'titre': 'La Puissance de la Prière Fervente', 'auteur': 'Pasteur David Kande', 'pages': '180 pages', 'categorie': 'Prière'},
      {'titre': 'Marcher dans la Sanctification', 'auteur': 'Comité Pastoral EECC', 'pages': '124 pages', 'categorie': 'Doctrine'},
      {'titre': 'Les Fondements de la Foi Chrétienne', 'auteur': 'Éditions EECC', 'pages': '210 pages', 'categorie': 'Enseignement'},
      {'titre': 'La Gestion Biblique des Finances', 'auteur': 'Pasteur David Kande', 'pages': '95 pages', 'categorie': 'Vie Pratique'},
    ];

    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('Livres Recommandés', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final b = books[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EeccTheme.bgWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: EeccTheme.borderGrey),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 68,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Center(
                    child: Icon(Icons.menu_book, color: EeccTheme.navy, size: 28),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          b['categorie']!,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: EeccTheme.navyDark),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        b['titre']!,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: EeccTheme.navyDark),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${b['auteur']} • ${b['pages']}',
                        style: const TextStyle(fontSize: 11.5, color: EeccTheme.textMuted),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.visibility_outlined, color: EeccTheme.navy),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ouverture de "${b['titre']}"...')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

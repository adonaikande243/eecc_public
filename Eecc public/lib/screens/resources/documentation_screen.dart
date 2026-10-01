import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

class DocumentationScreen extends StatelessWidget {
  const DocumentationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final docs = [
      {'titre': 'Statuts & Règlement Intérieur de l\'EECC', 'taille': '2.4 Mo', 'type': 'PDF'},
      {'titre': 'Confession de foi & Principes doctrinaux', 'taille': '1.1 Mo', 'type': 'PDF'},
      {'titre': 'Guide du nouveau membre et baptême', 'taille': '850 Ko', 'type': 'PDF'},
      {'titre': 'Charte des ministères et départements', 'taille': '1.5 Mo', 'type': 'PDF'},
    ];

    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('Documentation & Statuts', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: docs.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: EeccTheme.borderGrey),
        itemBuilder: (context, index) {
          final d = docs[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
            ),
            title: Text(d['titre']!, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: EeccTheme.navyDark)),
            subtitle: Text('${d['type']} • ${d['taille']}', style: const TextStyle(fontSize: 11.5, color: EeccTheme.textMuted)),
            trailing: const Icon(Icons.file_download_outlined, color: EeccTheme.navy),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Téléchargement de "${d['titre']}"...')),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

class EcodimScreen extends StatelessWidget {
  const EcodimScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('École du Dimanche (Écodim)', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bannière Ecodim
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'MINISTÈRE DES ENFANTS',
                    style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Écodim EECC',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '« Instruis l\'enfant selon la voie qu\'il doit suivre ; et quand il sera vieux, il ne s\'en détournera pas. »',
                    style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 12.5),
                  ),
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '— Proverbes 22:6',
                      style: TextStyle(color: Color(0xFFCCFBF1), fontWeight: FontWeight.bold, fontSize: 11.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Classes par tranche d'âge
            const Text('Classes d\'âge', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: EeccTheme.navyDark)),
            const SizedBox(height: 10),
            _buildClassCard('Petits Agneaux (3 - 6 ans)', 'Éveil biblique, coloriages et chants', Icons.child_care, Colors.amber.shade700),
            _buildClassCard('Soldats du Roi (7 - 10 ans)', 'Récits bibliques et mémorisation des versets', Icons.emoji_people, Colors.teal),
            _buildClassCard('Flambeaux de Christ (11 - 14 ans)', 'Discipulat, études thématiques et témoignages', Icons.flare, Colors.indigo),

            const SizedBox(height: 20),
            const Text('Supports pédagogiques', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: EeccTheme.navyDark)),
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: EeccTheme.borderGrey)),
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Fiche de leçon biblique de la semaine', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
              subtitle: const Text('Format PDF • 1.2 Mo', style: TextStyle(fontSize: 11, color: EeccTheme.textMuted)),
              trailing: const Icon(Icons.download, color: EeccTheme.navy),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Téléchargement de la fiche de leçon...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: EeccTheme.bgGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EeccTheme.borderGrey),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: EeccTheme.navyDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: EeccTheme.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

class JpcScreen extends StatelessWidget {
  const JpcScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('Jeunesse Pour Christ (JPC)', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bannière JPC
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'DÉPARTEMENT JEUNESSE',
                    style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Jeunesse Pour Christ',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '« Que personne ne méprise ta jeunesse ; mais sois un modèle pour les fidèles... »',
                    style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 12.5),
                  ),
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '— 1 Timothée 4:12',
                      style: TextStyle(color: Color(0xFF93C5FD), fontWeight: FontWeight.bold, fontSize: 11.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Modules JPC
            const Text('Activités & Pôles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: EeccTheme.navyDark)),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: [
                _buildActivityCard(Icons.mic_external_on, 'Chorale JPC', 'Répétitions Samedi 15h'),
                _buildActivityCard(Icons.sports_soccer, 'Sport & Loisirs', 'Fraternité chrétienne'),
                _buildActivityCard(Icons.campaign, 'Évangélisation', 'Missions de rue'),
                _buildActivityCard(Icons.school, 'Formations', 'Leadership & Métiers'),
              ],
            ),
            const SizedBox(height: 20),

            // Prochains Rendez-vous
            const Text('Prochains événements JPC', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: EeccTheme.navyDark)),
            const SizedBox(height: 10),
            _buildEventTile(
              'Grand Concert d\'adoration "Impact Ciel"',
              'Samedi 24 Octobre 2026 • 15h00',
              'Salle Principale EECC',
            ),
            _buildEventTile(
              'Retraite spirituelle de la jeunesse',
              '05 au 08 Novembre 2026',
              'Centre Bethel',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: EeccTheme.bgGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EeccTheme.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEFF6FF),
            radius: 18,
            child: Icon(icon, color: EeccTheme.navy, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: EeccTheme.navyDark)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: EeccTheme.textMuted, fontSize: 10.5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventTile(String title, String date, String lieu) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: EeccTheme.bgWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EeccTheme.borderGrey),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.event, color: EeccTheme.navy, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: EeccTheme.navyDark)),
                const SizedBox(height: 2),
                Text('$date • $lieu', style: const TextStyle(fontSize: 11, color: EeccTheme.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

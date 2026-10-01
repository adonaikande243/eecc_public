import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> events = [
      {
        'jour': '04',
        'mois': 'OCT',
        'titre': 'Culte d\'action de grâces du premier dimanche',
        'horaire': '09h00 - 12h00',
        'lieu': 'Temple Central EECC Kinshasa',
      },
      {
        'jour': '10',
        'mois': 'OCT',
        'titre': 'Séminaire des Couples & Familles Chrétiennes',
        'horaire': '16h00 - 18h30',
        'lieu': 'Salle Polyvalente',
      },
      {
        'jour': '24',
        'mois': 'OCT',
        'titre': 'Concert Annuel de la Jeunesse JPC',
        'horaire': '15h00 - 19h00',
        'lieu': 'Grand Temple EECC',
      },
    ];

    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('Événements & Agenda', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final e = events[index];
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
                // Date badge
                Container(
                  width: 50,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(e['jour']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: EeccTheme.navy)),
                      Text(e['mois']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: EeccTheme.navy)),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                // Détails
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e['titre']!, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: EeccTheme.navyDark)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 13, color: EeccTheme.textMuted),
                          const SizedBox(width: 4),
                          Text(e['horaire']!, style: const TextStyle(fontSize: 11.5, color: EeccTheme.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 13, color: EeccTheme.textMuted),
                          const SizedBox(width: 4),
                          Text(e['lieu']!, style: const TextStyle(fontSize: 11.5, color: EeccTheme.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

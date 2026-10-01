import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

class CommunicationsScreen extends StatefulWidget {
  const CommunicationsScreen({Key? key}) : super(key: key);

  @override
  State<CommunicationsScreen> createState() => _CommunicationsScreenState();
}

class _CommunicationsScreenState extends State<CommunicationsScreen> {
  String _selectedFilter = 'Toutes';

  final List<Map<String, dynamic>> _annonces = [
    {
      'tag': 'Annonce',
      'tagColor': const Color(0xFFE0E7FF),
      'tagTextColor': const Color(0xFF3730A3),
      'title': 'Programme du jeûne et prières du mois de consécration',
      'date': 'Aujourd\'hui, 08:30',
      'content': 'L\'église entre dans une semaine de consécration du lundi au vendredi de 17h30 à 19h30. Venez nombreux chercher la face de Dieu.',
    },
    {
      'tag': 'Événement',
      'tagColor': const Color(0xFFDCFCE7),
      'tagTextColor': const Color(0xFF166534),
      'title': 'Grand Concert de louange & d\'adoration de la jeunesse JPC',
      'date': '12 Octobre 2026',
      'content': 'La Jeunesse Pour Christ organise un moment d\'impact spirituel et musical avec toutes les chorales de l\'EECC.',
    },
    {
      'tag': 'Note pastorale',
      'tagColor': const Color(0xFFFEF3C7),
      'tagTextColor': const Color(0xFF92400E),
      'title': 'Horaires des cultes d\'enseignement et d\'intercession en semaine',
      'date': '05 Octobre 2026',
      'content': 'Rappel des rendez-vous hebdomadaires : Mardi (Étude biblique à 17h30), Jeudi (Intercession et délivrance à 17h30).',
    },
    {
      'tag': 'Mariage',
      'tagColor': const Color(0xFFFCE7F3),
      'tagTextColor': const Color(0xFF9D174D),
      'title': 'Bénédiction nuptiale des fiancés frère Jonathan et sœur Sarah',
      'date': '28 Septembre 2026',
      'content': 'La communauté a la joie de vous convier à la célébration du mariage qui aura lieu ce samedi à 11h.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('Communications', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Filtres
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilter('Toutes'),
                _buildFilter('Annonce'),
                _buildFilter('Événement'),
                _buildFilter('Note pastorale'),
              ],
            ),
          ),

          // Liste des communications
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _annonces.length,
              itemBuilder: (context, index) {
                final a = _annonces[index];
                if (_selectedFilter != 'Toutes' && a['tag'] != _selectedFilter) {
                  return const SizedBox.shrink();
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: EeccTheme.bgWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: EeccTheme.borderGrey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: a['tagColor'],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              a['tag'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: a['tagTextColor'],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            a['date'],
                            style: const TextStyle(fontSize: 11.5, color: EeccTheme.textLight),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        a['title'],
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: EeccTheme.navyDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        a['content'],
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: EeccTheme.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color(0xFFEFF6FF),
        backgroundColor: EeccTheme.bgGrey,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? EeccTheme.navy : EeccTheme.navyDark,
        ),
        side: BorderSide(color: isSelected ? EeccTheme.navy : EeccTheme.borderGrey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onSelected: (val) => setState(() => _selectedFilter = label),
      ),
    );
  }
}

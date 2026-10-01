import 'package:flutter/material.dart';
import '../theme/eecc_theme.dart';

/// Tableau de bord du Comité Directeur & Conseil d'Administration EECC
class ComiteDashboardScreen extends StatefulWidget {
  const ComiteDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ComiteDashboardScreen> createState() => _ComiteDashboardScreenState();
}

class _ComiteDashboardScreenState extends State<ComiteDashboardScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('Comité Directeur & Conseil', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEFF6FF),
              child: const Icon(Icons.person, color: EeccTheme.navy, size: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bandeau Comité
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'CONSEIL D\'ADMINISTRATION',
                    style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Gouvernance & Projets Stratégiques',
                    style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Validation des budgets, suivi des chantiers et résolutions officielles.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 4 Cartes Stratégiques
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    'Budget Exécuté',
                    '18 500 \$',
                    '72% alloué',
                    Icons.account_balance,
                    const Color(0xFF059669),
                    const Color(0xFFECFDF5),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatTile(
                    'Projets Actifs',
                    '4',
                    'Construction & Média',
                    Icons.foundation,
                    const Color(0xFF2563EB),
                    const Color(0xFFEFF6FF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    'Prochaine Session',
                    '14 OCT',
                    'Ordre du jour prêt',
                    Icons.event,
                    const Color(0xFFD97706),
                    const Color(0xFFFFFBEB),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatTile(
                    'Résolutions',
                    '18',
                    '100% approuvées',
                    Icons.verified_outlined,
                    const Color(0xFF7C3AED),
                    const Color(0xFFF5F3FF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Projets en cours
            const Text(
              'Grands Projets de l\'Église',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: EeccTheme.navyDark),
            ),
            const SizedBox(height: 10),

            _buildProjectCard(
              title: 'Construction & Agrandissement du Grand Temple',
              progress: 0.65,
              budget: '12 000 \$ / 18 000 \$',
              statut: 'En cours (Phase toiture)',
            ),
            _buildProjectCard(
              title: 'Modernisation Régie Vidéo Broadcast & Caméras PTZ',
              progress: 0.90,
              budget: '4 500 \$ / 5 000 \$',
              statut: 'Finalisation & Tests',
            ),
            _buildProjectCard(
              title: 'Implantation Paroisse Annexe Maluku',
              progress: 0.35,
              budget: '2 000 \$ / 6 000 \$',
              statut: 'Acquisition terrain',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value, String sub, IconData icon, Color color, Color bg) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: EeccTheme.textMuted)),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: EeccTheme.navyDark)),
          const SizedBox(height: 2),
          Text(sub, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildProjectCard({required String title, required double progress, required String budget, required String statut}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EeccTheme.bgGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EeccTheme.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: EeccTheme.navyDark),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: EeccTheme.navy),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation(EeccTheme.navy),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(statut, style: const TextStyle(fontSize: 11, color: EeccTheme.textMuted)),
              Text(budget, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: EeccTheme.navyDark)),
            ],
          ),
        ],
      ),
    );
  }
}

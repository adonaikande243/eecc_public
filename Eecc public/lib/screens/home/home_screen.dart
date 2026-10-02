import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';
import '../auth/login_screen.dart';
import '../communication/communications_screen.dart';

/// Écran d'accueil identique pixel-perfect à 04_accueil_visiteur.png et 02_ecran_principal.png
class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;
  final VoidCallback? onOpenMenu;

  const HomeScreen({Key? key, this.onNavigateTab, this.onOpenMenu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Accueil',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF0F172A), size: 28),
            onPressed: () {
              if (onOpenMenu != null) {
                onOpenMenu!();
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titre & Sous-titre officiels de la maquette 04_accueil_visiteur.png
            const Text(
              'Bienvenue à l\'EECC',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Église Évangélique les Cohéritiers du Christ',
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 18),

            // 1. Bandeau En direct — culte de dimanche (Maquette 04_accueil_visiteur.png)
            InkWell(
              onTap: () {
                if (onNavigateTab != null) onNavigateTab!(1); // Aller à Direct
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBEBEB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'En direct — culte de dimanche',
                        style: TextStyle(
                          color: Color(0xFF8B1E1E),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Carte Verset du jour (Fond gris chaud #F5F5F2, coins arrondis)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Verset du jour',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '« Car je connais les projets que j\'ai formés sur vous, dit l\'Éternel, projets de paix et non de malheur... »',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF0F172A),
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Jérémie 29:11',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Trois cartes d'action rapide (Lire la Bible, Prédications, JPC)
            Row(
              children: [
                Expanded(
                  child: _buildActionBox(
                    icon: Icons.menu_book_outlined,
                    label: 'Lire la Bible',
                    onTap: () {
                      if (onNavigateTab != null) onNavigateTab!(3); // Bible
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionBox(
                    icon: Icons.play_circle_outline,
                    label: 'Prédications',
                    onTap: () {
                      if (onNavigateTab != null) onNavigateTab!(2); // Médias
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionBox(
                    icon: Icons.people_outline,
                    label: 'JPC',
                    onTap: () {
                      if (onNavigateTab != null) onNavigateTab!(4); // JPC
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // 4. Section Communications récentes (Maquette 04_accueil_visiteur.png)
            const Text(
              'Communications récentes',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            _buildCommunicationPill(
              title: 'Rencontre des jeunes — samedi',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunicationsScreen()));
              },
            ),
            const SizedBox(height: 10),
            _buildCommunicationPill(
              title: 'Collecte spéciale de fin d\'année',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunicationsScreen()));
              },
            ),
            const SizedBox(height: 24),

            // 5. Deux boutons d'action en bas (Continuer comme visiteur / Se connecter)
            Row(
              children: [
                // Bouton Continuer comme visiteur
                Expanded(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Session visiteur active')),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF1E3A5F), width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Continuer comme\nvisiteur',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                          height: 1.15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Bouton Se connecter
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A5F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBox({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1E3A5F), size: 26),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunicationPill({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F172A),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}

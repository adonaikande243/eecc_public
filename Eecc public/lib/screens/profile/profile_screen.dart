import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('Profil Membre', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar & Identité
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: EeccTheme.bgGrey,
                        child: const Icon(Icons.person, size: 54, color: EeccTheme.navy),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: EeccTheme.navy,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Fidèle EECC',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: EeccTheme.navyDark),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Paroisse Centrale de Kinshasa',
                    style: TextStyle(fontSize: 13, color: EeccTheme.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Cartes de statistiques / statut
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: EeccTheme.bgGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: EeccTheme.borderGrey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Statut', 'Baptisé(e)'),
                  Container(height: 24, width: 1, color: EeccTheme.borderGrey),
                  _buildStatItem('Département', 'Chorale / JPC'),
                  Container(height: 24, width: 1, color: EeccTheme.borderGrey),
                  _buildStatItem('Paroisse', 'Kinshasa'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Paramètres et options
            _buildProfileTile(Icons.person_outline, 'Informations personnelles', 'Nom, téléphone, adresse'),
            _buildProfileTile(Icons.history, 'Historique des contributions', 'Reçus officiels de dîmes & dons'),
            _buildProfileTile(Icons.notifications_none, 'Notifications & Alertes', 'Cultes, rappels de prière'),
            _buildProfileTile(Icons.security, 'Sécurité du compte', 'Changer de mot de passe'),
            const SizedBox(height: 20),

            // Bouton de déconnexion
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade200),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Se déconnecter'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: EeccTheme.navyDark)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: EeccTheme.textMuted)),
      ],
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: EeccTheme.bgWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EeccTheme.borderGrey),
      ),
      child: ListTile(
        leading: Icon(icon, color: EeccTheme.navy, size: 22),
        title: Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: EeccTheme.navyDark)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11.5, color: EeccTheme.textMuted)),
        trailing: const Icon(Icons.chevron_right, size: 18, color: EeccTheme.textLight),
        onTap: () {},
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../theme/eecc_theme.dart';
import 'direct_screen.dart';
import 'offrande_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supabase = EeccSupabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Église EECC'),
        backgroundColor: EeccTheme.violet,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bandeau dynamique du Live (Écoute en temps réel Supabase)
            StreamBuilder<EeccLiveSession?>(
              stream: supabase.ecouterLiveEnCours(),
              builder: (context, snapshot) {
                final live = snapshot.data;
                if (live != null && live.isLive && live.surAppMobile) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD32F2F), Color(0xFFC2185B)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.sensors, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'CULTE EN DIRECT MAINTENANT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          live.titre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Prédicateur : ${live.predicateur}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.play_circle_fill),
                          label: const Text(
                            'REJOINDRE LE CULTE',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DirectScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // En-tête de bienvenue
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Bienvenue à la communauté',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: EeccTheme.violet,
                ),
              ),
            ),

            // Grille des Modules
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    title: 'Culte en Direct',
                    subtitle: 'Diffusion vidéo',
                    icon: Icons.live_tv,
                    color: Colors.red.shade600,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DirectScreen()),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    title: 'Archives & Cultes',
                    subtitle: 'Google Drive Cloud',
                    icon: Icons.video_library,
                    color: Colors.indigo,
                    onTap: () {
                      _afficherArchivesModal(context);
                    },
                  ),
                  _buildMenuCard(
                    context,
                    title: 'Dîmes & Offrandes',
                    subtitle: 'Paiement Maishapay',
                    icon: Icons.volunteer_activism,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OffrandeScreen()),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    title: 'Sainte Bible',
                    subtitle: 'Lecture & Méditation',
                    icon: Icons.menu_book,
                    color: Colors.orange.shade800,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              radius: 24,
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _afficherArchivesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          final supabase = EeccSupabaseService();
          return FutureBuilder<List<EeccCulteArchive>>(
            future: supabase.obtenirArchives(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final archives = snapshot.data ?? [];
              if (archives.isEmpty) {
                return const Center(
                  child: Text('Aucun culte archivé pour le moment.'),
                );
              }
              return ListView.builder(
                controller: scrollController,
                itemCount: archives.length,
                itemBuilder: (context, index) {
                  final a = archives[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.movie, color: Colors.white),
                    ),
                    title: Text(a.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${a.predicateur} • ${a.dateCulte.toLocal().toString().substring(0, 10)}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

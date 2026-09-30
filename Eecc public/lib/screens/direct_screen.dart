import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/eecc_theme.dart';
import 'offrande_screen.dart';

class DirectScreen extends StatefulWidget {
  const DirectScreen({Key? key}) : super(key: key);

  @override
  State<DirectScreen> createState() => _DirectScreenState();
}

class _DirectScreenState extends State<DirectScreen> {
  final EeccSupabaseService _supabaseService = EeccSupabaseService();
  final TextEditingController _priereController = TextEditingController();

  @override
  void dispose() {
    _priereController.dispose();
    super.dispose();
  }

  Future<void> _ouvrirLienExterne(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Culte en Direct'),
        backgroundColor: EeccTheme.violet,
      ),
      body: StreamBuilder<EeccLiveSession?>(
        stream: _supabaseService.ecouterLiveEnCours(),
        builder: (context, snapshot) {
          final live = snapshot.data;

          // Cas 1 : Aucun culte en direct ou diffusion exclue de l'app mobile
          if (live == null || !live.isLive || !live.surAppMobile) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tv_off, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    const Text(
                      'Aucun culte en direct pour le moment',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rejoignez-nous chaque Dimanche dès 09h00 ou consultez les cultes archivés.',
                      style: TextStyle(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: EeccTheme.violet,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      icon: const Icon(Icons.history),
                      label: const Text('Voir les cultes archivés'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          // Cas 2 : Culte en direct actif sur l'Application Mobile !
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Zone Lecteur Vidéo du Direct
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lecteur Vidéo simulcast / HLS
                        const Icon(Icons.live_tv, size: 64, color: Colors.white38),
                        // Badge Pulsant EN DIRECT
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.circle, color: Colors.white, size: 10),
                                SizedBox(width: 6),
                                Text(
                                  'EN DIRECT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Informations du culte
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        live.titre,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.person, size: 18, color: EeccTheme.dore),
                          const SizedBox(width: 6),
                          Text(
                            live.predicateur,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Boutons d'accès multi-plateformes (YouTube & Facebook)
                      if (live.surYoutube || live.surFacebook) ...[
                        const Text(
                          'Disponible également sur vos réseaux :',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (live.surYoutube)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('YouTube Live'),
                                  onPressed: () => _ouvrirLienExterne(live.youtubeUrl),
                                ),
                              ),
                            if (live.surFacebook)
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blue.shade800,
                                  side: BorderSide(color: Colors.blue.shade800),
                                ),
                                icon: const Icon(Icons.facebook),
                                label: const Text('Facebook Live'),
                                onPressed: () => _ouvrirLienExterne(live.facebookUrl),
                              ),
                          ],
                        ),
                        const Divider(height: 28),
                      ],

                      // Actions interactives du culte
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionBouton(
                            icon: Icons.volunteer_activism,
                            color: Colors.teal,
                            label: 'Offrande / Dîme',
                            onTap: () => _afficherBoiteOffrande(context),
                          ),
                          _buildActionBouton(
                            icon: Icons.favorite,
                            color: Colors.purple,
                            label: 'Prière en direct',
                            onTap: () => _afficherBoitePriere(context),
                          ),
                          _buildActionBouton(
                            icon: Icons.menu_book,
                            color: Colors.indigo,
                            label: 'Sainte Bible',
                            onTap: () {},
                          ),
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

  Widget _buildActionBouton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              radius: 26,
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _afficherBoiteOffrande(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OffrandeScreen()),
    );
  }

  void _afficherBoitePriere(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Requête de Prière en Direct'),
        content: TextField(
          controller: _priereController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Écrivez votre sujet de prière ici...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: EeccTheme.violet, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              _priereController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Votre requête a été transmise aux pasteurs !')),
              );
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/eecc_theme.dart';
import '../offering/offering_flow_screen.dart';
import '../prayer/priere_screen.dart';

/// Écran de diffusion en direct fidèle à la maquette 16_direct.png
class LiveScreen extends StatefulWidget {
  const LiveScreen({Key? key}) : super(key: key);

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final EeccSupabaseService _supabase = EeccSupabaseService();
  bool _isPlaying = true;
  bool _isMuted = false;

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
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('Direct', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: StreamBuilder<EeccLiveSession?>(
        stream: _supabase.ecouterLiveEnCours(),
        builder: (context, snapshot) {
          final live = snapshot.data;
          final isStreaming = live != null && live.isLive && live.surAppMobile;

          final titreCulte = isStreaming ? live.titre : 'Culte de célébration & adoration';
          final predicateur = isStreaming ? live.predicateur : 'Pasteur David Kande';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Zone Lecteur Vidéo (Maquette 16_direct.png)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Arrière-plan sombre du flux
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.church,
                              size: 70,
                              color: Colors.white.withOpacity(0.12),
                            ),
                          ),
                        ),

                        // Badge EN DIRECT en haut à gauche
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: EeccTheme.redLive,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.circle, color: Colors.white, size: 8),
                                SizedBox(width: 6),
                                Text(
                                  'EN DIRECT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bouton Play / Pause au centre
                        GestureDetector(
                          onTap: () => setState(() => _isPlaying = !_isPlaying),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: EeccTheme.navy,
                              size: 34,
                            ),
                          ),
                        ),

                        // Barre de progression rouge en bas
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 4,
                            color: Colors.white24,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              color: EeccTheme.redLive,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Informations principales du Culte
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titreCulte,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: EeccTheme.navyDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Prédicateur : $predicateur • 1 240 spectateurs en direct',
                        style: const TextStyle(
                          fontSize: 13,
                          color: EeccTheme.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 4 Cartes d'action rapides : Son, Plein écran, Partager, Rappel
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionTile(
                            icon: _isMuted ? Icons.volume_off_outlined : Icons.volume_up_outlined,
                            label: 'Son',
                            onTap: () => setState(() => _isMuted = !_isMuted),
                          ),
                          _buildActionTile(
                            icon: Icons.fullscreen_outlined,
                            label: 'Plein écran',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Basculement en mode plein écran')),
                              );
                            },
                          ),
                          _buildActionTile(
                            icon: Icons.share_outlined,
                            label: 'Partager',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Lien du direct copié !')),
                              );
                            },
                          ),
                          _buildActionTile(
                            icon: Icons.notifications_active_outlined,
                            label: 'Rappel',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Rappel configuré pour les prochains cultes')),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Carte "Informations sur le culte"
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: EeccTheme.bgGrey,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: EeccTheme.borderGrey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informations sur le culte',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: EeccTheme.navyDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              Icons.menu_book_outlined,
                              'Passage biblique :',
                              'Jean 4:23-24',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.lightbulb_outline,
                              'Thème :',
                              'L\'adoration en esprit et en vérité',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.schedule_outlined,
                              'Horaires :',
                              '09h00 - 11h30',
                            ),
                          ],
                        ),
                      ),

                      // Liens YouTube / Facebook si présents
                      if (isStreaming && (live.surYoutube || live.surFacebook)) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (live.surYoutube)
                              Expanded(
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
                            if (live.surYoutube && live.surFacebook) const SizedBox(width: 8),
                            if (live.surFacebook)
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.blue.shade800,
                                    side: BorderSide(color: Colors.blue.shade800),
                                  ),
                                  icon: const Icon(Icons.facebook),
                                  label: const Text('Facebook Live'),
                                  onPressed: () => _ouvrirLienExterne(live.facebookUrl),
                                ),
                              ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 24),
                      // Actions interactives du culte
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const OfferingFlowScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: EeccTheme.navy,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              icon: const Icon(Icons.volunteer_activism_outlined, size: 20),
                              label: const Text('Offrande'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const PriereScreen()),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(color: EeccTheme.navy, width: 1.5),
                              ),
                              icon: const Icon(Icons.pan_tool_outlined, size: 20, color: EeccTheme.navy),
                              label: const Text(
                                'Prière en direct',
                                style: TextStyle(color: EeccTheme.navy, fontWeight: FontWeight.bold),
                              ),
                            ),
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

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: EeccTheme.bgGrey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: EeccTheme.borderGrey),
              ),
              child: Icon(icon, color: EeccTheme.navyDark, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: EeccTheme.navyDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: EeccTheme.navy),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: EeccTheme.navyDark),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12.5, color: EeccTheme.textMuted),
          ),
        ),
      ],
    );
  }
}

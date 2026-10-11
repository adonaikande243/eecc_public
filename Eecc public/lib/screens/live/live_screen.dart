import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../offering/offering_flow_screen.dart';

/// Écran Direct connecté à Supabase en temps réel (table eecc_lives)
class LiveScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const LiveScreen({Key? key, this.onBack}) : super(key: key);

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final EeccSupabaseService _supabase = EeccSupabaseService();
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF0F172A), size: 30),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Direct',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<EeccLiveSession?>(
        stream: _supabase.ecouterLiveEnCours(
          intervalle: const Duration(seconds: 8),
        ),
        builder: (context, snapshot) {
          // Chargement initial
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color(0xFF1E3A5F)),
                    strokeWidth: 2.5,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Vérification du direct...',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                ],
              ),
            );
          }

          final live = snapshot.data;
          final isLive = live != null && live.isLive;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Zone Vidéo 16:9
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: const Color(0xFF161F2E),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Badge EN DIRECT ou HORS DIRECT
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isLive
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF334155),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isLive)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                Text(
                                  isLive ? 'EN DIRECT' : 'HORS DIRECT',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Icône centrale
                        if (isLive)
                          // Bouton play si l'URL app mobile est disponible
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.live_tv,
                                color: Colors.white.withOpacity(0.8),
                                size: 54,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Culte en direct',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sensors_off,
                                color: Colors.white.withOpacity(0.3),
                                size: 54,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Pas de direct en cours',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),

                        // Barre de progression (si live actif)
                        if (isLive)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 3.5,
                              color: const Color(0xFF475569),
                              alignment: Alignment.centerLeft,
                              child: const FractionallySizedBox(
                                widthFactor: 0.38,
                                child: ColoredBox(color: Color(0xFFDC2626)),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // 2. Titre & Infos
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLive
                            ? (live!.titre)
                            : 'Prochain culte — Dimanche',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLive
                            ? live!.predicateur
                            : 'Paroisse Centrale de Kinshasa',
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 3. Liens externes si disponibles
                      if (isLive && live!.surYoutube && live.youtubeUrl != null)
                        _buildExternalLinkBanner(
                          icon: Icons.smart_display,
                          label: 'Regarder sur YouTube',
                          color: const Color(0xFFDC2626),
                          onTap: () {
                            // Ouverture URL YouTube
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('YouTube: ${live.youtubeUrl}')),
                            );
                          },
                        ),

                      if (isLive && live!.surFacebook && live.facebookUrl != null)
                        _buildExternalLinkBanner(
                          icon: Icons.facebook,
                          label: 'Regarder sur Facebook',
                          color: const Color(0xFF1877F2),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Facebook: ${live.facebookUrl}')),
                            );
                          },
                        ),

                      // 4. Cartes d'actions
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionTile(
                              icon: _isMuted
                                  ? Icons.volume_off_outlined
                                  : Icons.volume_up_outlined,
                              label: _isMuted ? 'Son coupé' : 'Son',
                              onTap: () => setState(() => _isMuted = !_isMuted),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildActionTile(
                              icon: Icons.fullscreen,
                              label: 'Plein\nécran',
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildActionTile(
                              icon: Icons.share_outlined,
                              label: 'Partager',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Lien de partage copié !')),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildActionTile(
                              icon: Icons.volunteer_activism_outlined,
                              label: 'Offrir',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const OfferingFlowScreen()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 5. Encadré informatif
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          isLive
                              ? 'Le culte est actuellement en direct. Rejoignez-nous en prière et en adoration.'
                              : 'Les cultes sont diffusés chaque dimanche. Activez les notifications pour ne manquer aucun direct.',
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF64748B),
                            height: 1.45,
                          ),
                        ),
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

  Widget _buildExternalLinkBanner({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const Spacer(),
              Icon(Icons.open_in_new, color: color, size: 16),
            ],
          ),
        ),
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
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 84,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1E3A5F), size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F172A),
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

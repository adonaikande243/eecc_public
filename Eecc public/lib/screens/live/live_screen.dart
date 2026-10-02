import 'package:flutter/material.dart';

/// Écran Direct identique pixel-perfect à 16_direct.png
class LiveScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const LiveScreen({Key? key, this.onBack}) : super(key: key);

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  bool _isPlaying = true;
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Zone Vidéo 16:9 (Maquette 16_direct.png)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: const Color(0xFF161F2E),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Badge EN DIRECT en haut à gauche
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.circle, color: Color(0xFFDC2626), size: 8),
                            SizedBox(width: 6),
                            Text(
                              'EN DIRECT',
                              style: TextStyle(
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

                    // Bouton Play central circulaire
                    GestureDetector(
                      onTap: () => setState(() => _isPlaying = !_isPlaying),
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          color: Color(0xFF334155),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),

                    // Barre de progression rouge en bas
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 3.5,
                        color: const Color(0xFF475569),
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 0.38,
                          child: Container(color: const Color(0xFFDC2626)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Textes & Actions
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Culte de dimanche — Louange et Parole',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Pasteur Jean Mukendi · Paroisse Centrale',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 3. 4 Cartes d'actions (Son, Plein écran, Partager, Rappel)
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionTile(
                          icon: _isMuted ? Icons.phone_android : Icons.smartphone_outlined,
                          label: 'Son',
                          onTap: () => setState(() => _isMuted = !_isMuted),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildActionTile(
                          icon: Icons.camera_alt_outlined,
                          label: 'Plein\nécran',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildActionTile(
                          icon: Icons.people_outline,
                          label: 'Partager',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildActionTile(
                          icon: Icons.notifications_none_outlined,
                          label: 'Rappel',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4. Encadré d'information gris clair (Maquette 16_direct.png)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Rejoignez-nous en direct pour ce temps de louange et d\'enseignement, retransmis depuis la paroisse centrale.',
                      style: TextStyle(
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
      ),
    );
  }

  Widget _buildActionTile({required IconData icon, required String label, required VoidCallback onTap}) {
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

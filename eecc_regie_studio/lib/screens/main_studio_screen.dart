import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/scene_manager.dart';
import '../widgets/preview_canvas.dart';
import '../widgets/scene_panel.dart';
import '../widgets/sources_panel.dart';
import '../widgets/audio_mixer_panel.dart';
import '../core/services/ffmpeg_streaming_service.dart';
import '../widgets/stream_destinations_dialog.dart';
import '../widgets/status_bar.dart';
import 'camera_manager_screen.dart';
import 'bible_projection_dialog.dart';

/// Régie Studio principale fidèle à la maquette 13_regie_principale.png
/// Offre la disposition professionnelle broadcast :
/// Dual-Screen (PRÉVISUALISATION en vert / PROGRAMME en rouge),
/// Bloc de transition central (CUT, AUTO, TAKE),
/// Pupitre de commutation rapide de sources et d'overlays.
class MainStudioScreen extends StatefulWidget {
  const MainStudioScreen({Key? key}) : super(key: key);

  @override
  State<MainStudioScreen> createState() => _MainStudioScreenState();
}

class _MainStudioScreenState extends State<MainStudioScreen> {
  int _selectedSourceIndex = 0;
  bool _overlayTitreActif = true;
  bool _overlayVersetActif = false;
  bool _overlayLogoActif = true;
  bool _isRecording = false;

  void _triggerTake() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('TAKE : Transition de la Prévisualisation vers le Programme (On Air)'),
        duration: Duration(milliseconds: 900),
      ),
    );
  }

  void _triggerCut() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CUT : Bascule instantanée'),
        duration: Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final streaming = context.watch<FfmpegStreamingService>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Thème sombre broadcast
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('EECC STUDIO PRO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1)),
            ),
            const SizedBox(width: 12),
            const Text('Régie de Diffusion & Projection', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          // Bouton Enregistrement Local
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: _isRecording ? Colors.red : Colors.white70,
              side: BorderSide(color: _isRecording ? Colors.red : Colors.white24),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: Icon(Icons.fiber_manual_record, color: _isRecording ? Colors.red : Colors.white70, size: 16),
            label: Text(_isRecording ? 'REC 00:42:15' : 'ENREGISTRER'),
            onPressed: () => setState(() => _isRecording = !_isRecording),
          ),
          const SizedBox(width: 8),

          // Bouton Diffusion Direct (Streaming)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: streaming.estEnDirect ? Colors.red.shade700 : const Color(0xFF059669),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            icon: Icon(streaming.estEnDirect ? Icons.stop_circle : Icons.sensors, size: 18),
            label: Text(
              streaming.estEnDirect ? 'EN DIRECT (ON AIR)' : 'DIFFUSER EN DIRECT',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const StreamDestinationsDialog(),
              );
            },
          ),
          const SizedBox(width: 8),

          // Bouton Projection Bible (Maquette 17_media_bible.png)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: const Icon(Icons.menu_book, size: 18),
            label: const Text('PROJECTION BIBLE'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const BibleProjectionDialog(),
              );
            },
          ),
          const SizedBox(width: 8),

          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraManagerScreen())),
            tooltip: 'Gérer les Caméras IP / HDMI',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Zone principale Dual Screen + Panneaux
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Panneau Scènes & Sources (Gauche)
                SizedBox(
                  width: 260,
                  child: Container(
                    color: const Color(0xFF1E293B),
                    child: Column(
                      children: const [
                        Expanded(flex: 1, child: ScenePanel()),
                        Divider(height: 1, color: Colors.white12),
                        Expanded(flex: 1, child: SourcesPanel()),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, color: Colors.black),

                // 2. Zone Centrale DUAL-MONITORS (Prévisualisation + Programme On-Air)
                Expanded(
                  child: Container(
                    color: const Color(0xFF020617),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              // Écran 1 : PRÉVISUALISATION (Bordure Verte)
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF059669),
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text('PRÉVISUALISATION (PREVIEW)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                          Text('SORTIE STANDBY', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color(0xFF059669), width: 2),
                                          color: Colors.black,
                                        ),
                                        child: const Center(child: PreviewCanvas()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Console de transition centrale (CUT, AUTO, TAKE)
                              Container(
                                width: 90,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF334155),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        minimumSize: const Size(74, 40),
                                      ),
                                      onPressed: _triggerCut,
                                      child: const Text('CUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF334155),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        minimumSize: const Size(74, 40),
                                      ),
                                      onPressed: _triggerTake,
                                      child: const Text('AUTO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                    const SizedBox(height: 16),
                                    // Grand Bouton TAKE
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFDC2626),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 18),
                                        minimumSize: const Size(74, 60),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      ),
                                      onPressed: _triggerTake,
                                      child: const Text('TAKE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                                    ),
                                  ],
                                ),
                              ),

                              // Écran 2 : PROGRAMME EN COURS (Bordure Rouge On-Air)
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFDC2626),
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text('PROGRAMME (ON AIR)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                          Text('DIRECT STREAMING & PROJECTION', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color(0xFFDC2626), width: 2),
                                          color: Colors.black,
                                        ),
                                        child: Stack(
                                          children: [
                                            const Center(child: PreviewCanvas()),
                                            // Overlays On Air
                                            if (_overlayLogoActif)
                                              Positioned(
                                                top: 12,
                                                right: 12,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                                                  child: const Text('EECC LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                                ),
                                              ),
                                            if (_overlayTitreActif)
                                              Positioned(
                                                bottom: 12,
                                                left: 12,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  decoration: BoxDecoration(color: const Color(0xFF1E3A8A).withOpacity(0.9), borderRadius: BorderRadius.circular(4)),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: const [
                                                      Text('Culte de célébration & adoration', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                                      Text('Pasteur David Kande', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Pupitre de commutation rapide de sources (Banc de commutation 13_regie_principale.png)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Text('SOURCES : ', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              _buildSourceButton(0, 'CAM 1 (Pupitre)'),
                              _buildSourceButton(1, 'CAM 2 (Chorale)'),
                              _buildSourceButton(2, 'CAM 3 (Fidèles)'),
                              _buildSourceButton(3, 'MÉDIA (Bible)'),
                              _buildSourceButton(4, 'DIAPOS (PPT)'),
                              const Spacer(),
                              // Bascules Overlays
                              const Text('TITRAGES : ', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                              _buildOverlayToggle('Titre', _overlayTitreActif, (v) => setState(() => _overlayTitreActif = v)),
                              _buildOverlayToggle('Verset', _overlayVersetActif, (v) => setState(() => _overlayVersetActif = v)),
                              _buildOverlayToggle('Logo', _overlayLogoActif, (v) => setState(() => _overlayLogoActif = v)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, color: Colors.black),

                // 3. Panneau Audio Mixer (Droite)
                SizedBox(
                  width: 230,
                  child: Container(
                    color: const Color(0xFF1E293B),
                    child: const AudioMixerPanel(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black),
          // Barre de statut
          const StatusBar(),
        ],
      ),
    );
  }

  Widget _buildSourceButton(int index, String label) {
    final isSelected = _selectedSourceIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: InkWell(
        onTap: () => setState(() => _selectedSourceIndex = index),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF334155),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: isSelected ? Colors.white : Colors.transparent),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayToggle(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 10.5, color: Colors.white)),
        selected: value,
        selectedColor: const Color(0xFF059669),
        backgroundColor: const Color(0xFF334155),
        padding: EdgeInsets.zero,
        onSelected: onChanged,
      ),
    );
  }
}

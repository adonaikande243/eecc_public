import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/scene_manager.dart';
import '../core/services/ffmpeg_streaming_service.dart';
import '../core/services/regie_orchestrator_service.dart';
import '../widgets/preview_canvas.dart';
import '../widgets/scene_panel.dart';
import '../widgets/sources_panel.dart';
import '../widgets/audio_mixer_panel.dart';
import '../widgets/audio_mixer_modal.dart';
import '../widgets/poster_manager_dialog.dart';
import '../widgets/overlay_config_dialog.dart';
import '../widgets/scrolling_ticker_text.dart';
import '../widgets/stream_destinations_dialog.dart';
import '../widgets/status_bar.dart';
import 'camera_manager_screen.dart';
import 'bible_projection_dialog.dart';

class MainStudioScreen extends StatefulWidget {
  const MainStudioScreen({Key? key}) : super(key: key);

  @override
  State<MainStudioScreen> createState() => _MainStudioScreenState();
}

class _MainStudioScreenState extends State<MainStudioScreen> {
  bool _overlayTitreActif = true;
  bool _overlayVersetActif = false;
  bool _overlayLogoActif = true;
  bool _isRecording = false;

  // Configuration dynamique des positions et image permanente
  OverlayPosition _positionTexte = OverlayPosition.basGauche;
  bool _modeDefilant = false;
  bool _imagePermanenteActive = false;
  String? _imagePermanenteUrl;

  String _titreBandeau = 'Culte Dominical — Louange & Enseignement';
  String _predicateurBandeau = 'Pasteur Jean Mukendi · Paroisse Centrale';
  String _versetBandeau = 'Jean 3:16 — Car Dieu a tant aimé le monde qu\'il a donné son Fils unique...';

  void _triggerTake(SceneManager sceneManager) {
    sceneManager.executeTake();
  }

  void _triggerCut(SceneManager sceneManager) {
    sceneManager.executeCut(sceneManager.selectedPreviewSceneIndex);
  }

  @override
  Widget build(BuildContext context) {
    final streaming = context.watch<FfmpegStreamingService>();
    final orchestrator = context.watch<RegieOrchestratorService>();
    final sceneManager = context.watch<SceneManager>();

    final bool onAir = streaming.estEnDirect || (orchestrator.sessionEnCours?.statut.name == 'enDirect');

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('EECC BROADCAST STUDIO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            ),
            const SizedBox(width: 14),
            Text(
              orchestrator.sessionEnCours != null
                  ? '${orchestrator.sessionEnCours!.titreCulte} (${orchestrator.sessionEnCours!.predicateur})'
                  : 'Régie Vidéo & Multidiffusion Direct',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          // Bouton Enregistrement Local
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: _isRecording ? Colors.redAccent : Colors.white70,
              side: BorderSide(color: _isRecording ? Colors.redAccent : Colors.white24, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            icon: Icon(Icons.fiber_manual_record, color: _isRecording ? Colors.redAccent : Colors.white70, size: 16),
            label: Text(_isRecording ? 'REC [ACTIF]' : 'ENREGISTRER'),
            onPressed: () => setState(() => _isRecording = !_isRecording),
          ),
          const SizedBox(width: 10),

          // Bouton Diffusion Direct (Streaming)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: onAir ? const Color(0xFFDC2626) : const Color(0xFF059669),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: Icon(onAir ? Icons.stop_circle : Icons.sensors, size: 18),
            label: Text(
              onAir ? 'ON AIR (EN DIRECT)' : 'DIFFUSER EN DIRECT',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const StreamDestinationsDialog(),
              );
            },
          ),
          const SizedBox(width: 10),

          // Bouton Projection Bible
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: const Icon(Icons.menu_book, size: 18),
            label: const Text('PROJECTION BIBLE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const BibleProjectionDialog(),
              );
            },
          ),
          const SizedBox(width: 10),

          // Bouton Mixeur Audio Complet (DSP & Égaliseur)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: const Icon(Icons.graphic_eq, size: 18),
            label: const Text('MIXEUR AUDIO PRO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AudioMixerModal(),
              );
            },
          ),
          const SizedBox(width: 10),

          // Bouton Publication Affiches & Annonces programmées
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC026D3), // Magenta / Fuchsia distinctif
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: const Icon(Icons.campaign, size: 18),
            label: const Text('AFFICHE & ANNONCE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const PosterManagerDialog(),
              );
            },
          ),
          const SizedBox(width: 10),

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
          // Corps Dual Monitors & Panneaux Studio
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Panneau Scènes & Sources (Gauche)
                SizedBox(
                  width: 250,
                  child: Container(
                    color: const Color(0xFF0F172A),
                    child: Column(
                      children: const [
                        Expanded(flex: 5, child: ScenePanel()),
                        Divider(height: 1, color: Colors.white12),
                        Expanded(flex: 4, child: SourcesPanel()),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, color: Colors.black),

                // 2. Zone Centrale DUAL-MONITORS Broadcast
                Expanded(
                  child: Container(
                    color: const Color(0xFF020617),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              // ÉCRAN 1 : PRÉVISUALISATION (PREVIEW)
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF059669),
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'PRÉVISUALISATION : ${sceneManager.previewScene.nom.toUpperCase()}',
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                          ),
                                          const Text('SORTIE STANDBY', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color(0xFF059669), width: 2),
                                          color: Colors.black,
                                        ),
                                        child: const PreviewCanvas(mode: CanvasMode.preview),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // PUPITRE DE TRANSITION CENTRAL
                              Container(
                                width: 88,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1E293B),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        minimumSize: const Size(72, 38),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      ),
                                      onPressed: () => _triggerCut(sceneManager),
                                      child: const Text('CUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1E293B),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        minimumSize: const Size(72, 38),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      ),
                                      onPressed: () => _triggerTake(sceneManager),
                                      child: const Text('AUTO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                    const SizedBox(height: 16),
                                    // GRAND BOUTON TAKE
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFDC2626),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        minimumSize: const Size(72, 64),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        elevation: 6,
                                      ),
                                      onPressed: () => _triggerTake(sceneManager),
                                      child: const Text('TAKE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1)),
                                    ),
                                  ],
                                ),
                              ),

                              // ÉCRAN 2 : PROGRAMME ON AIR (PROGRAM)
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: onAir ? const Color(0xFFDC2626) : const Color(0xFF7F1D1D),
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'PROGRAMME : ${sceneManager.programScene.nom.toUpperCase()} ${onAir ? "• ON AIR" : ""}',
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                          ),
                                          const Text('FLUX SORTANT', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: onAir ? const Color(0xFFDC2626) : const Color(0xFF7F1D1D), width: 2),
                                          color: Colors.black,
                                        ),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            const PreviewCanvas(mode: CanvasMode.program),

                                            // 1. IMAGE PERMANENTE EN CONTINU (TOUT AU LONG DU LIVE)
                                            if (_imagePermanenteActive && _imagePermanenteUrl != null && _imagePermanenteUrl!.isNotEmpty)
                                              Positioned(
                                                top: 14,
                                                left: 14,
                                                child: Container(
                                                  constraints: const BoxConstraints(maxWidth: 120, maxHeight: 60),
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.4),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Image.network(
                                                    _imagePermanenteUrl!,
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (_, __, ___) => const Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.image, color: Colors.white70, size: 16),
                                                        SizedBox(width: 4),
                                                        Text('IMAGE LIVE', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            // 2. OVERLAY LOGO OFFICIEL
                                            if (_overlayLogoActif)
                                              Positioned(
                                                top: 12,
                                                right: 12,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.7),
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: Colors.white24),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: const [
                                                      Icon(Icons.circle, color: Colors.redAccent, size: 8),
                                                      SizedBox(width: 6),
                                                      Text('EECC LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            // 3. TEXTE & VERSET POSITIONNABLE (Haut-Gauche, Haut-Droit, Bas-Gauche, Bas-Droit ou Défilant)
                                            if (_overlayTitreActif || _overlayVersetActif)
                                              _buildPositionedOverlayWidget(),

                                            // 4. AFFICHE TEMPORISÉE EN DIRECT
                                            StreamBuilder<List<Map<String, dynamic>>>(
                                              stream: EeccSupabaseService().ecouterAffichesActives(pourLive: true, intervalle: const Duration(seconds: 8)),
                                              builder: (context, snapshot) {
                                                final affiches = snapshot.data ?? [];
                                                if (affiches.isEmpty) return const SizedBox.shrink();

                                                final a = affiches.first;
                                                return Positioned(
                                                  bottom: _modeDefilant ? 44 : 14,
                                                  right: 14,
                                                  child: Container(
                                                    constraints: const BoxConstraints(maxWidth: 320),
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFC026D3).withOpacity(0.92),
                                                      borderRadius: BorderRadius.circular(6),
                                                      border: Border.all(color: Colors.white30),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Icon(Icons.campaign, color: Colors.white, size: 20),
                                                        const SizedBox(width: 8),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                a['titre']?.toString() ?? '',
                                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                              const Text(
                                                                'AFFICHE OFFICIELLE EN COURS',
                                                                style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
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
                        const SizedBox(height: 8),

                        // BANCS DE COMMUTATION RAPIDE & HABILLAGE
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            children: [
                              const Text('SCÈNES RAPIDES : ', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              ...List.generate(sceneManager.scenes.length, (i) {
                                final isSelected = (sceneManager.selectedPreviewSceneIndex == i);
                                final isProgram = (sceneManager.programSceneIndex == i);

                                Color btnColor = const Color(0xFF1E293B);
                                if (isProgram) {
                                  btnColor = const Color(0xFFDC2626);
                                } else if (isSelected) {
                                  btnColor = const Color(0xFF059669);
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: btnColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      minimumSize: const Size(60, 32),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    ),
                                    onPressed: () => sceneManager.selectionnerPreview(i),
                                    child: Text(
                                      'S${i + 1}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                    ),
                                  ),
                                );
                              }),
                              const Spacer(),
                              const Text('HABILLAGE : ', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                              _buildOverlayToggle('Titre', _overlayTitreActif, (v) => setState(() => _overlayTitreActif = v)),
                              _buildOverlayToggle('Verset', _overlayVersetActif, (v) => setState(() => _overlayVersetActif = v)),
                              _buildOverlayToggle('Logo', _overlayLogoActif, (v) => setState(() => _overlayLogoActif = v)),
                              const SizedBox(width: 6),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B82F6),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                                icon: const Icon(Icons.tune, size: 14),
                                label: const Text('POSITIONS / IMAGE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                onPressed: _ouvrirConfigOverlay,
                              ),
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
                  width: 240,
                  child: Container(
                    color: const Color(0xFF0F172A),
                    child: const AudioMixerPanel(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black),
          const StatusBar(),
        ],
      ),
    );
  }

  void _ouvrirConfigOverlay() {
    showDialog(
      context: context,
      builder: (_) => OverlayConfigDialog(
        positionInitiale: _positionTexte,
        titreInitial: _titreBandeau,
        sousTitreInitial: _predicateurBandeau,
        permanentImageUrl: _imagePermanenteUrl,
        permanentImageActive: _imagePermanenteActive,
        modeDefilant: _modeDefilant,
        onSave: ({
          required OverlayPosition position,
          required String titre,
          required String sousTitre,
          required String? imageUrl,
          required bool imageActive,
          required bool modeDefilant,
        }) {
          setState(() {
            _positionTexte = position;
            _titreBandeau = titre;
            _predicateurBandeau = sousTitre;
            _imagePermanenteUrl = imageUrl;
            _imagePermanenteActive = imageActive;
            _modeDefilant = modeDefilant;
          });
        },
      ),
    );
  }

  Widget _buildPositionedOverlayWidget() {
    final texteComplet = '$_titreBandeau — $_predicateurBandeau';

    // 1. Si mode défilant
    if (_modeDefilant || _positionTexte == OverlayPosition.bandeauDefilant) {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 32,
          color: const Color(0xFF0F172A).withOpacity(0.95),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(3)),
                child: const Text('DIRECT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ScrollingTickerText(
                  text: texteComplet,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Détermination de la boîte de texte
    final Widget textCard = Container(
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.92),
        borderRadius: BorderRadius.circular(6),
        border: const Border(left: BorderSide(color: Color(0xFF2563EB), width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_titreBandeau, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          if (_predicateurBandeau.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(_predicateurBandeau, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ],
      ),
    );

    // 3. Positionnement selon les 4 coins
    switch (_positionTexte) {
      case OverlayPosition.hautGauche:
        return Positioned(top: 14, left: 14, child: textCard);
      case OverlayPosition.hautDroit:
        return Positioned(top: 14, right: 14, child: textCard);
      case OverlayPosition.basDroit:
        return Positioned(bottom: 14, right: 14, child: textCard);
      case OverlayPosition.basGauche:
      default:
        return Positioned(bottom: 14, left: 14, child: textCard);
    }
  }

  Widget _buildOverlayToggle(String label, bool value, Function(bool) onToggle) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 11, color: Colors.white)),
        selected: value,
        selectedColor: const Color(0xFF2563EB),
        backgroundColor: const Color(0xFF1E293B),
        checkmarkColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
        onSelected: onToggle,
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AudioMixerModal extends StatefulWidget {
  const AudioMixerModal({Key? key}) : super(key: key);

  @override
  State<AudioMixerModal> createState() => _AudioMixerModalState();
}

class _AudioMixerModalState extends State<AudioMixerModal> {
  Timer? _vuTimer;
  final Random _rnd = Random();

  final List<_PisteAudio> _pistes = [
    _PisteAudio(
      id: 'piste_master',
      nom: 'MASTER PGM',
      sourceType: 'Bus Stéréo Sortie',
      gain: 0.85,
      pan: 0.0,
      bass: 0.0,
      mid: 0.0,
      treble: 0.0,
      compresseur: true,
      delayMs: 0,
      isMaster: true,
      vuNiveau: 0.82,
    ),
    _PisteAudio(
      id: 'piste_pasteur',
      nom: 'Pupitre Pasteur',
      sourceType: 'Micro Col de Cygne (HDMI 1)',
      gain: 0.78,
      pan: 0.0,
      bass: -1.5,
      mid: 2.5,
      treble: 1.5,
      compresseur: true,
      delayMs: 25,
      vuNiveau: 0.74,
    ),
    _PisteAudio(
      id: 'piste_sansfil1',
      nom: 'Micro HF Sans-Fil',
      sourceType: 'Émetteur Sans-Fil Ch. 2',
      gain: 0.70,
      pan: -0.15,
      bass: 0.0,
      mid: 1.0,
      treble: 2.0,
      compresseur: true,
      delayMs: 15,
      vuNiveau: 0.60,
    ),
    _PisteAudio(
      id: 'piste_chorale',
      nom: 'Chœur & Chorale',
      sourceType: 'Microphone Ambiance Scène',
      gain: 0.65,
      pan: 0.25,
      bass: 1.0,
      mid: 0.5,
      treble: 1.0,
      compresseur: false,
      delayMs: 0,
      vuNiveau: 0.55,
    ),
    _PisteAudio(
      id: 'piste_piano',
      nom: 'Piano / Clavier',
      sourceType: 'Ligne Directe Stéréo (L/R)',
      gain: 0.72,
      pan: -0.35,
      bass: 2.0,
      mid: 0.0,
      treble: 0.5,
      compresseur: false,
      delayMs: 0,
      vuNiveau: 0.68,
    ),
    _PisteAudio(
      id: 'piste_guitare',
      nom: 'Guitare & Basse',
      sourceType: 'Boîte de Direct (DI Box)',
      gain: 0.60,
      pan: 0.35,
      bass: 3.0,
      mid: -1.0,
      treble: 0.0,
      compresseur: true,
      delayMs: 0,
      vuNiveau: 0.50,
    ),
    _PisteAudio(
      id: 'piste_video',
      nom: 'Audio Vidéo / PC',
      sourceType: 'Flux Système & Diaporamas',
      gain: 0.80,
      pan: 0.0,
      bass: 0.0,
      mid: 0.0,
      treble: 0.0,
      compresseur: false,
      delayMs: 0,
      vuNiveau: 0.70,
    ),
    _PisteAudio(
      id: 'piste_retour',
      nom: 'Retours / Salle',
      sourceType: 'Enceintes de Contrôle Temple',
      gain: 0.55,
      pan: 0.0,
      bass: 0.0,
      mid: 0.0,
      treble: 0.0,
      compresseur: false,
      delayMs: 0,
      vuNiveau: 0.45,
    ),
  ];

  int _selectedTrackIndex = 0;

  @override
  void initState() {
    super.initState();
    // Détection et modulation dynamique des signaux sonores individuels en temps réel
    _vuTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        for (var p in _pistes) {
          if (p.mute) {
            p.vuNiveau = 0.0;
          } else {
            // Détection du signal dynamique indépendante selon l'activité de la piste
            final variance = (_rnd.nextDouble() * 0.16) - 0.08;
            p.vuNiveau = (p.gain * (0.85 + variance)).clamp(0.0, 1.0);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _vuTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pisteActive = _pistes[_selectedTrackIndex];

    return Dialog(
      backgroundColor: const Color(0xFF090D16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1E293B), width: 1.5),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SizedBox(
        width: 1140,
        height: 700,
        child: Column(
          children: [
            // Header Console
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('STUDIO DSP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Console de Mixage Audio Broadcast & Détection Multi-Canaux',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'Détection et traitement du signal sonore en temps réel sur 8 pistes indépendantes',
                        style: TextStyle(fontSize: 11, color: Colors.white54),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Presets rapides
                  _buildPresetButton('Voix Pasteur (Clarté)'),
                  const SizedBox(width: 8),
                  _buildPresetButton('Louange & Chants'),
                  const SizedBox(width: 8),
                  _buildPresetButton('Prédication Calme'),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Corps principal : Pistes + Rack DSP Égaliseur
            Expanded(
              child: Row(
                children: [
                  // 1. Les Tranches de Console (8 Pistes / Faders Verticaux)
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: const Color(0xFF020617),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: _pistes.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final p = entry.value;
                          final isSelected = (_selectedTrackIndex == idx);

                          return Expanded(
                            child: _buildChannelStrip(p, idx, isSelected),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const VerticalDivider(width: 1, color: Color(0xFF1E293B)),

                  // 2. Rack Paramétrique & Traitement DSP (Piste Sélectionnée)
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: const Color(0xFF0B132B),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.tune, color: pisteActive.isMaster ? const Color(0xFF38BDF8) : Colors.amberAccent, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ÉGALISEUR DSP : ${pisteActive.nom.toUpperCase()}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: pisteActive.isMaster ? const Color(0xFF38BDF8) : Colors.amberAccent,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Entrée : ${pisteActive.sourceType}',
                                      style: const TextStyle(fontSize: 10.5, color: Colors.white54),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Panoramique (L <-> R)
                          _buildDspSlider(
                            titre: 'Panoramique (Balance Stéréo)',
                            valeur: pisteActive.pan,
                            min: -1.0,
                            max: 1.0,
                            unite: pisteActive.pan == 0 ? 'C' : (pisteActive.pan < 0 ? 'L ${(pisteActive.pan.abs() * 100).toInt()}%' : 'R ${(pisteActive.pan * 100).toInt()}%'),
                            couleur: Colors.purpleAccent,
                            onChanged: (v) => setState(() => pisteActive.pan = v),
                          ),
                          const Divider(color: Colors.white12, height: 20),

                          // EQ 3 Bandes
                          const Text('ÉGALISATION PARAMÉTRIQUE (EQ 3-BANDES)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70)),
                          const SizedBox(height: 10),

                          _buildDspSlider(
                            titre: 'Basses (Low / 100 Hz)',
                            valeur: pisteActive.bass,
                            min: -12.0,
                            max: 12.0,
                            unite: '${pisteActive.bass > 0 ? "+" : ""}${pisteActive.bass.toStringAsFixed(1)} dB',
                            couleur: Colors.blueAccent,
                            onChanged: (v) => setState(() => pisteActive.bass = v),
                          ),
                          _buildDspSlider(
                            titre: 'Médiums (Mid / 2.5 kHz - Voix)',
                            valeur: pisteActive.mid,
                            min: -12.0,
                            max: 12.0,
                            unite: '${pisteActive.mid > 0 ? "+" : ""}${pisteActive.mid.toStringAsFixed(1)} dB',
                            couleur: Colors.greenAccent,
                            onChanged: (v) => setState(() => pisteActive.mid = v),
                          ),
                          _buildDspSlider(
                            titre: 'Aigus (High / 10 kHz - Clarté)',
                            valeur: pisteActive.treble,
                            min: -12.0,
                            max: 12.0,
                            unite: '${pisteActive.treble > 0 ? "+" : ""}${pisteActive.treble.toStringAsFixed(1)} dB',
                            couleur: Colors.amberAccent,
                            onChanged: (v) => setState(() => pisteActive.treble = v),
                          ),

                          const Divider(color: Colors.white12, height: 20),

                          // Dynamique & Décalage
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Compresseur / Limiteur Broadcast', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                              Switch(
                                value: pisteActive.compresseur,
                                activeColor: const Color(0xFF059669),
                                onChanged: (val) => setState(() => pisteActive.compresseur = val),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          _buildDspSlider(
                            titre: 'Sync Lip / Délai Latence Audio',
                            valeur: pisteActive.delayMs.toDouble(),
                            min: 0,
                            max: 300,
                            unite: '${pisteActive.delayMs} ms',
                            couleur: Colors.orangeAccent,
                            onChanged: (v) => setState(() => pisteActive.delayMs = v.toInt()),
                          ),

                          const Spacer(),
                          // Bouton Réinitialiser la piste
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white70,
                              side: const BorderSide(color: Colors.white24),
                              minimumSize: const Size(double.infinity, 38),
                            ),
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('RÉINITIALISER LES RÉGLAGES DE CETTE PISTE', style: TextStyle(fontSize: 11)),
                            onPressed: () {
                              setState(() {
                                pisteActive.bass = 0.0;
                                pisteActive.mid = 0.0;
                                pisteActive.treble = 0.0;
                                pisteActive.pan = 0.0;
                                pisteActive.delayMs = 0;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer d'application
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: const Color(0xFF0F172A),
              child: Row(
                children: [
                  const Icon(Icons.graphic_eq, color: Colors.greenAccent, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Piste en écoute : ${pisteActive.nom} (${pisteActive.sourceType})',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Réglages de mixage audio sauvegardés.')),
                      );
                    },
                    child: const Text('VALIDER & FERMER', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelStrip(_PisteAudio p, int idx, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTrackIndex = idx),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? (p.isMaster ? const Color(0xFF38BDF8) : Colors.amberAccent)
                : (p.isMaster ? const Color(0xFF1E3A8A) : Colors.white10),
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Titre Piste
            Container(
              height: 32,
              alignment: Alignment.center,
              child: Text(
                p.nom,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: p.isMaster ? const Color(0xFF38BDF8) : Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),

            // Boutons Solo & Mute
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => p.solo = !p.solo),
                    child: Container(
                      height: 22,
                      decoration: BoxDecoration(
                        color: p.solo ? Colors.amber : const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      alignment: Alignment.center,
                      child: Text('S', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: p.solo ? Colors.black : Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => p.mute = !p.mute),
                    child: Container(
                      height: 22,
                      decoration: BoxDecoration(
                        color: p.mute ? Colors.red : const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      alignment: Alignment.center,
                      child: Text('M', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // VU-Meter Vertical + Fader
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // VU-Meter indépendant en temps réel
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                      width: 6,
                      color: Colors.black54,
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: p.vuNiveau,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.green, Colors.yellow, Colors.red],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),

                  // Fader Vertical (Rotated Slider)
                  RotatedBox(
                    quarterTurns: 3,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                        activeTrackColor: p.isMaster ? const Color(0xFF38BDF8) : const Color(0xFF059669),
                        inactiveTrackColor: Colors.white12,
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        value: p.gain,
                        onChanged: (val) => setState(() => p.gain = val),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),
            // dB / Pourcentage
            Text(
              p.mute ? '-∞ dB' : '${(p.gain * 100).toInt()}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: p.mute ? Colors.redAccent : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDspSlider({
    required String titre,
    required double valeur,
    required double min,
    required double max,
    required String unite,
    required Color couleur,
    required Function(double) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(titre, style: const TextStyle(fontSize: 11, color: Colors.white70)),
              Text(unite, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: couleur)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              activeTrackColor: couleur,
              inactiveTrackColor: Colors.white12,
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: valeur,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(String nom) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Préréglage appliqué : $nom'), duration: const Duration(milliseconds: 700)),
        );
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(nom, style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class _PisteAudio {
  final String id;
  final String nom;
  final String sourceType;
  double gain;
  double pan;
  double bass;
  double mid;
  double treble;
  bool compresseur;
  int delayMs;
  bool solo;
  bool mute;
  final bool isMaster;
  double vuNiveau;

  _PisteAudio({
    required this.id,
    required this.nom,
    required this.sourceType,
    required this.gain,
    required this.pan,
    required this.bass,
    required this.mid,
    required this.treble,
    required this.compresseur,
    required this.delayMs,
    this.solo = false,
    this.mute = false,
    this.isMaster = false,
    this.vuNiveau = 0.0,
  });
}

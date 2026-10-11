import 'package:flutter/material.dart';
import 'audio_mixer_modal.dart';

class AudioMixerPanel extends StatefulWidget {
  const AudioMixerPanel({Key? key}) : super(key: key);

  @override
  State<AudioMixerPanel> createState() => _AudioMixerPanelState();
}

class _AudioMixerPanelState extends State<AudioMixerPanel> {
  final Map<String, double> _volumes = {
    'MASTER PGM': 0.85,
    'Pupitre Pasteur': 0.75,
    'Chorale / Chœur': 0.65,
    'Piano & Orgue': 0.70,
    'Retours Salle': 0.50,
  };

  final Map<String, bool> _mutes = {
    'MASTER PGM': false,
    'Pupitre Pasteur': false,
    'Chorale / Chœur': false,
    'Piano & Orgue': false,
    'Retours Salle': false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          color: const Color(0xFF0F172A),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TABLE DE MIXAGE PRO',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 10.5,
                  letterSpacing: 0.8,
                  color: Colors.white70,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.open_in_full, size: 16, color: Color(0xFF38BDF8)),
                tooltip: 'Ouvrir la Console Audio Complète (Égaliseur DSP)',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AudioMixerModal(),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            children: _volumes.keys.map((nom) {
              final isMaster = nom == 'MASTER PGM';
              final volume = _volumes[nom] ?? 0.8;
              final isMuted = _mutes[nom] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isMaster ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isMaster ? const Color(0xFF38BDF8).withOpacity(0.4) : Colors.white10,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          nom,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isMaster ? FontWeight.bold : FontWeight.w500,
                            color: isMaster ? const Color(0xFF38BDF8) : Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() => _mutes[nom] = !isMuted),
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isMuted ? Colors.red : Colors.white10,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isMuted ? 'MUTE' : '${(volume * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: isMuted ? Colors.white : Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // VU-Meter simulé en temps réel
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Container(
                        height: 4,
                        color: Colors.black45,
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: isMuted ? 0.0 : (volume * 0.95),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: volume > 0.85
                                    ? [Colors.green, Colors.yellow, Colors.red]
                                    : [Colors.green, Colors.greenAccent],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                        activeTrackColor: isMaster ? const Color(0xFF38BDF8) : const Color(0xFF059669),
                        inactiveTrackColor: Colors.white12,
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        value: volume,
                        onChanged: (val) => setState(() => _volumes[nom] = val),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

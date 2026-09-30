import 'package:flutter/material.dart';

class AudioMixerPanel extends StatelessWidget {
  const AudioMixerPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Theme.of(context).primaryColor,
          child: const Text('Mixage Audio', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              _buildAudioTrack('Master', 0.8),
              const Divider(),
              _buildAudioTrack('Caméra Principale', 0.9),
              _buildAudioTrack('Micro Pupitre', 0.7),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioTrack(String nom, double volume) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(nom, overflow: TextOverflow.ellipsis)),
          const Icon(Icons.volume_up, size: 20),
          Expanded(
            flex: 2,
            child: Slider(
              value: volume,
              onChanged: (val) {},
              activeColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

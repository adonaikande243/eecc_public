import 'package:flutter/material.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  double _playbackSpeed = 1.0;
  bool _isPlaying = false;
  final double _progress = 0.3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lecteur Audio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text('Culte Dominical', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Prédicateur: Rév. Pasteur', style: TextStyle(fontSize: 18)),
            const Text('Date: 21 Septembre 2026', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 30),
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('15:30'), Text('-30:00')],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.replay_15), iconSize: 40, onPressed: () {}),
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                  iconSize: 64,
                  onPressed: () {
                    setState(() => _isPlaying = !_isPlaying);
                  },
                ),
                IconButton(icon: const Icon(Icons.forward_15), iconSize: 40, onPressed: () {}),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButton<double>(
              value: _playbackSpeed,
              items: [1.0, 1.25, 1.5, 2.0].map((speed) {
                return DropdownMenuItem(
                  value: speed,
                  child: Text('${speed}x'),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _playbackSpeed = val);
              },
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(leading: Icon(Icons.play_arrow), title: Text('1. Chants de louange')),
                  ListTile(leading: Icon(Icons.play_arrow), title: Text('2. Prière pastorale')),
                  ListTile(leading: Icon(Icons.play_arrow), title: Text('3. Prédication')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

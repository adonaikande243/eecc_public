import 'package:flutter/material.dart';

class StreamSettingsScreen extends StatefulWidget {
  const StreamSettingsScreen({Key? key}) : super(key: key);

  @override
  State<StreamSettingsScreen> createState() => _StreamSettingsScreenState();
}

class _StreamSettingsScreenState extends State<StreamSettingsScreen> {
  String _qualite = '1080p';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres de diffusion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Destinations RTMP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.video_library, color: Colors.red),
                title: const Text('YouTube Live'),
                subtitle: const Text('rtmp://a.rtmp.youtube.com/live2'),
                trailing: const Icon(Icons.edit),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.facebook, color: Colors.blue),
                title: const Text('Facebook Live'),
                subtitle: const Text('rtmps://live-api-s.facebook.com:443/rtmp/'),
                trailing: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Encodage Vidéo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _qualite,
              decoration: const InputDecoration(labelText: 'Qualité'),
              items: const [
                DropdownMenuItem(value: '1080p', child: Text('1080p (6000 kbps)')),
                DropdownMenuItem(value: '720p', child: Text('720p (3000 kbps)')),
                DropdownMenuItem(value: '480p', child: Text('480p (1500 kbps)')),
              ],
              onChanged: (val) => setState(() => _qualite = val!),
            ),
          ],
        ),
      ),
    );
  }
}

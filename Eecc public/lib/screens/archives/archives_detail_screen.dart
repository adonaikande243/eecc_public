import 'package:flutter/material.dart';

class ArchivesDetailScreen extends StatelessWidget {
  const ArchivesDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Détails de l\'archive'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.video_library), text: 'Vidéo'),
              Tab(icon: Icon(Icons.audiotrack), text: 'Audio'),
              Tab(icon: Icon(Icons.article), text: 'Résumé'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildVideoTab(),
            _buildAudioTab(),
            _buildSummaryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.black,
            child: const Center(child: Icon(Icons.play_circle_outline, color: Colors.white, size: 60)),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('1080p')),
              ElevatedButton(onPressed: () {}, child: const Text('720p')),
              ElevatedButton(onPressed: () {}, child: const Text('480p')),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.fullscreen), label: const Text('Plein écran')),
        ],
      ),
    );
  }

  Widget _buildAudioTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.audiotrack, size: 100, color: Colors.blue),
          const SizedBox(height: 20),
          const Text('Audio MP3 - Culte'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.fast_rewind), onPressed: () {}),
              IconButton(icon: const Icon(Icons.play_arrow, size: 40), onPressed: () {}),
              IconButton(icon: const Icon(Icons.fast_forward), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thème: La foi victorieuse', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('Orateur: Pasteur Principal', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
          const SizedBox(height: 10),
          const Text('Introduction: Ce culte nous rappelle l\'importance de garder une foi inébranlable...'),
          const SizedBox(height: 10),
          const Text('Points Principaux:', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('1. L\'origine de la foi\n2. Les épreuves de la foi\n3. La victoire par la foi'),
          const SizedBox(height: 10),
          const Text('Versets Clés:', style: TextStyle(fontWeight: FontWeight.bold)),
          InkWell(
            onTap: () {},
            child: const Text('Hébreux 11:1', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
          ),
          const SizedBox(height: 10),
          const Text('Prière d\'application: Seigneur, augmente notre foi...'),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Télécharger le résumé en PDF'),
            ),
          ),
        ],
      ),
    );
  }
}

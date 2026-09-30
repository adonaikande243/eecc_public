import 'package:flutter/material.dart';
import 'archives_detail_screen.dart';

class ArchivesListScreen extends StatelessWidget {
  const ArchivesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Archives des cultes')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.movie),
            title: Text('Culte du Dimanche ${index + 1}'),
            subtitle: const Text('Thème : La foi en action'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArchivesDetailScreen()),
              );
            },
          );
        },
      ),
    );
  }
}
